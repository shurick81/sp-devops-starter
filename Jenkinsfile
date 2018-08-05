pipeline {
    agent { label 'sharepoint' }

    stages {
        stage('Prepare') {
            steps {
                echo 'Waiting for infrastructure'
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
                powershell './src/spfarm/spfarm_customizations.ps1'
                powershell './src/spfarm/farmtest.ps1'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }
    }
}