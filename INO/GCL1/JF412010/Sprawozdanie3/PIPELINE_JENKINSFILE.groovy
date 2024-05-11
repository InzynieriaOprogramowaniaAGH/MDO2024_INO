pipeline {
    agent any
    
    environment {
        VERSION_UPDATE = '1.1.4'
        HOST_IP ='172.20.0.3'
        NPM_TOKEN = credentials('NPM_TOKEN')
        NPM_PASSW = credentials('NPM_PASSW')
    }

    stages {
        stage('Preparation') {
            steps {
                echo "Preparation"
                sh 'rm -rf MDO2024_INO'
                git branch: 'JF412010', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
                dir ('./INO/GCL1/JF412010/Sprawozdanie3/node-js-tests-sample') {
                    sh 'chmod +x docker_clear.sh'
                    sh './docker_clear.sh'
                }
            }
        }
        stage('Build') {
            steps {
                echo "Build"
                dir ('./INO/GCL1/JF412010/Sprawozdanie3/node-js-tests-sample') {
                    sh 'docker build -f ./BLD.Dockerfile -t bld_node . 2>&1 | tee ./temp_logs/build_log_${BUILD_NUMBER}.txt'
                    archiveArtifacts artifacts: "temp_logs/build_log_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
                }
            }
        }
        stage('Test') {
            steps {
                echo "Test"
                dir ('./INO/GCL1/JF412010/Sprawozdanie3/node-js-tests-sample') {
                    sh 'docker build --no-cache -f ./TEST.Dockerfile -t test_node . 2>&1 | tee ./temp_logs/test_log_${BUILD_NUMBER}.txt'
                    archiveArtifacts artifacts: "temp_logs/test_log_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
                }
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploy"
                sh 'docker run -d --rm --name verdaccio -p 4873:4873 verdaccio/verdaccio'
                dir ('./INO/GCL1/JF412010/Sprawozdanie3/node-js-tests-sample') {
                    sh "docker build --build-arg HOST_IP=${HOST_IP} --no-cache -f ./DEPLOY1.Dockerfile --build-arg VERSION_UPDATE=${VERSION_UPDATE} -t deploy1_node ."
                    sh 'echo "registry=http://${HOST_IP}:4873" > .npmrc'
                    sh "docker build --no-cache -f ./DEPLOY2.Dockerfile -t deploy2_node . 2>&1 | tee ./temp_logs/test_deploy_log_${BUILD_NUMBER}.txt"
                    archiveArtifacts artifacts: "temp_logs/test_deploy_log_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
                }
            }
        }
        stage('Publish') {
            steps {
                echo "Publish"
                dir ('./INO/GCL1/JF412010/Sprawozdanie3/node-js-tests-sample') {
                    sh 'docker build --build-arg NPM_TOKEN=${NPM_TOKEN} --build-arg NPM_PASSW=${NPM_PASSW} --no-cache --build-arg VERSION_UPDATE=${VERSION_UPDATE} -f ./PUBLISH.Dockerfile -t publish_node .'
                }
            }
        }
    }

    post {
        always {
            dir ('temp_logs') {
                deleteDir()
            }
        }
    }
}
