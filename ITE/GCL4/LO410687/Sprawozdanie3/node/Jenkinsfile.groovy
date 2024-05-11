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
                sh "pwd"
                sh "ls -la"
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
                    sh 'ls -a'
                    sh 'docker build -t node-build:latest -f ./ITE/GCL4/LO410687/Sprawozdanie3/node/node-build.Dockerfile .| tee build_logs.log'
                    sh 'docker run --name node-build node-build:latest'
                }
            }
        }
        stage('Tests') {
            steps {
                echo 'Testing...'
                dir('MDO2024_INO'){
                    sh 'ls -la'
                    sh 'docker build -t node-test:latest -f ./ITE/GCL4/LO410687/Sprawozdanie3/node/node-test.Dockerfile . | tee test_logs.log'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Cleaning and deploying...'
                dir('MDO2024_INO'){
                    sh 'ls -la'
                    sh 'docker rm node-build'
                    sh 'docker rm node-test'
                    archiveArtifacts artifacts: "build_logs.log"
                    archiveArtifacts artifacts: "test_logs.log"
                }
                script {
                    if(params.PROMOTE){
                        sh "mkdir ${params.VERSION}"
                        sh "cd ${params.VERSION}"
                        sh 'docker run --name node-test node-test:latest'
                    } else {
                        sh 'echo "Fail"'
                    }
                }
            }
        }

        stage('Publish') {
            steps {
                echo 'Publishing...'
                script {
                    if(params.PROMOTE) {
                        sh 'echo "Pushing image to DockerHub"'
                        
                        sh "echo '${params.Password}' | docker login -u lukoprych --password-stdin"
                        
                        sh "docker tag node-test:latest lukoprych/node-js-tests-sample:${params.VERSION}"
                        
                        sh "docker push lukoprych/node-js-tests-sample:${params.VERSION}"
                        
                        sh 'docker rm node-test'
                        
                        sh "tar -czvf node-js-tests-sample-${params.VERSION}.tar.gz ${params.VERSION}/"
                        echo 'Creating artifact...'
                        archiveArtifacts artifacts: "node-js-tests-sample-${params.VERSION}.tar.gz"
                    } else {
                        echo 'Promote parameter is false. Skipping publishing to DockerHub.'
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
