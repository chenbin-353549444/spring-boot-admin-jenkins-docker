#!groovy
pipeline {
    agent any

    stages {
        
        stage('hello') {
            steps {
                sh 'sh run.sh'
            }
        }
        
    }
    
    post {
        always {
            echo "${env.BUILD_STATUS}"
        }
    }
}