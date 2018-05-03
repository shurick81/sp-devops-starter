pipeline {
    agent { label 'sharepoint' }

    stages {
        stage('Prepare') {
            steps {
                echo 'Waiting for infrastructure'
                sleep 150
            }
        }
        stage('Build') {
            steps {
                echo 'Building the solution'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the solution'
                powershell './src/spfarm_2013.ps1'
                powershell './src/sampleps.ps1'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }
    }
}