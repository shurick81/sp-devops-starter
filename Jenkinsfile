pipeline {
    agent any

    stages {
        stage('Infrastructure - Downloads') {
            agent {
                label 'win'
            }
            steps {
                echo 'Copying Windows Image...'
                powershell "cd sp2013dev; New-Item -Path packer_cache -ItemType Directory -Force | Out-Null; Copy-Item C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso ./images/packer_cache"
                powershell "cd sp2013dev; if ( !( Get-Item ./images/packer_cache/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso -ErrorAction Ignore ) ) { exit 1 }"
            }
        }
        stage('Infrastructure - Creating VM images') {
            agent {
                label 'win'
            }
            steps {
                powershell "cd sp2013dev/images; ./preparevmimages.ps1"
            }
        }
        stage('Infrastructure - VMs') {
            agent {
                label 'win'
            }
            steps {
                echo 'Building a farm....'
            }
        }
    }
}