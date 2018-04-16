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
                echo 'Ensuring downloads are in place...'
                powershell "Copy-Item C:/sp-devops-starter-files/en_sharepoint_server_2013_with_sp1_x64_dvd_3823428.iso ."
            }
        }
        stage('Infrastructure - Images') {
            agent {
                label 'win'
            }
            steps {
                echo 'Running packer for building images'
                bat "cd sp2013dev && packer build sp-win2012r2-db-web-code.json"     
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