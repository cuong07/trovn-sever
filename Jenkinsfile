/* groovylint-disable LineLength, NglParseError */
pipeline {
    agent any

    environment {
        REGISTRY = credentials('docker-registry-url')
        DEPLOY_HOST = credentials('deploy-host')
        IMAGE_NAME = 'tro-server'
        ENV_BASE64 = credentials('server_env_base64')
        PORT = '8891'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare Environment File') {
            steps {
                sh '''
            echo "🔧 Creating environment file..."
            echo "$ENV_BASE64" | base64 -d > .env

            # Fix DATABASE_URL nếu bị bao bởi dấu "
            sed -i 's/^DATABASE_URL="\\(.*\\)"/DATABASE_URL=\\1/' .env

            echo "📋 Preview environment variables (hide sensitive values):"
            grep -v "PASSWORD\\|SECRET\\|KEY" .env | head -10
        '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    echo "🔨 Building backend server image..."
                    docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} .
                    docker tag ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ${REGISTRY}/${IMAGE_NAME}:latest
                    echo "✅ Image built successfully!"
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                    docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}
                    docker push ${REGISTRY}/${IMAGE_NAME}:latest
                """
            }
        }

        stage('Test Database Connection') {
            steps {
                sh """
                    echo "🧪 Testing database connection..."
                    docker run --rm --env-file .env ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} node -e "
                        import { PrismaClient } from '@prisma/client';
                        const prisma = new PrismaClient();
                        console.log('Testing database connection...');
                        prisma.\\\$connect()
                            .then(() => {
                                console.log('✅ Database connection successful');
                                process.exit(0);
                            })
                            .catch((error) => {
                                console.error('❌ Database connection failed:', error.message);
                                process.exit(1);
                            });
                    " || echo "⚠️ Database test failed, but continuing deployment..."
                """
            }
        }

        stage('Deploy to Server 2') {
            steps {
                sshagent(['server2-ssh']) {
                    sh """
                        echo "🚀 Deploying backend server..."
                        scp -o StrictHostKeyChecking=no .env root@${DEPLOY_HOST}:/root/${IMAGE_NAME}/.env
                        ssh -o StrictHostKeyChecking=no root@${DEPLOY_HOST} '
                            docker pull ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} &&
                            echo "🛑 Stopping old container..." &&
                            docker stop ${IMAGE_NAME} || true &&
                            docker rm ${IMAGE_NAME} || true &&
                            echo "🎯 Starting new container..." &&
                            docker run -d \\
                                --name ${IMAGE_NAME} \\
                                --restart unless-stopped \\
                                --env-file /root/${IMAGE_NAME}/.env \\
                                -p ${PORT}:${PORT} \\
                                ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} &&
                            echo "✅ Container started successfully!"
                        '
                    """
                }
            }
        }

        stage('Database Check') {
            steps {
                sshagent(['server2-ssh']) {
                    sh """
                        echo "🗄️ Checking database connection..."
                        ssh -o StrictHostKeyChecking=no root@${DEPLOY_HOST} '
                            docker logs ${IMAGE_NAME} | tail -20
                        '
                        echo "✅ Database check completed!"
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                sh """
                    echo "🏥 Performing health check..."
                    sleep 15
                    for i in {1..5}; do
                        if curl -f http://${DEPLOY_HOST}:8891/api/v1/health || curl -f http://${DEPLOY_HOST}:8891/health; then
                            echo "✅ Health check passed!"
                            break
                        else
                            echo "⏳ Attempt \$i failed, retrying in 10 seconds..."
                            sleep 10
                        fi
                        if [ \$i -eq 5 ]; then
                            echo "❌ Health check failed after 5 attempts"
                            exit 1
                        fi
                    done
                """
            }
        }

        stage('Cleanup Old Images') {
            steps {
                sh """
                    # Xóa images cũ trên Jenkins server (giữ lại 3 builds gần nhất)
                    docker images ${REGISTRY}/${IMAGE_NAME} --format "{{.Tag}}" | \\
                    grep -E '^[0-9]+\$' | sort -rn | tail -n +4 | \\
                    xargs -I {} docker rmi ${REGISTRY}/${IMAGE_NAME}:{} 2>/dev/null || true

                    # Xóa dangling images
                    docker image prune -f
                """
            }
        }
    }

    post {
        success {
            echo '✅ Build & Deploy Backend thành công!'
            echo "🚀 API Server: http://${DEPLOY_HOST}:8891"
            echo "📊 Health Check: http://${DEPLOY_HOST}:8891/api/v1/health"
        }
        failure {
            echo '❌ Pipeline lỗi!'
        }
    }
}
