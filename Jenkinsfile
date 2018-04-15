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
            }
        }
        stage('Infrastructure - Images') {
            agent {
                label 'hypervisor'
            }
            steps {
                cd sp2013dev && packer build sp-win2012r2-db-web-code.json
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