pipeline {
    agent any

    stages {
        stage('Infrastructure - Downloads') {
            agent {
                label 'win'
            }
            steps {
                echo 'Copying Windows Image...'
                powershell 'cd sp2016dev; New-Item -Path images/packer_cache -ItemType Directory -Force | Out-Null; Copy-Item C:/sp-onprem-files/524abd34eb2abcc5e5a12da5b1c97fa3a6a626a831c29b4e74801f4131fb08ed.iso ./images/packer_cache'
                powershell 'cd sp2016dev; if ( !( Get-Item ./images/packer_cache/524abd34eb2abcc5e5a12da5b1c97fa3a6a626a831c29b4e74801f4131fb08ed.iso -ErrorAction Ignore ) ) { Write-Host "Windows Server 2016 image missing"; exit 1 }'
                powershell '(Resolve-Path ./).Path'
                powershell 'cd sp2013dev; New-Item -Path images/packer_cache -ItemType Directory -Force | Out-Null; Copy-Item C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso ./images/packer_cache'
                powershell 'cd sp2013dev; if ( !( Get-Item ./images/packer_cache/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso -ErrorAction Ignore ) ) { Write-Host "Windows Server 2012 R2 image missing"; exit 1 }'
            }
        }
        stage('Infrastructure - Removing existing VM images') {
            agent {
                label 'win'
            }
            steps {
                powershell 'cd sp2016dev/images; ./removevmimages.ps1'
                powershell 'if ( vagrant box list | ? { $_ -like "sp-win2016-db-web-code *" } ) { exit 1 }'
                powershell 'cd sp2013dev/images; ./removevmimages.ps1'
                powershell 'if ( vagrant box list | ? { $_ -like "sp-win2012r2-db-web-code *" } ) { exit 1 }'
            }
        }
        stage('Infrastructure - Creating VM images') {
            agent {
                label 'win'
            }
            steps {
                powershell 'cd sp2016dev/images; ./preparevmimages.ps1'
                powershell 'if ( !( vagrant box list | ? { $_ -like "sp-win2016-db-web-code *" } ) ) { exit 1 }'
                powershell 'cd sp2013dev/images; ./preparevmimages.ps1'
                powershell 'if ( !( vagrant box list | ? { $_ -like "sp-win2012r2-db-web-code *" } ) ) { exit 1 }'
            }
        }
        stage('Infrastructure - VMs') {
            agent {
                label 'win'
            }
            steps {
                echo 'Building farms'
            }
        }
    }
}