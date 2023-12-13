pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker build -t manuelet/cw02:${commitHash} ."
                }
            }
        }

        stage('Test Container') {  // Build test
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker rm -f test-container || true" // Clean up any previous container
                    sh "docker run -d --name test-container -p 8090:8080 manuelet/cw02:${commitHash}"
                    sh "sleep 10"
                    sh "curl -s http://localhost:8090" // Test container response
                    sh "docker stop test-container"
                    sh "docker rm test-container"
                }
            }
        }

        stage('Push to DockerHub') { // Push the image to DockerHub
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker login -u manuelet -p Manu@@docker1986++" // Docker Hub login
                    sh "docker push manuelet/cw02:${commitHash}" // Push the image
                }
            }
        }
    }
}

Trying Step E

pipeline {
    agent any // Use any available agent to run the pipeline

    stages {
        stage('Build Docker Image') { // Build the Docker image 
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim() // Set the current commit hash as tag
                    sh "docker build -t manuelet/cw02:${commitHash} ."
                }
            }
        }

        stage('Test Container') { // Test the image by running it as a container
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker rm -f test-container || true" // Remove any existing container
                    sh "docker run -d --name test-container -p 8090:8080 manuelet/cw02:${commitHash}"
                    sh "sleep 10" // Allow time for the container to start
                    sh "curl -s http://localhost:8090" // Perform a curl test
                    sh "docker stop test-container" // Stop the container
                    sh "docker rm test-container" // Remove the container
                }
            }
        }

        stage('Push to DockerHub') { // Push the image to DockerHub
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker login -u manuelet -p Manu@@docker1986++" // Login to Docker Hub
                    sh "docker push manuelet/cw02:${commitHash}" // Push the image with the commit hash tag
                }
            }
        }

        stage('Deploy to Kubernetes') { // Update Kubernetes deployment with the new image
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "kubectl set image deployment/cw02 cw02=manuelet/cw02:${commitHash} --record" // Perform a rolling update on the cw02 deployment
                }
            }
        }
    }
}
