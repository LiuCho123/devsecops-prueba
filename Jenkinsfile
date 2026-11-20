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

        stage('Dependency Management') {
            steps {
                // Verifica el Pipfile y lista las dependencias instaladas
                bat 'docker run --rm %APP_NAME% pip list'
                // Audita vulnerabilidades conocidas (CVEs) en las dependencias
                bat 'docker run --rm %APP_NAME% pip-audit || exit 0'
            }
        }

        stage('Deploy') {
            steps {
                bat 'docker rm -f %APP_NAME% 2>nul || exit 0'
                bat 'docker run -d --name %APP_NAME% -p %APP_PORT%:5000 %APP_NAME%'
            }
        }
    }
}