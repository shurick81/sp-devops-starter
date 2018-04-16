pipeline {
    agent any

    stages {
        stage('Greeting') {
            steps {
                echo 'Hello!'
            }
        }
        stage('Infrastructure - Downloads') {
            agent {
                label 'win'
            }
            steps {
                echo 'Copying Windows Image...'
                powershell "cd sp2013dev; Copy-Item C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso ./packer_cache"
                powershell "cd sp2013dev; if ( !( Get-Item ./packer_cache/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso -ErrorAction -Ignore ) ) { exit 1 }"
            }
        }
        stage('Infrastructure - Creating VM images') {
            agent {
                label 'win'
            }
            steps {
                echo 'Running packer for building image'
                powershell "cd sp2013dev; packer build sp-win2012r2-db-web-code.json"
                powershell "cd sp2013dev; if ( !( Get-Item sp-win2012r2-web-code.box -ErrorAction -Ignore ) ) { exit 1 }"
                echo 'Running vagrant for removing old image'
                powershell "cd sp2013dev; if ( ( vagrant box list | ? { $_ -like "sp-win2012r2-web-code *" } ) ) { vagrant box remove sp-win2012r2-web-code --force" }
                powershell "cd sp2013dev; if ( ( vagrant box list | ? { $_ -like "sp-win2012r2-web-code *" } ) ) { exit 1 }"
                echo 'Running vagrant for adding image'
                powershell "cd sp2013dev; vagrant box add sp-win2012r2-web-code.box --force --name sp-win2012r2-web-code"
                powershell "cd sp2013dev; if ( !( vagrant box list | ? { $_ -like "sp-win2012r2-web-code *" } ) ) { exit 1 }"
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