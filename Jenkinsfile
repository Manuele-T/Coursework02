pipeline {
    agent any
    environment { // start 1
        DOCKER_BUILDKIT = "1"
    }
    stages {
        stage('Build Docker Image') { // Build image again
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    // Build Docker image with commit hash as tag
                    sh "docker build -t manuelet/cw02:${commitHash} ."
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    // Remove any existing container, run new container to test, then cleanup
                    sh "docker rm -f test-container || true"
                    sh "docker run -d --name test-container -p 8090:8080 manuelet/cw02:${commitHash}"
                    sh "sleep 10"
                    sh "curl -s http://localhost:8090"
                    sh "docker stop test-container"
                    sh "docker rm test-container"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    // Login to Docker Hub and push the image
                    sh "docker login -u manuelet -p Manu@@docker1986++"
                    sh "docker push manuelet/cw02:${commitHash}"
                }
            }
        }

        stage('Deploy to Kubernetes') { //
            steps {
                sshagent(['my-ssh-key']) {
                    script {
                        def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        // Deploy to Kubernetes using kubectl via SSH
                        sh "ssh jenkins@172.31.89.25 'kubectl set image deployment/cw02 cw02=manuelet/cw02:${commitHash} --record'"
                    }
                }
            }
        }
    }
}
