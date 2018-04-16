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
                label 'hypervisor'
            }
            steps {
                echo 'Ensuring downloads are in place...'
                sh "echo %CD%"     
            }
        }
        stage('Infrastructure - Images') {
            agent {
                label 'hypervisor'
            }
            steps {
                echo 'Running packer for building images'
                sh "cd sp2013dev && packer build sp-win2012r2-db-web-code.json"     
            }
        }
        stage('Infrastructure - VMs') {
            agent {
                label 'hypervisor'
            }
            steps {
                echo 'Building a farm....'
            }
        }
    }
}