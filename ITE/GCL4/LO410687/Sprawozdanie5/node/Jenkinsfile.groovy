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
            name: "Password",
            defaultValue: "123",
            description: "Podaj hasło"
        )
    }
    stages { 
        stage('Prepare') {
            steps {
                echo 'Preparing...'
                sh "rm -rf MDO2024_INO"
                sh "docker system prune --all --force"
                sh "git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO"
                dir('MDO2024_INO'){
                    sh "git checkout LO410687"
                }
                sh 'touch build_logs.log'
                sh 'touch test_logs.log'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                dir('MDO2024_INO'){
                    sh 'docker build -t notes-app:latest -f ./ITE/GCL4/LO410687/Sprawozdanie5/node/node-build.Dockerfile . | tee build_logs.log'
                }
            }
        }
        stage('Tests') {
            steps {
                echo 'Testing...'
                dir('MDO2024_INO'){
                    sh 'docker build -t notes-app-test:latest -f ./ITE/GCL4/LO410687/Sprawozdanie5/node/node-test.Dockerfile . | tee test_logs.log'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                dir('MDO2024_INO'){
                    sh 'docker build -t notes-app-deploy:latest -f ./ITE/GCL4/LO410687/Sprawozdanie5/node/node-deploy.Dockerfile .'
                    sh 'docker run -d -p 3000:3000 --name notes-app-deploy notes-app-deploy:latest'
                }
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing...'
                script {
                    if(params.PROMOTE) {
                        sh "echo '${params.Password}' | docker login -u lukoprych --password-stdin"
                        sh "docker tag notes-app-deploy:latest lukoprych/notes-app:${params.VERSION}"
                        sh "docker push lukoprych/notes-app:${params.VERSION}"
                        sh 'docker rm notes-app-deploy' 
                        sh "tar -czvf notes-app-${params.VERSION}.tar.gz ${params.VERSION}/"
                        echo 'Creating artifact...'
                        archiveArtifacts artifacts: "notes-app-${params.VERSION}.tar.gz"
                    } else {
                        echo 'Promote parameter is false. Skipping publishing...'
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}