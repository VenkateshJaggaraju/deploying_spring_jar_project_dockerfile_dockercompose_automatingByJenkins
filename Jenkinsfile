pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Select build, deploy, or remove'
        )
    }

    environment {
        IMAGE_NAME = "your_dockerhub_username/your_image_name:latest"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds-id"
    }

    stages {

        // ================= BUILD FLOW =================
        stage('Build Docker Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
            post {
                success { echo "✅ Docker image built successfully" }
                failure { echo "❌ Docker image build failed" }
            }
        }

        stage('Docker Login') {
            when { expression { params.ACTION == 'build' } }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
            post {
                success { echo "✅ Docker login successful" }
                failure { echo "❌ Docker login failed" }
            }
        }

        stage('Docker Push') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker push $IMAGE_NAME'
            }
            post {
                success { echo "✅ Image pushed to DockerHub" }
                failure { echo "❌ Docker push failed" }
            }
        }

        stage('Remove Local Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker rmi $IMAGE_NAME || true'
            }
            post {
                success { echo "🧹 Local image removed" }
                failure { echo "⚠️ Failed to remove local image" }
            }
        }

        stage('Docker Logout') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh 'docker logout'
            }
            post {
                success { echo "🔓 Docker logout successful" }
                failure { echo "⚠️ Docker logout failed" }
            }
        }

        // ================= DEPLOY FLOW =================
        stage('Deploy using Docker Compose') {
            when { expression { params.ACTION == 'deploy' } }
            steps {
                sh '''
                  docker-compose down || true
                  docker-compose up -d --build
                '''
            }
            post {
                success { echo "🚀 Application deployed successfully" }
                failure { echo "❌ Deployment failed" }
            }
        }

        // ================= REMOVE FLOW =================
        stage('Remove Application') {
            when { expression { params.ACTION == 'remove' } }
            steps {
                sh '''
                  docker-compose down
                  docker system prune -f
                '''
            }
            post {
                success { echo "🗑️ Application removed successfully" }
                failure { echo "❌ Remove operation failed" }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished with action: ${params.ACTION}"
        }
        success {
            echo "🎉 Pipeline completed successfully"
        }
        failure {
            echo "🔥 Pipeline failed"
        }
    }
}
