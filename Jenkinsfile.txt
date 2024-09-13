pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t builddependencies .'
      }
    }

    stage('Test') {
      steps {
        script {
          sh 'docker run --rm builddependencies'
        }

      }
    }

    stage('Deploy') {
      steps {
        script {
          sh 'docker build -t deployable -f Dockerfile.deploy .'
        }

      }
    }

    stage('Publish') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub-redis', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            // Testowanie poświadczeń (usuwalne po weryfikacji)
            sh 'echo $DOCKER_USERNAME'

            // Logowanie do Docker Hub
            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'

            // Tagowanie obrazu
            sh 'docker tag deployable bartekkep/deployable:latest'

            // Wypchnięcie obrazu na Docker Hub
            sh 'docker push bartekkep/deployable:latest'
          }
        }

      }
    }

  }
}