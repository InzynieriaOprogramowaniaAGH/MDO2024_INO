pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Budowa aplikacji z użyciem pliku Dockerfile nodeapp_builder.Dockerfile
                    docker.build('takenode_build', '-f ITE/GCL4/LS412597/Sprawozdanie3/builder.Dockerfile .')
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji z użyciem pliku Dockerfile nodeapp_tester.Dockerfile
                    docker.build('takenode_test', '-f ITE/GCL4/LS412597/Sprawozdanie3/tester.Dockerfile .')
                }
            }
        }
    }
}
