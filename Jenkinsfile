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

        stage('Generate Documentation') {
            steps {
                // Ejecuta Doxygen y guarda la carpeta docs/ en el workspace de Jenkins
                bat 'docker run --rm -v "%CD%":/app %APP_NAME% doxygen Doxyfile'
            }
        }

        stage('Version Control') {
            steps {
                bat 'git config user.name "Jenkins CI"'
                bat 'git config user.email "jenkins@local"'
                bat 'git add docs/'
                bat 'git commit -m "Actualizar documentacion generada por Doxygen" || exit 0'
                bat 'git status'
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