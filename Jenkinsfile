pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/shanky528/SPARTA-DevSecOps-Pipeline.git'
        SONARQUBE_SERVER_URL = 'http://loalhost:9000'    // Change to your SonarQube server URL/IP and port
        VM_IP = '10.0.2.15'
        VM_USER = 'vagrant'
        SSH_CREDENTIALS_ID = 'ssh-deploy'
        TERRAFORM_DIR = 'C:\\terraform_vm'
        ZAP_PATH = 'C:\\Program Files\\OWASP\\ZAP\\zap.bat'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: env.REPO_URL, branch: 'main'
            }
        }

        stage('Build & Validate') {
            steps {
                bat 'echo Building and validating static website...'
                // Add build commands here if needed
            }
        }

        stage('SAST - SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SonarQube-Token', variable: 'SONAR_TOKEN')]) {
                    bat """
                    "C:\\sonar-scanner\\bin\\sonar-scanner.bat" ^
                    -Dsonar.projectKey=static-website ^
                    -Dsonar.sources=. ^
                    -Dsonar.login=%SONAR_TOKEN% ^
                    -Dsonar.host.url=${env.SONARQUBE_SERVER_URL}
                    """
                }
            }
        }

        stage('IaC - Terraform Provisioning') {
            steps {
                dir(env.TERRAFORM_DIR) {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    bat """
                    pscp -r -i %USERPROFILE%\\.ssh\\id_rsa * ${env.VM_USER}@${env.VM_IP}:/var/www/html/
                    """
                }
            }
        }

        stage('DAST - OWASP ZAP Scan') {
            steps {
                bat "\"${env.ZAP_PATH}\" -cmd -quickurl http://${env.VM_IP} -quickout zap-report.html"
                archiveArtifacts 'zap-report.html'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs and reports.'
        }
        always {
            cleanWs()
        }
    }
}
