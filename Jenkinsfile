pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['build', 'deploy', 'remove'], description: 'Choose action: build / deploy / remove')
    }

    environment {
        IMAGE_NAME = "yourdockerhubusername/myapp"
        IMAGE_TAG = "latest"
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {

        stage('Build Docker Image & Push') {
            when {
                expression { params.ACTION == 'build' }
            }
            steps {
                script {
                    sh '''
                    echo "Building Docker image..."
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .

                    echo "Tagging image..."
                    docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$IMAGE_TAG

                    echo "Logging into DockerHub..."
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin

                    echo "Pushing image..."
                    docker push $IMAGE_NAME:$IMAGE_TAG

                    echo "Removing local image..."
                    docker rmi $IMAGE_NAME:$IMAGE_TAG || true

                    echo "Docker logout..."
                    docker logout
                    '''
                }
            }
            post {
                success {
                    echo "✅ Build & Push stage completed successfully"
                }
                failure {
                    echo "❌ Build & Push stage failed"
                }
                always {
                    echo "Build stage finished"
                }
            }
        }

        stage('Deploy Application') {
            when {
                expression { params.ACTION == 'deploy' }
            }
            steps {
                script {
                    sh '''
                    echo "Deploying application using docker-compose..."
                    docker-compose down || true
                    docker-compose up -d --build
                    '''
                }
            }
            post {
                success {
                    echo "✅ Deployment successful"
                }
                failure {
                    echo "❌ Deployment failed"
                }
                always {
                    echo "Deploy stage finished"
                }
            }
        }

        stage('Remove Application') {
            when {
                expression { params.ACTION == 'remove' }
            }
            steps {
                script {
                    sh '''
                    echo "Stopping and removing containers..."
                    docker-compose down

                    echo "Removing unused images..."
                    docker image prune -f
                    '''
                }
            }
            post {
                success {
                    echo "✅ Remove stage completed"
                }
                failure {
                    echo "❌ Remove stage failed"
                }
                always {
                    echo "Remove stage finished"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution finished"
        }
        success {
            echo "🎉 Pipeline succeeded"
        }
        failure {
            echo "⚠️ Pipeline failed"
        }
    }
}
