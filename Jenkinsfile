stage('SAST - SonarQube') {
    steps {
        script {
            withSonarQubeEnv('sonarqube') {
                def scannerHome = tool 'SonarScanner'
                bat """
                "${scannerHome}\\bin\\sonar-scanner.bat" ^
                  -Dsonar.projectKey=webapp ^
                  -Dsonar.sources=. ^
                  -Dsonar.java.binaries=. ^
                  -Dsonar.host.url=%SONAR_HOST_URL%
                """
            }
        }
    }
}
