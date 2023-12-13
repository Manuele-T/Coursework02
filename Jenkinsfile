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
                    sh "docker login -u manuelet -p Password@123" // Docker Hub login
                    sh "docker push manuelet/cw02:${commitHash}" // Push the image
                }
            }
        }
    }
}
