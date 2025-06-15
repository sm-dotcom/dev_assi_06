pipeline {
    agent {
        node {
            label 'docker-agent-python'
        }
    }

    triggers {
        githubPush()
    }

    environment {
        // Optional fallback recipient
        DEFAULT_RECIPIENT = 'sarah.mahmood@camp1.tkxel.com'
        API_KEY = 'your_api_key_here' // Or use Jenkins credentials for this too
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                git url: 'https://github.com/sm-dotcom/dev_assi_06.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                echo "Installing dependencies..."
                sh '''
                cd myapp
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Running tests with .env + Jenkins credentials"
                withCredentials([string(credentialsId: 'email-pass-secret', variable: 'EMAIL_PASS')]) {
                    sh '''
                    cd myapp
                    set -a
                    [ -f .env ] && source .env
                    export EMAIL_PASS=$EMAIL_PASS
                    set +a
                    python3 hello.py
                    python3 hello.py --name=Brad
                    '''
                }
            }
        }

        stage('Deliver') {
            steps {
                echo 'Delivery step (placeholder)...'
            }
        }
    }

    post {
        success {
            script {
                def recipient = env.EMAIL_USER ?: env.DEFAULT_RECIPIENT
                mail to: "${recipient}",
                     subject: "Jenkins Pipeline Success: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
                     body: "Build #${env.BUILD_NUMBER} succeeded.\nCheck it here: ${env.BUILD_URL}"
            }
        }

        failure {
            script {
                def recipient = env.EMAIL_USER ?: env.DEFAULT_RECIPIENT
                mail to: "${recipient}",
                     subject: "Jenkins Pipeline FAILED: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
                     body: "Build #${env.BUILD_NUMBER} failed.\nCheck it here: ${env.BUILD_URL}"
            }
        }
    }
}
