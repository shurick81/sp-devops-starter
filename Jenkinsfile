pipeline {
    agent { label 'sharepoint' }

    stages {
        stage('Build') {
            steps {
                echo 'Building the solution'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the solution'
                powershell './infrastructure/sp2013dev/images/sppsmodules.ps1'
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