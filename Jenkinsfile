#!groovy
pipeline {
    agent none
    stages {
        stage('Deliver') {
            agent any
            steps {
                sh 'sh run.sh'
            }
        }
    }
    post {
        always {
            mail body: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - ${currentBuild.currentResult}: Check console output at ${env.BUILD_URL} to view the results.",
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - ${currentBuild.currentResult}!",
                    to: '353549444@qq.com'
        }
    }
}