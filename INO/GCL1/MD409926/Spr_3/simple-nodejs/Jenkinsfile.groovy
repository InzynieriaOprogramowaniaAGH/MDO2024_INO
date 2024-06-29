pipeline {
    agent any
    parameters {
        booleanParam(
            name: "Wypromuj",
            defaultValue: false,
            description: "Czy chcesz wypromować?"
        )
        string(
            name: "Wersja",
            defaultValue: "",
            description: "Podaj numer wersji"
        )
        string(
            name: "Hasło",
            defaultValue: "haslo",
            description: "Podaj hasło"
        )
    }
    stages { 
        stage('Klonowanie') {
            steps {
                echo 'Następuje klonowanie...'
                sh "rm -rf MDO2024_INO"
                sh "docker system prune --all --force"
                sh "git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO"
                sh "pwd"
                sh "ls -la"
                dir('MDO2024_INO'){
                    sh "git checkout MD409926"
                }
                
                sh 'touch b_logs.log'
                sh 'touch t_logs.log'
            }
        }
        stage('Budowanie') {
            steps {
                echo 'Budowanie w toku...'
                dir('MDO2024_INO'){
                    sh 'ls -a'
                    sh 'docker build -t bldr:latest -f ./INO/GCL1/MD409926/Spr_3/simple-nodejs/BLDR.Dockerfile .| tee b_logs.log'
                    sh 'docker run --name bldr bldr:latest'
                }
            }
        }
        stage('Testowanie') {
            steps {
                echo 'Przeprowadzanie testów...'
                dir('MDO2024_INO'){
                    sh 'ls -la'
                    sh 'docker build -t tstr:latest -f ./INO/GCL1/MD409926/Spr_3/simple-nodejs/TSTR.Dockerfile . | tee t_logs.log'
                    sh 'docker run --name tstr tstr:latest'
                }
            }
        }
        stage('Wdrażanie') {
            steps {
                echo 'Wdrażanie projektu...'
                dir('MDO2024_INO'){
                    sh 'ls -la'
                    sh 'docker stop bldr && docker rm bldr'
                    sh 'docker stop tstr && docker rm tstr'
                    archiveArtifacts artifacts: "b_logs.log"
                    archiveArtifacts artifacts: "t_logs.log"
                }
                script {
                    if(params.PROMOTE){
                        sh "mkdir ${params.VERSION}"
                        sh "cd ${params.VERSION}"
                        sh 'docker run --name tstr tstr:latest'
                    } else {
                        sh 'echo "Fail"'
                    }
                }
            }
        }

        stage('Publikowanie') {
            steps {
                echo 'Nastepuje publikowanie do DockerHub...'
                script {
                    if(params.PROMOTE) {
                        sh "echo '${params.Password}' | docker login -u dmaciej --password-stdin"
                        sh "docker tag tstr:latest dmaciej/simple-nodejs:${params.VERSION}"
                        sh "docker push dmaciej/simple-nodejs:${params.VERSION}"
                        sh 'docker rm tstr'
                        sh "tar -czvf simple-nodejs-${params.VERSION}.tar.gz ${params.VERSION}/"
                        echo 'Tworzenie artefaktu...'
                        archiveArtifacts artifacts: "simple-nodejs-${params.VERSION}.tar.gz"
                    } else {
                        echo 'Zatrzymanie publikowanie. Błędne dane w promocji!'
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