pipeline {
    agent any

    tools {
        jdk 'java'
        maven 'maven'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {

        stage('Maven Clean') {
            steps {
                script {
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Build JAR & Docker Image') {
            steps {
                script {
                    sh 'rm -rf *.var'
                    sh 'jar -cvf survey0.1-0.0.1-SNAPSHOT.jar -C "src/main" .'
                    sh 'docker build -t perni007/backend:latest .'
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    sh 'docker push perni007/backend:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl set image deployment/hw3swe container-0=perni007/backend:latest -n default'
                    sh 'kubectl rollout restart deploy backenddemo -n default'
                }
            }
        }
    }

    post {
        always {
            node {  // Fix: ensure Jenkins has a workspace to run shell commands
                script {
                    try {
                        sh 'docker logout'
                    } catch (err) {
                        echo "Docker logout failed or Docker daemon not running: ${err}"
                    }
                }
            }
        }
    }
}
