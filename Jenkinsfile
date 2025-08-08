pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/shanky528/SPARTA-DevSecOps-Pipeline.git'
        SONARQUBE_SERVER_URL = 'http://localhost:9000'    // Change to your SonarQube server URL/IP and port
        VM_IP = '10.0.2.15'
        VM_USER = 'vagrant'
        SSH_CREDENTIALS_ID = 'vagrant'                     // Jenkins credential ID for SSH private key
        TERRAFORM_DIR = 'C:\\Terraform'
        ZAP_PATH = 'C:\\Program Files\\ZAP\\Zed Attack Proxy\\zap.bat'

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
                bat """
                ssh -o StrictHostKeyChecking=no -p 2222 ${env.VM_USER}@127.0.0.1 "mkdir -p /home/vagrant/www_tmp"
                scp -P 2222 -r * ${env.VM_USER}@127.0.0.1:/home/vagrant/www_tmp/
                ssh -o StrictHostKeyChecking=no -p 2222 ${env.VM_USER}@127.0.0.1 "sudo cp -r /home/vagrant/www_tmp/* /var/www/html/ && sudo chown -R www-data:www-data /var/www/html/"
                """
            }
        }

        stage('DAST - OWASP ZAP Scan') {
            steps {
                bat """
                java -Xmx512m -jar "C:\\Program Files\\ZAP\\Zed Attack Proxy\\zap-2.16.1.jar" -cmd -quickurl http://${env.VM_IP} -quickout zap-report.html
                """
                archiveArtifacts artifacts: 'zap-report.html', fingerprint: true
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

