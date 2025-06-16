pipeline {
    agent any

    // tools {
    //     sonarQubeScanner 'SonarScanner' // Name as defined in Manage Jenkins > Global Tool Configuration
    // }

    environment {
        DEFAULT_RECIPIENT = 'sarah.mahmood@camp1.tkxel.com'
        // API_KEY = 'your_api_key_here'
        SONAR_TOKEN = credentials('sonar-token-1') // Secret text from Jenkins credentials
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                git url: 'https://github.com/sm-dotcom/dev_assi_06.git', branch: 'main'
            }
        }

        stage('SonarQube Scan') {
            steps {
                echo 'Running SonarQube scan with Jenkins SonarScanner...'
                withSonarQubeEnv('MySonar') { // Name from "Configure System"
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=my-python-app-1 \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.login=$SONAR_TOKEN
                    '''
                }
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


        stage('Docker Build and Deploy') {
            steps {
                sh '''
                docker build -t my-python-app .
                docker save my-python-app | gzip > my-python-app.tar.gz
                scp my-python-app.tar.gz user@remote_ip:/tmp/
                ssh user@remote_ip 'gunzip -c /tmp/my-python-app.tar.gz | docker load && docker run --rm my-python-app'
                '''
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

