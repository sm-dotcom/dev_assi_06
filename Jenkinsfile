pipeline {
    agent { label 'local' }

    environment {
        // Replace these with actual values
        REPO1_URL = 'https://github.com/your-org/repo1.git'
        //REPO2_URL = 'https://github.com/your-org/repo2.git'
        CREDENTIALS_ID_1 = 'creds-repo1'
        CREDENTIALS_ID_2 = 'creds-repo2'
        SONARQUBE_ENV = 'My Sonar Server'
        WEBHOOK_URL = 'https://your-webhook-url.com'
        EMAIL_RECIPIENTS = 'sarah.mahmood@camp1.tkxel.com'
    }

    stages {
        stage('Checkout Repos') {
            steps {
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
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${env.SONARQUBE_ENV}") {
                    dir('repo1') {
                        bat 'mvn clean verify sonar:sonar'
                    }
                }
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Run build and test logic here'
                // Example: bat 'mvn package'
            }
        }
    }

    post {
        success {
            mail to: "${env.EMAIL_RECIPIENTS}",
                 subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build succeeded for ${env.JOB_NAME} #${env.BUILD_NUMBER}.\nCheck Jenkins for details."

            script {
                def payload = "{\"status\": \"SUCCESS\", \"job\": \"${env.JOB_NAME}\", \"build\": \"#${env.BUILD_NUMBER}\"}"
                httpRequest acceptType: 'APPLICATION_JSON',
                            contentType: 'APPLICATION_JSON',
                            httpMode: 'POST',
                            requestBody: payload,
                            url: "${env.WEBHOOK_URL}"
            }
        }

        failure {
            mail to: "${env.EMAIL_RECIPIENTS}",
                 subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed for ${env.JOB_NAME} #${env.BUILD_NUMBER}.\nPlease check Jenkins for errors."

            script {
                def payload = "{\"status\": \"FAILURE\", \"job\": \"${env.JOB_NAME}\", \"build\": \"#${env.BUILD_NUMBER}\"}"
                httpRequest acceptType: 'APPLICATION_JSON',
                            contentType: 'APPLICATION_JSON',
                            httpMode: 'POST',
                            requestBody: payload,
                            url: "${env.WEBHOOK_URL}"
            }
        }

        always {
            echo "Build finished: ${currentBuild.currentResult}"
        }
    }
}
