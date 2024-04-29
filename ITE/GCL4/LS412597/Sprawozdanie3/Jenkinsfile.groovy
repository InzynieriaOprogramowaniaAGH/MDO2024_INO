pipeline {
    agent any

    parameters {
        string(name: 'VERSION', defaultValue: '1.0.0', description: 'Enter the version of the Docker image')
    }
    
    stages {
        stage('Check Version') {
            steps {
                script {
                    // Zdefiniowanie URL do konkretnego tagu w Docker Hub API
                    def tagUrl = "https://registry.hub.docker.com/v2/repositories/lukaszsawina/take_note_pipeline/tags/${params.VERSION}"

                    // Wykonanie zapytania do Docker Hub API
                    def httpResponseCode = sh(script: "curl -s -o /dev/null -w '%{http_code}' ${tagUrl}", returnStdout: true).trim()

                    // Sprawdzenie, czy kod odpowiedzi to 404
                    if (httpResponseCode == '404') {
                        echo "Tag ${params.VERSION} does not exist. Proceeding with the pipeline."
                    } else {
                        error "The version ${params.VERSION} is already used. Please specify a different version."
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Budowa aplikacji z użyciem pliku Dockerfile builder.Dockerfile
                    docker.build('takenote_build', '-f ITE/GCL4/LS412597/Sprawozdanie3/builder.Dockerfile .')
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji z użyciem pliku Dockerfile tester.Dockerfile
                    docker.build('takenote_test', '-f ITE/GCL4/LS412597/Sprawozdanie3/tester.Dockerfile .')
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Tworzomy sieć o nazwie deploy
                    sh 'docker network create deploy || true'
                    // Budowanie obrazu Docker
                    def appImage = docker.build('takenote_deploy', '-f ITE/GCL4/LS412597/Sprawozdanie3/deploy.Dockerfile .')

                    // Uruchomienie kontenera w tle o nazwie 'app'
                    def container = appImage.run("-d -p 5000:5000 --network=deploy --name app")

                    // Sprawdzenie, czy aplikacja działa, wykonując żądanie HTTP
                    sh 'docker run --rm --network=deploy curlimages/curl:latest -L -v  http://app:5000'

                    // Zatrzymanie kontenera
                    sh 'docker stop app'

                    // Usunięcie kontenera
                    sh 'docker container rm app'

                    // Usunięcie sieci
                    sh 'docker network rm deploy'

                    sh 'docker rmi takenote_build takenote_test'
                }
            }
        }
        stage('Publish') {
            steps {
                script {
                        // Logowanie do DockerHub
                        withCredentials([usernamePassword(credentialsId: 'lukaszsawina_id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                            sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                        }
                        sh "docker tag takenote_deploy lukaszsawina/take_note_pipeline:${env.VERSION}"
                        sh "docker push lukaszsawina/take_note_pipeline:${env.VERSION}"

                }
            }
        } 
    }
    post {
            always {
                // Czyszczenie po zakończeniu
                sh 'docker system prune -af'
            }
        }
}
