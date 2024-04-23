pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Budowa aplikacji z użyciem pliku Dockerfile builder.Dockerfile
                    docker.build('nodeapp_build', '-f ITE/GCL4/LS412597/Sprawozdanie3/builder.Dockerfile .')
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji z użyciem pliku Dockerfile tester.Dockerfile
                    docker.build('nodeapp_test', '-f ITE/GCL4/LS412597/Sprawozdanie3/tester.Dockerfile .')
                }
            }
        }

        stage('Deploy') {
            steps {
                script {

                    sh 'docker network create deploy || true'
                    // Budowanie obrazu Docker
                    def appImage = docker.build('nodeapp_deploy', '-f ITE/GCL4/LS412597/Sprawozdanie3/deploy.Dockerfile .')

                    // Uruchomienie kontenera w tle
                    def container = appImage.run("-d -p 3000:3000 --network=deploy --name app")

                    // Dajemy chwilę czasu na uruchomienie kontenera
                    sh "sleep 10" // Czekaj 10 sekund

                    // Sprawdzenie, czy aplikacja działa, wykonując żądanie HTTP
                    sh 'docker run --rm --network=deploy curlimages/curl:latest -L -v  http://app:3000'

                    sh 'docker stop app'

                    sh 'docker container rm app'

                    sh 'docker network rm deploy'
                }
            }
        }
    }
}
