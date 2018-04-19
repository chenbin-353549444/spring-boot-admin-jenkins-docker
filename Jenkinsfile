pipeline {
    agent {
        docker {
            image 'maven:3.5.0-jdk-8-alpine'
            args '-v /root/.m2:/root/.m2'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package --settings settings.xml'
            }
        }
        stage('Test') {
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
            steps {
                sh 'sh run.sh'
            }
        }
    }
}