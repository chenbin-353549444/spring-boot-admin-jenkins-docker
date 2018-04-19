pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.5.0-jdk-8-alpine'
                    args '-v /root/.m2:/root/.m2'
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
                    args '-v /root/.m2:/root/.m2'
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
}