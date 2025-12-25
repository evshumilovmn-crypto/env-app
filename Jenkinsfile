/* Requires the Docker Pipeline plugin */
pipeline {
    agent { docker { image 'node:22.17.0' } }
    stages {
        stage('build') {
            steps {
                sh 'node --version'
            }
        }
    }
}
