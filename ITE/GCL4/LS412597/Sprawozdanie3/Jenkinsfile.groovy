pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'ls -la'
                }
                script {
                    // Budowa aplikacji z użyciem pliku Dockerfile nodeapp_builder.Dockerfile
                    docker.build('nodeapp_build', '-f ITE/GCL4/LS412597/Sprawozdanie2/nodeapp/nodeapp_builder.Dockerfile .')
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji z użyciem pliku Dockerfile nodeapp_tester.Dockerfile
                    docker.build('nodeapp_test', '-f ITE/GCL4/LS412597/Sprawozdanie2/nodeapp/nodeapp_tester.Dockerfile .')
                }
            }
        }
    }
}
