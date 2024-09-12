pipeline {
    agent any
    parameters {
        booleanParam(
            name: "PROMOTE",
            defaultValue: false,
            description: "Czy chcesz wypromować artefakt?"
        )
        string(
            name: "VERSION",
            defaultValue: "",
            description: "Podaj numer wersji"
        )
        string(
            name: "PASSWORD",
            defaultValue: "",
            description: "Podaj hasło"
        )
    }
    stages {
        stage('Prep') {
            steps {
                sh '''
                rm -rf MDO2024_INO
                git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
                cd MDO2024_INO
                git checkout DP411750
                cd ITE/GCL4/DP411750
                '''
            }
        }
        stage('Build') {
            steps {
                dir("MDO2024_INO/ITE/GCL4/DP411750"){
                    sh 'docker build -t flask-build -f builder.Dockerfile . 2>&1 | tee build.log'
                }    
            }
            post {
                always {
                    archiveArtifacts artifacts: 'MDO2024_INO/ITE/GCL4/DP411750/build.log', allowEmptyArchive: true
                }
            }
        }
        stage('Test') {
            steps {
                dir("MDO2024_INO/ITE/GCL4/DP411750"){
                    sh 'docker build -t test-app -f tester.Dockerfile . 2>&1 | tee test-build.log'
                    sh 'docker run test-app 2>&1 | tee test-run.log'
                }    
            }
            post {
                always {
                    archiveArtifacts artifacts: 'MDO2024_INO/ITE/GCL4/DP411750/test-*.log', allowEmptyArchive: true
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker network create flask_net || true'
                dir("MDO2024_INO/ITE/GCL4/DP411750"){
                    sh 'docker build -t flask-app -f deployer.Dockerfile . 2>&1 | tee deploy-build.log'
                    sh 'docker run -p 5001:5001 --network flask_net flask-app 2>&1 | tee deploy-run.log'
                }    
            }
            post {
                always {
                    archiveArtifacts artifacts: 'MDO2024_INO/ITE/GCL4/DP411750/deploy-*.log', allowEmptyArchive: true                }
            }
        }
        stage("Publish") {
            steps {
                script {
                    if(params.PROMOTE) {
                            sh "echo '${params.PASSWORD}' | docker login -u dawidpac1a --password-stdin"
                            sh "docker tag flask-app:latest dawidpac1a/flask-app:${params.VERSION}"
                            sh "docker push dawidpac1a/flask-app:${params.VERSION}"
                    } else {
                            echo 'No promotion :('
                    }
                }
            }
        }
       
    }
}