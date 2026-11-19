pipeline {
    agent any

    environment {
        APP_NAME = 'devsecops-app'
        APP_PORT = '5000'
    }

    stages {
        stage('Build') {
            steps {
                bat 'docker build -t %APP_NAME% .'
            }
        }

    stage('Test') {
         steps {
             bat 'docker run --rm %APP_NAME% python -m py_compile app.py'
         }
     }

        stage('Analyze') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQube') {
                        bat "\"${scannerHome}\\bin\\sonar-scanner.bat\" -Dsonar.projectKey=devsecops-app -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                bat 'docker rm -f %APP_NAME% 2>nul || exit 0'
                bat 'docker run -d --name %APP_NAME% -p %APP_PORT%:5000 %APP_NAME%'
            }
        }

        stage('Security Test') {
            steps {
                // 1. OWASP Dependency-Check
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    dependencyCheck additionalArguments: '--scan ./ --format HTML --nvdApiKey CA780A4E-651B-4D18-9F1D-25E96248A30E', odcInstallation: 'DP-Check'
                }

                // 2. OWASP ZAP (escaneo dinámico contra la app desplegada)
                bat 'docker run --rm -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://host.docker.internal:5000/hello?name=TEST || exit 0'
            }
        }
    }
}