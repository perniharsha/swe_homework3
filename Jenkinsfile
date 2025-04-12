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

        stage('Build HTML Image') {
            steps {
                // Build the Docker image for the HTML application
                sh 'docker build -t perni007/backend:latest -f Dockerfile .'
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

        stage('Deploying on K8') {
            steps {
                sh 'kubectl set image deployment/hw3swe container-0=perni007/backend:latest -n default'
                sh 'kubectl rollout restart deploy backenddemo -n default'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
