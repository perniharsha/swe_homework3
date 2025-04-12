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

        stage('Push image to Docker Hub') {
            steps {
                sh 'docker push perni007/backend:latest'
            }
        }
        
        stage('Deploying on Kubernetes') {
            steps {
                sh 'kubectl set image deployment/hw3swe container-0=perni007/backend:latest -n default'
                sh 'kubectl rollout restart deploy backenddemo -n default'
            }
        }
    }
    
    post {
        always {
            node {
                script {
                    try {
                        sh 'docker logout'
                    } catch (err) {
                        echo "Docker logout failed, maybe Docker wasn’t logged in: ${err}"
                    }
                }
            }
        }
    }
}
