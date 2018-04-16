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
                label 'vbox-win'
            }
            steps {
                echo 'Ensuring downloads are in place...'
                bat "echo %CD%"     
            }
        }
        stage('Infrastructure - Images') {
            agent {
                label 'vbox-win'
            }
            steps {
                echo 'Running packer for building images'
                bat "cd sp2013dev && packer build sp-win2012r2-db-web-code.json"     
            }
        }
        stage('Infrastructure - VMs') {
            agent {
                label 'vbox-win'
            }
            steps {
                echo 'Building a farm....'
            }
        }
    }
}