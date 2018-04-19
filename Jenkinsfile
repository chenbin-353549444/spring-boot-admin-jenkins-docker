#!groovy
pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.5.0-jdk-8-alpine'
                    args '-v mavenRepository:/root/.m2'
                }
            }
            steps {
                sh 'mvn -B -DskipTests clean package --settings settings.xml'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.5.0-jdk-8-alpine'
                    args '-v mavenRepository:/root/.m2'
                }
            }
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
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