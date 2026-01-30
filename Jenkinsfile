pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['build', 'deploy', 'remove'],
            description: 'Choose action: build, deploy or remove'
        )
    }

    environment {
        DOCKERHUB_USER = "venkateshjaggaraju"     // must be lowercase
        IMAGE_NAME = "bunny"
        FULL_IMAGE = "${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
        DOCKER_CREDENTIALS_ID = "deploying_spring_jar_project_dockerfile_dockercompose_automatingByJenkins"
    }

    stages {

        // ================= BUILD =================
        stage('Build Docker Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh '''
                  echo "Building Docker image..."
                  docker build -t ${FULL_IMAGE} .
                '''
            }
            post {
                success { echo "✅ Docker image built" }
                failure { echo "❌ Docker build failed" }
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
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
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
                sh '''
                  docker push ${FULL_IMAGE}
                '''
            }
            post {
                success { echo "✅ Image pushed to DockerHub" }
                failure { echo "❌ Docker push failed" }
            }
        }

        stage('Remove Local Image') {
            when { expression { params.ACTION == 'build' } }
            steps {
                sh '''
                  docker rmi ${FULL_IMAGE} || true
                '''
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
                success { echo "🔓 Docker logout done" }
                failure { echo "⚠️ Docker logout failed" }
            }
        }

        // ================= DEPLOY =================
        stage('Deploy using Docker Compose') {
            when { expression { params.ACTION == 'deploy' } }
            steps {
                sh '''
                  docker-compose down || true
                  docker-compose up -d --build
                '''
            }
            post {
                success { echo "🚀 Application deployed" }
                failure { echo "❌ Deployment failed" }
            }
        }

        // ================= REMOVE =================
        stage('Remove Application') {
            when { expression { params.ACTION == 'remove' } }
            steps {
                sh '''
                  docker-compose down || true
                  docker system prune -af
                '''
            }
            post {
                success { echo "🗑️ Application removed" }
                failure { echo "❌ Remove failed" }
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
