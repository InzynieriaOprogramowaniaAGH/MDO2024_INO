# Sprawozdanie 3
Krystian Gliwa, IO.

## Cel projektu


## Pipeline, Jenkins, izolacja etapów

### Przygotowanie

#### Upewnienie się że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach
Aby sprawdzić czy kontenery budujący i testujący dziłają poprawnie użyłem poleceń: 
```
sudo docker build -f Dockerfile_node_build -t node-app-build .
sudo docker build -f Dockerfile_node_test -t node-app-test .
```
W efekcie czego nie otrzymałem żadnych błędów podczas budowania obrazów, tak więc działają poprawnie: 

![dzialanie kontenera budujacego](./zrzuty_ekranu/1.jpg)
![dzialanie kontenera testujacego](./zrzuty_ekranu/2.jpg)

#### Instalacja Jenkinsa
Po zapoznaniu się z instrukcją instalacji Jenkinsa rozpocząłem ją.
Najpierw utworzyłem  sieć mostkowa w Docker poleceniem: 
```
docker network create jenkins
```
Następnie aby wykonać polecenia Docker w węzłach Jenkins, pobierałem i uruchomiłem docker:dind poleceniem: 
```
docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2
  ```
Następnie utorzyłem plik o nazwie *jenkins.Dockerfile* z następującą zawartością:
```
FROM jenkins/jenkins:2.440.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```
I zbudowałem nowy obraz dockera (myjenkins-blueocean:2.440.3-1) z tego pliku poleceniem:
```
docker build -t myjenkins-blueocean:2.440.3-1 -f jenkins.Dockerfile .
```
Na koniec uruchomiłem kontener z tego obrazu poleceniem: 
```
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.440.3-1
```
![dzialajace kontenery](./zrzuty_ekranu/3.jpg)

Różnica między obrazem dockera a blueocean polega na tym, że *docker* to obraz Docker-in-Docker, który zapewnia środowisko Docker wewnątrz kontenera, podczas gdy *blueocean* to obraz Jenkinsa, który został rozbudowany o wtyczkę Blue Ocean, dostarczającą interfejs użytkownika dla Jenkinsa.

### Uruchomienie
Konfiguracja wstępna i pierwsze uruchomienie opisane zostały w poprzednim sprawozdaniu. 
Przeszedłem więc do tworzenia mojego pierwszego projektu który ma za zadanie wyświetlać *uname*
Tak też go nazwałem, po czym w krokach budowania dodałem tylko 
```
uname -a
```
Po czym uruchomiłem build a w efekcie w logach otrzymałem: 

![projekt uname](./zrzuty_ekranu/4.jpg)

Kolejnym krokiem było utworzenie projektu który zwraca błąd gdy godzina jest nieparzysta. 
W buildzie tego projektu dodałem więc kod realizujący to zadanie: 
```
#!/bin/bash
hour=$(date +%H)

if [ $((hour % 2)) -ne 0 ]; then
    echo "Błąd - godzina jest nieparzysta (godzina: $hour)."
    exit 1
else
    echo "Brak błędu - godzina jest parzysta (godzina: $hour)."
fi
```
Wynik: 

![projekt godzina](./zrzuty_ekranu/5.jpg)
![projekt godzina](./zrzuty_ekranu/6.jpg)


Kolejnym krokiem było tym razem utworzenie projektu który: 
- klonuje nasze repozytorium
- przechodzi na osobistą gałąź
- buduje obrazy z dockerfiles i/lub komponuje via docker-compose

Aby go zrealizować skorzystałem z Jenkins Pipeline który umożliwia definiowanie zestawu kroków do wykonania w sposób skryptowy. Definicje ustawiłem na *Pipeline skript* . Moj pipeline składa się z trzech etapów: klonowanie (zawiera w sobie również zmiane na moją gałąź) i build obrazu:
```
pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Klonowanie'
                sh 'rm -r MDO2024_INO || true'
                git branch: 'KG411149', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Budowanie obrazu'
                    sh 'docker build -f ./INO/GCL1/KG411149/Sprawozdanie2/Dockerfile_node_build -t node-build .'
                }
            }
        }
    }
}
```
!["prawdziwy projekt"](./zrzuty_ekranu/7.jpg)



### Wstęp - opracowanie dokumentu z diagramami UML, opisującymi proces CI.

#### Wymagania wstępne środowiska

- uruchomiony obraz DIND,
- uruchomiony obraz blueocean na podstawie obrazu Jenkinsa.

Diagram aktywności, pokazujący kolejne etapy (collect, build, test, report)
!["diagram aktywnosci"](./zrzuty_ekranu/9.jpg)



Diagram wdrożeniowy opisujący relacje między składnikami, zasobami i artefaktami: 
!["diagram wdrozeniowy"](./zrzuty_ekranu/8.jpg)

