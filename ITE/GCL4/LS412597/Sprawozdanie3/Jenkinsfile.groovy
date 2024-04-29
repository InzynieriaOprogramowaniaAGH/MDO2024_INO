pipeline {
    agent any

    parameters {
        string(name: 'VERSION', defaultValue: '1.0.0', description: 'Enter the version of the Docker image')
    }

    environment {
    registry = "lukaszsawina/take_note_pipeline"
    registryCredential = 'lukaszsawina_id'
    dockerImage = ''
    }
    
    stages {
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
                        sh 'docker login -u "lukaszsawina" -p "Okokiok-01" docker.io'
                        sh 'docker tag takenote_deploy lukaszsawina/take_note_pipeline:1.0.0'
                        sh 'docker push lukaszsawina/take_note_pipeline'

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
