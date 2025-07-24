pipeline {
    agent { label 'local' }

    environment {
        // Replace these with actual values
        REPO1_URL = 'https://github.com/sm-dotcom/dev_assi_06.git'
        // If not using second repo, leave blank or comment
        // REPO2_URL = ''
        // CREDENTIALS_ID_1 = 'creds-repo1'
        // CREDENTIALS_ID_2 = 'creds-repo2' // Optional
        // SONARQUBE_ENV = 'My Sonar Server'
        WEBHOOK_URL = 'https://2908-72-255-7-99.ngrok-free.app/github-webhook/' // Optional
        EMAIL_RECIPIENTS = 'sarah.mahmood@camp1.tkxel.com' // Optional
    }

    stages {
        stage('Checkout Repos') {
            steps {
                echo 'Checking out repo1...'
                dir('repo1') {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: env.REPO1_URL,
                            credentialsId: env.CREDENTIALS_ID_1
                        ]]
                    ])
                }

                script {
                    if (env.REPO2_URL?.trim()) {
                        echo 'Checking out repo2...'
                        dir('repo2') {
                            checkout([
                                $class: 'GitSCM',
                                branches: [[name: '*/main']],
                                userRemoteConfigs: [[
                                    url: env.REPO2_URL,
                                    credentialsId: env.CREDENTIALS_ID_2
                                ]]
                            ])
                        }
                    } else {
                        echo 'Skipping repo2 checkout (not configured)'
                    }
                }
            }
        }

        stage('SonarQube Scan') {
            steps {
                script {
                    withSonarQubeEnv("${env.SONARQUBE_ENV}") {
                        dir('repo1') {
                            bat 'mvn clean verify sonar:sonar'
                        }
                    }
                }
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Running build and test logic...'
                // Example: bat 'mvn package'
            }
        }
    }

    post {
        success {
            script {
                echo "Build SUCCESS: Notifying..."

                // Email block
                if (env.EMAIL_RECIPIENTS?.trim()) {
                    mail to: "${env.EMAIL_RECIPIENTS}",
                         subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                         body: "Build succeeded for ${env.JOB_NAME} #${env.BUILD_NUMBER}.\nCheck Jenkins for details."
                } else {
                    echo 'Email not sent (EMAIL_RECIPIENTS not configured)'
                }

                // Webhook block
                if (env.WEBHOOK_URL?.trim()) {
                    def payload = "{\"status\": \"SUCCESS\", \"job\": \"${env.JOB_NAME}\", \"build\": \"#${env.BUILD_NUMBER}\"}"
                    httpRequest acceptType: 'APPLICATION_JSON',
                                contentType: 'APPLICATION_JSON',
                                httpMode: 'POST',
                                requestBody: payload,
                                url: "${env.WEBHOOK_URL}"
                } else {
                    echo 'Webhook not sent (WEBHOOK_URL not configured)'
                }
            }
        }

        failure {
            script {
                echo "Build FAILURE: Notifying..."

                if (env.EMAIL_RECIPIENTS?.trim()) {
                    mail to: "${env.EMAIL_RECIPIENTS}",
                         subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                         body: "Build failed for ${env.JOB_NAME} #${env.BUILD_NUMBER}.\nCheck Jenkins for details."
                } else {
                    echo 'Email not sent (EMAIL_RECIPIENTS not configured)'
                }

                if (env.WEBHOOK_URL?.trim()) {
                    def payload = "{\"status\": \"FAILURE\", \"job\": \"${env.JOB_NAME}\", \"build\": \"#${env.BUILD_NUMBER}\"}"
                    httpRequest acceptType: 'APPLICATION_JSON',
                                contentType: 'APPLICATION_JSON',
                                httpMode: 'POST',
                                requestBody: payload,
                                url: "${env.WEBHOOK_URL}"
                } else {
                    echo 'Webhook not sent (WEBHOOK_URL not configured)'
                }
            }
        }

        always {
            echo "Build completed: ${currentBuild.currentResult}"
        }
    }
}
