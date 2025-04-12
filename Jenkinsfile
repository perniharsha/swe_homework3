pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage('Build') {
            steps {
                sh 'rm -rf *.var'
                sh 'jar -cvf survey0.1-0.0.1-SNAPSHOT.jar -C "src/main" .'
                sh 'docker build -t perni007/backend:latest .'
            }
        }

        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage("Push image to docker hub") {
            steps {
                sh 'docker push perni007/backend:latest'
            }
        }

        stage("Deploying on K8") {
            steps {
                sh 'kubectl set image deployment/hw3swe container-0=perni007/backend:latest -n default'
                sh 'kubectl rollout restart deploy hw3swe -n default'
            }
        }

        stage("Cleanup") {
            steps {
                sh 'docker logout'
            }
        }
    }
}
