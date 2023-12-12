pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    sh "docker build -t manuelet/cw02:${commitHash} ." // Builds a Docker image from your Dockerfile
                }
            }
        }
    }
}
