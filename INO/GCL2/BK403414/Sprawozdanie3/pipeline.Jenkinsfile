pipeline {
    agent any
    
    stages {
        stage('Prepare') {
            steps {
                echo 'PREPARING...'
                script {
                    if (fileExists('MDO2024_INO'))
                    {
                    sh 'rm  -rf MDO2024_INO'
                    }
                }
                sh 'docker system prune --force'

            }
        }
        stage('Clone') {
            steps {
                echo 'CLONING...'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
                dir('MDO2024_INO') {
                    sh 'git checkout BK403414'
                    
                }
               
            }
            
        }
        stage('Build') {
            steps {
                echo 'BUILDING...'
                dir('MDO2024_INO/INO/GCL2/BK403414/Sprawozdanie3') {
                    sh 'chmod +x containers_prepare.sh'
                    sh ' ./containers_prepare.sh'
                    sh 'ls .'
                    sh 'docker build -f builder.Dockerfile -t builder-dockerfile .'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'TESTING...'
                dir('MDO2024_INO/INO/GCL2/BK403414/Sprawozdanie3') {
                    sh 'ls .'
                    sh 'docker build -f test.Dockerfile -t tester-dockerfile .'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo'DEPLOYING...'
                dir('MDO2024_INO/INO/GCL2/BK403414/Sprawozdanie3') {
                    sh 'docker run --rm --name dockercpy -d -v $(pwd):/out builder-dockerfile cp bin/pcalc /out'
                    sh 'mkdir artifacts'
                    sh 'tar -cvf artifacts/pcalc.tar pcalc README.txt LICENSE.txt'
                    sh 'docker build -f deploy.Dockerfile -t deploy-dockerfile .'
                    sh 'docker run --name deploy -d deploy-dockerfile ./pcalc --version'
                    sh 'docker logs deploy'
                    sh 'docker rm deploy'
                }
            }
        }
        stage('Publish') {
            steps {
                echo'PUBLISHING...'
                dir('MDO2024_INO/INO/GCL2/BK403414/Sprawozdanie3/artifacts') {
                    archiveArtifacts artifacts: "pcalc.tar"
                    sh 'docker system prune --all --volumes --force'
                }
            }
        }
        
    }
}