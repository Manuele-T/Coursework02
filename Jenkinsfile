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

        stage('Test Container') {
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker run -d --name test-container -p 8080:8080 manuelet/cw02:${commitHash}"
                    // Wait for 10 seconds
                    sh "sleep 10" 
                    // Curl command – build test
                    sh "curl -s http://localhost:8080"
                    // Stop and remove the test container after the test
                    sh "docker stop test-container"
                    sh "docker rm test-container"
                }
            }
        }
    }
}
