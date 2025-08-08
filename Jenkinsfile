pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/shanky528/SPARTA-DevSecOps-Pipeline.git'
        SONARQUBE_SERVER = 'SonarQubeServer'         // Jenkins SonarQube config name
        VM_IP = '10.0.2.15'                          // Your VM IP from Terraform
        VM_USER = 'vagrant'                          // VM SSH user
        SSH_CREDENTIALS_ID = 'ssh-deploy'            // Jenkins credentials ID for SSH private key
        SONAR_SCANNER = 'C:\\sonar-scanner\\bin\\sonar-scanner.bat'  // Adjust path if needed
        TERRAFORM_DIR = 'C:\\terraform_vm'           // Your Terraform config folder
        ZAP_PATH = 'C:\\Program Files\\OWASP\\ZAP\\zap.bat' // OWASP ZAP path
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
                // Add build or validation commands here if needed
            }
        }

        stage('SAST - SonarQube Analysis') {
            steps {
                withSonarQubeEnv(env.SONARQUBE_SERVER) {
                    bat "\"${env.SONAR_SCANNER}\" -Dsonar.projectKey=static-website -Dsonar.sources=."
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


