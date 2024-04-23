pipeline {
    agent any
    
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
                    // Budowanie obrazu Docker
                    def appImage = docker.build('takenote_deploy', '-f ITE/GCL4/LS412597/Sprawozdanie3/deploy.Dockerfile .')

                    // Uruchomienie kontenera w tle
                    def container = appImage.run("-d -p 3000:3000")

                    // Dajemy chwilę czasu na uruchomienie kontenera
                    sh "sleep 10" // Czekaj 10 sekund

                    // Sprawdzenie, czy aplikacja działa, wykonując żądanie HTTP
                    sh 'curl -f http://localhost:3000'
                

                    // W przypadku potrzeby - zatrzymanie kontenera
                    appContainer.stop()
                }
            }
        }
    }
}
