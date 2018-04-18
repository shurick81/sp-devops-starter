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
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }
    }
}