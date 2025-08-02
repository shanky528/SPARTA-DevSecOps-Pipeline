stage('SAST - SonarQube') {
    steps {
        script {
            // Use the configured SonarQube environment and scanner
            withSonarQubeEnv('sonarqube') {
                def scannerHome = tool 'SonarScanner'
                sh """
                ${scannerHome}/bin/sonar-scanner \
                  -Dsonar.projectKey=webapp \
                  -Dsonar.sources=. \
                  -Dsonar.java.binaries=. \
                  -Dsonar.host.url=$SONAR_HOST_URL
                """
            }
        }
    }
}
