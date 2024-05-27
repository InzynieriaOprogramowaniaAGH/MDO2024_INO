# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 10 - Wdrażanie na zarządzalne kontenery: Kubernetes (1)
### Opis celu i streszczenie projektu:

Celem projektu było wdrożenie aplikacji webowej opartej na frameworku React na klastrze Kubernetes przy użyciu Minikube. Projekt obejmował stworzenie pipeline w Jenkinsie do automatyzacji budowania, testowania i wdrażania aplikacji oraz konfigurację i zarządzanie klastrem Kubernetes.

## Zrealizowane kroki:

Zmieniłam aplikację na taką, która działa w trybie ciągłym:
- utworzyłam prostą aplikację webową, wykrozystując framework React oraz dodałam ją na swojego GitHuba:
![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/projekt.png)

- nowy projekt pipeline w Jenkinsie:
![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/projekt2.png)

```bash
pipeline {
agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('e08d9a39-11d6-4211-b184-d7f62f6bf3e3')
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Clean up') {
            steps {
                echo "Cleaning..."
                sh '''
                
                docker stop r-build || true
                docker container rm r-build || true
                docker stop r-test || true
                docker container rm r-test || true
                docker stop r-deploy || true
                
                docker image rm -f react-app
                docker image rm -f react-app-test
                docker image rm -f react-app-deploy
                '''
            }
        }

        stage('Pull'){
            steps{
                echo "Pulling..."
                git branch: "master", credentialsId: 'e08d9a39-11d6-4211-b184-d7f62f6bf3e3', url: "https://github.com/weronikaabednarz/react-app"
                sh 'git config user.email "weronikaabednarz@gmail.com"'
                sh 'git config user.name "weronikaabednarz"'
            }
        }

        stage('Build') {
            steps {
                echo "Building..."
                sh '''
                docker build -t react-app -f ./Dockerfile .
                docker run --name r-build react-app
                docker cp r-build:/react-app/build ./artifacts
                docker logs r-build > build_logs.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Testing..."
                sh '''
                docker build -t react-app-test -f ./Dockerfile2 .
                docker run --name r-test react-app-test
                docker logs r-test > test_logs.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying..."
                sh '''
                
                docker build -t react-app-deploy -f ./Dockerfile3 .
                docker run -p 3000:3000 -d --rm --name r-deploy react-app-deploy
                '''
            }
        }

        stage('Publish') {
            steps {
                echo "Publishing..."
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz build_logs.txt test_logs.txt artifacts
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                NUMBER='''+ env.BUILD_NUMBER +'''
                docker tag react-app-deploy weronikaabednarz/react-app:latest
                docker push weronikaabednarz/react-app:latest
                docker logout

                '''
            } 
        }
    }
}
```
- uruchomiłam nowe zadanie pipeline:
![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/projekt3.png)

- dodane wdrożenie na DockerHubie:
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/projekt4.png)

### 1. Instalacja klastra Kubernetes

Instalacja klastra **Kubernetes** na **VM VirtualBox - Ubuntu** kierując się dokumentacją: https://minikube.sigs.k8s.io/docs/start/:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```
![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/2.png)

```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
minikube version
```
![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/3.png)

#### Włączyłam klaster:
```bash
minikube start
```
![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/4.png)

#### Uruchomiłam klaster **driver-docker**:
```bash
minikube start --driver=docker
```
![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/5.png)

#### Wyświetliłam listę profili konfiguracyjnych **Minikube** dostępnych na hoście:
```bash
minikube profile list
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/6.png)

#### Zainstalowałam Kubernetes command-line stosując się do dokumentacji: https://minikube.sigs.k8s.io/docs/handbook/dashboard/
```bash
sudo apt-get update
sudo apt-get install -y kubectl
```
![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/7.png)
![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/8.png)

#### Zweryfikowałam i wyświetliłam zainstalowanego **Kubectl**:
```bash
kubectl cluster-info
```
![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/9.png)

#### Wyświietliłam listę podów w klastrze:
```bash
kubectl get po -A
```
![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/10.png)

#### Działający kontener:

![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/15.png)

#### Uruchomiłam Minikube Dashboard:
```bash
minikube dashboard
```
![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/11.png)

#### Otworzyłam adres w przeglądarce:  http://127.0.0.1:41593/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default 

![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/12.png)

#### Lista zawierająca dostępne opcje **Minikube Dashboard**:

![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/13.png)

![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/14.png)

### 2. Analiza posiadanego kontenera
#### Pobrałam opublikowany obraz z **DockerHuba**:
```bash
docker pull weronikaabednarz/react-app:latest
```
![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/16.png)

#### Utworzyłam plik konfiguracji klastra **Kubernetes** za pomocą *conf.yaml*:
```bash
nano conf.yaml
```
#### Zawartość pliku *conf.yaml*:
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80

```
![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/17.png)

#### Uruchomiłam i zastosowałam plik *conf.yaml*:
```bash
kubectl apply -f conf.yaml
```
![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/18.png)

#### Wyświetliłam wszystkie pody w klastrze **Kubernetes**:
```bash
kubectl get pods
```
![22](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/22.png)

#### Wyświetliłam deployments:
```bash
kubectl get deployments
```
![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/21.png)

### 4. Udokumentowałam działanie aplikacji w klastrze Kubernetes.

![23](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/19.png)

![24](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/20.png)

Aplikacja działa prawidłowo w klastrze **Kubernetes**.

#### Uruchomiłam aplikację poprzez **port-forward**:
```bash
kubectl post-forward react-app-<CONTAINER_ID> 3000:3000
```
![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/23.png)

Strona internetowa:
![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/24.png)

## Laboratorium 11 - Wdrażanie na zarządzalne kontenery: Kubernetes (2)
### Opis celu i streszczenie projektu:

Projekt dotyczy automatyzacji i zarządzania wdrożeniami aplikacji kontenerowych przy użyciu Kubernetes oraz Docker. Celem projektu jest przekształcenie ręcznych wdrożeń na deklaratywne za pomocą plików YAML oraz przygotowanie skryptów do monitorowania i kontrolowania wdrożeń w środowisku Kubernetes.

## Zrealizowane kroki:
### 1. Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML.
#### Upewniłam się, że wdrożenie, z poprzednich zajęć jest zapisane jako plik **YAML** i działa prawidłowo po wejściu w przeglądarkę na adres: *http://localhost:3000*

![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/24.png)

#### Utworzyłam nowy plik *deployment.yaml* dla wzbogacenia obrazu o +4 repliki względem poprzednich zajęć:
```bash
nano deployment.yaml
```
![27](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/26.png)

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 5
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80

```
![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/27.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![29](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/28.png)

#### Wdrożenie na dashboardzie:

![30](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/29.png)

![31](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/30.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![32](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/31.png)

#### Zbadałam stan za pomocą *kubectl rollout status*:
```bash
kubectl rollout status deployment/react-app
```
![33](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/32.png)

### 2. Przygotowanie nowego obrazu.

#### Zbudowałam i zarejestrowałam na DockerHub trzy nowe wersje obrazu wdrożeniowego (przejście przez pipeline'a za każdym razem dla różnych wersji: latest, 1.0.1, 1.0.2):

- wersja 1.0.1:

#### Poprawiłam tag w **Pipeline** z *latest* na *1.0.1*:

![34](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/33.png)

#### Uruchomiłam **Pipeline**:

![35](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/34.png)

- wersja 1.0.2:

#### Poprawiłam tag w **Pipeline** z *1.0.1* na *1.0.2*:

![36](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/35.png)

#### Uruchomiłam **Pipeline**:

![37](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/36.png)

#### Wdrożone wersje aplikacji na **DockerHub**:

![38](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/37.png)

- wersja zbugowana, której uruchomienie kończy się błędem - w tym kroku wykorzystałam niedziałające wdrożenie **weronikaabednarz/spring-deploy** z przedostatnich zajęć, które nie działało w trybie ciągłym:

![39](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/38.png)

### 3. Zmiany w deploymencie.

#### Zaktualizowałam plik **YAML** z wdrożeniem i przeprowadzałam wdrożenie ponownie po zastosowaniu następujących zmian:

- **zwiększenie replik np. do 8** - w moim przypadku dla 9 replik
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 9
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80

```
![40](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/39.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![41](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/40.png)

#### Wdrożenie na dashboardzie:

![42](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/41.png)

#### Wyświetliłem podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![43](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/42.png)

- **zmniejszenie liczby replik do 1**
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80

```
![44](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/43.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![45](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/44.png)

#### Wdrożenie na dashboardzie:

![46](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/45.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![47](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/46.png)

- **zmniejszenie liczby replik do 0**
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 0
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80

```
![48](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/47.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![49](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/48.png)

#### Wdrożenie na dashboardzie:

![50](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/49.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![51](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/50.png)

- **zastosowanie starszej wersji obrazu - (1.0.1)**
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:1.0.1
          ports:
            - containerPort: 80

```
![52](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/51.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![53](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/52.png)

#### Wdrożenie na dashboardzie:

![54](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/53.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![55](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/54.png)

- **zastosowanie starszej wersji obrazu - (1.0.2)**
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app-1.0.2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:1.0.2
          ports:
            - containerPort: 80

```
![56](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/55.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment.yaml
```
![57](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/56.png)

#### Wdrożenie na dashboardzie:

![58](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/57.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![59](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/58.png)

- **zastosowanie wersji, która zawiera błąd**
Utworzenie pliku *yaml*:
```bash
nano deployment-2.yaml
```
![60](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/59.png)

Plik wdrożenia *yaml*
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-deploy-bug-version
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spring-deploy
  template:
    metadata:
      labels:
        app: spring-deploy
    spec:
      containers:
        - name: spring-deploy
          image: weronikaabednarz/spring-deploy:latest
          ports:
            - containerPort: 80

```
![61](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/60.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment-2.yaml
```
![62](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/61.png)

#### Wdrożenie na dashboardzie:

![63](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/62.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods
```
![64](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/63.png)

#### Przywróciłam poprzednie wersje wdrożeń za pomocą poleceń:
```bash
kubectl rollout history deployment/react-app
```
![65](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/64.png)

```bash
kubectl rollout undo deployment/react-app
```
![66](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/65.png)

#### Wdrożenie na dashboardzie:

![67](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/66.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods
```
![68](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/67.png)

### 4. Kontrola wdrożenia.

#### Napisałam skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (w ciągu 60 sekund):
Utworzyłam plik *check_deployment.sh*:
```bash
nano check_deployment.sh
```
![69](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/68.png)

Zawartość pliku *check_deployment.sh*:
```bash
#!/bin/bash

DEPLOYMENT_NAME="react-app"
NAMESPACE="default"

TIMEOUT=60
INTERVAL=5

check_deployment() {
  kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE} --timeout=${INTERVAL}s
  return $?
}

START_TIME=$(date +%s)

while true; do
  check_deployment
  STATUS=$?

  if [ $STATUS -eq 0 ]; then
    echo "Deployment ${DEPLOYMENT_NAME} has successfully rolled out."
    exit 0
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Timeout of ${TIMEOUT} seconds reached. Deployment ${DEPLOYMENT_NAME} did not roll out successfully."
    exit 1
  fi

  echo "Waiting for deployment ${DEPLOYMENT_NAME} to roll out..."
  sleep $INTERVAL
done
```
![70](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/69.png)

Zmieniłam uprawnienia dla pliku *check_deployment.sh*:
```bash
chmod +x check_deployment.sh
```
![71](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/70.png)

Uruchomiłam skrypt:
```bash
./check_deployment.sh
```
![72](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/71.png)

#### Wdrożenie na dashboardzie:

![74](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/73.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods
```
![73](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/72.png)

### 5. Strategie wdrożenia.
#### Przygotowałam wersje wdrożeń stosujące następujące strategie wdrożeń:
- **zastosowanie wersji, Recreate**
Stworzyłam plik 
```bash
nano deployment-recreate.yaml
```
![75](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/74.png)

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app-recreate
spec:
  replicas: 5
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80
```
![76](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/75.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment-recreate.yaml
```
![77](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/76.png)

#### Wdrożenie na dashboardzie:

![78](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/77.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![79](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/78.png)

- **zastosowanie wersji, Rolling Update (z parametrami maxUnavailable > 1, maxSurge > 20%)**
Stworzyłam plik 
```bash
nano deployment-rolling-update.yaml
```
![80](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/79.png)

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app-rolling
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 20%
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80
```
![81](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/80.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment-rolling-update.yaml
```
![82](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/81.png)

#### Wdrożenie na dashboardzie:

![83](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/82.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![84](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/83.png)

- **zastosowanie wersji, Canary Deployment workload** 
Stworzyłam plik 
```bash
nano deployment-canary-main.yaml
```
![85](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/86.png)

Plik deployment-canary-main.yaml:
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app-main
spec:
  replicas: 4
  selector:
    matchLabels:
      app: react-app
      version: main
  template:
    metadata:
      labels:
        app: react-app
        version: main
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:latest
          ports:
            - containerPort: 80
```
![86](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/87.png)

Stworzyłam plik 
```bash
nano deployment-canary.yaml
```
![87](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/84.png)

Plik deployment-canary.yaml:
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-app
      version: canary
  template:
    metadata:
      labels:
        app: react-app
        version: canary
    spec:
      containers:
        - name: react-app
          image: weronikaabednarz/react-app:1.0.1
          ports:
            - containerPort: 80
```
![88](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/85.png)

Stworzyłam plik 
```bash
nano service.yaml
```
![89](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/88.png)

Plik service.yaml:
```bash
apiVersion: v1
kind: Service
metadata:
  name: react-app-service
spec:
  selector:
    app: react-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
![90](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/89.png)

#### Rozpoczęłam nowe wdrożenie za pomocą *kubectl apply*:
```bash
kubectl apply -f deployment-canary-main.yaml
kubectl apply -f deployment-canary.yaml
kubectl apply -f service.yaml
```
![91](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/90.png)

#### Wdrożenie na dashboardzie:

![92](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/91.png)

#### Wyświetliłam podsy dla wdrożenia:
```bash
kubectl get pods -l app=react-app
```
![93](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie5/images/92.png)

Obserwacje i różnice:
Recreate: Wszystkie pods są usuwane, a następnie tworzone na nowo, co powoduje chwilowy brak dostępności aplikacji.
Rolling Update: Pods są aktualizowane stopniowo, co zapewnia ciągłą dostępność aplikacji. Parametry maxUnavailable i maxSurge kontrolują tempo aktualizacji - kontrolują liczbę niedostępnych oraz dodatkowych podsów w trakcie aktualizacji.
Canary Deployment: Nowa wersja aplikacji jest wdrażana tylko do części użytkowników (kanarek), co pozwala na wczesne wykrycie problemów przed pełnym wdrożeniem. Można to zrealizować poprzez tworzenie dodatkowych Deploymentów z nową wersją aplikacji oraz odpowiednie skonfigurowanie serwisów.

Etykiety i serwisy:
Etykiety (labels) są używane do selekcji podsów przez Deploymenty oraz Serwisy. Użycie etykiet umożliwia precyzyjne kontrolowanie, które pods mają być obsługiwane przez dany serwis, co jest szczególnie przydatne w strategiach takich jak Canary Deployment. Serwisy zapewniają dostępność aplikacji poprzez balansowanie ruchu między podsami.

### Dodałam sprawozdanie, zrzuty ekranu oraz listing historii poleceń i utworzone pliki.
Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 sprawozdanie, screenshoty, listing oraz pliki"

git push origin WB410023
```
### Wystawiłam Pull Request do gałęzi grupowej.