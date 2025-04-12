pipeline {
    agent any

    tools {
        jdk 'java'      // must match your configured name in Jenkins: "Manage Jenkins" -> "Global Tool Configuration"
        maven 'maven'   // same here: check the exact Maven installation name
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')  // must match your Jenkins Credentials ID
    }

    stages {
        stage('Maven Clean') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Prepare Jar & Build Docker Image') {
            steps {
                sh '''
                    rm -rf *.var
                    jar -cvf survey0.1-0.0.1-SNAPSHOT.jar -C src/main .
                    docker build -t perni007/backend:latest .
                '''
            }
        }

        stage('Build HTML Image') {
            steps {
                sh 'docker build -t perni007/backend:latest -f Dockerfile .'
            }
        }

        stage('Docker Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh 'docker push perni007/backend:latest'
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                sh '''
                    kubectl set image deployment/hw3swe container-0=perni007/backend:latest -n default
                    kubectl rollout restart deployment backenddemo -n default
                '''
            }
        }
    }

    post {
        always {
            script {
                try {
                    sh 'docker logout'
                } catch (err) {
                    echo "Docker logout failed, likely already logged out or Docker daemon not available: ${err}"
                }
            }
        }
    }
}
