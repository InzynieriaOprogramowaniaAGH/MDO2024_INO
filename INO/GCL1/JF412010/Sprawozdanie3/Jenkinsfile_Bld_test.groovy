pipeline {
    agent any

    stages {
        stage('Preperation') {
            steps {
                echo 'Pobieranie repo'
                git branch: 'JF412010', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Build'
                sh 'docker build -f ./INO/GCL1/JF412010/Sprawozdanie2/BLD.Dockerfile -t bld_node .'
            }
        }
        stage('Test') {
            steps {
                echo 'Test'
                sh 'docker build -f ./INO/GCL1/JF412010/Sprawozdanie2/TEST.Dockerfile -t test_node --progress=plain --no-cache .'
            }
        }
    }
}
