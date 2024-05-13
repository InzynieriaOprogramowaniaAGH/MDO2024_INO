# Zajęcia 05
---
## Pipeline, Jenkins, izolacja etapów

## Przygotowanie
### Instancja Jenkins

Podąrzając za instrukcjami w dokumentacji zaczynam od stworzenia sieci mostkowej dla jenkinsa:
```
docker network create jenkins
```

Następnie przeklejam polecenie, które pobierze obraz DIND (docker in docker) i uruchomi kontener z odpowiednimi parametrami:
```
docker run \
--name jenkins-docker \
--rm \
--detach \
--privileged \
--network jenkins \
--network-alias docker \
--env DOCKER_TLS_CERTDIR=/certs \
--volume jenkins-docker-certs:/certs/client \
--volume jenkins-data:/var/jenkins_home \
--publish 2376:2376 \
docker:dind \
--storage-driver overlay
```

Następnie należy zbudować nowy obraz na podstawie dockerfile'a zawartego w instrukcji:
```
FROM jenkins/jenkins:2.440.2-jdk17
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

Kolejnym ruchem jest zbudowanie obrazu wywołując:
```
docker build -t myjenkins-blueocean:2.440.2-1 -f jenkins.Dockerfile .
```

Po zbudowaniu można uruchomić kontener wywołując:
```
docker run \
--name jenkins-blueocean \
--restart=on-failure \
--detach \
--network jenkins \
--env DOCKER_HOST=tcp://docker:2376 \
--env DOCKER_CERT_PATH=/certs/client \
--env DOCKER_TLS_VERIFY=1 \
--publish 8080:8080 \
--publish 50000:50000 \
--volume jenkins-data:/var/jenkins_home \
--volume jenkins-docker-certs:/certs/client:ro \
myjenkins-blueocean:2.440.2-1 
```

Kontener uruchamia się w tle i publishuje na port 8080 - jest to port pod którym znajdę ekran logowania jenkinsa.

![jenkins login](../Sprawozdanie2/ss/4_4_jenkins_logyn.png)

Obraz blueocean oferuje nowoczesny interfejs użytkownika, który ułatwia proces budowy, testowania i wdrażania aplikacji. Praca z blueocean jest bardziej zrozumiała dla użytkownika niż praca z jenkinsem.

### Wybrana aplikacja

Wybrałem aplikację [Irssi]("https://github.com/irssi/irssi") - modularny klient czatu do komunikacji poprzez np. IRC. Zbuduję go przy pomocy narzędzia meson.
Aplikacja jest na licencji GNU GPL.
  
### Uruchomienie 
**Projekt wyświetlający uname:**

Utworzyłem nowy freestyle project, w którym dodałem build step uruchamiający polecenia w powłoce. Uname odczytałem poleceniem `uname -a`.

![uname shell](ss/1_1_build_step.png)

![uname run](ss/1_2_uname.png)

**projekt, który zwraca błąd, gdy... godzina jest nieparzysta:**

Utowrzyłem kolejny projekt - tym razem w build stepie wykonałem sekwencję poleceń, która sprawdzała czy godzina jest parzysta (`exit 1` oznacza build jako failure).

![hour shell](ss/1_3_hour_script.png)

![hour good](ss/1_4_hour_print.png)

![hour fail](ss/1_5_hour_err.png)


### Prawdziwy projekt:
Utworzyłem nowy projekt z szablonu pipeline, a pipeline podzieliłem na 3 kroki:
```
Preparation - zaciągnięcie danych z mojej gałęzi repozytorium
Build - zbudowaniu aplikacji za pomocą dockerfile
Test - przetestowanie aplikacji za pomocą dockerfile
```

Plugin gita w jenkinsie pozwala na wygodne pobranie repozytorium poleceniem:
```
git branch: 'TD412544', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
```

Sugerując się pipeline scriptem Hello World napisałem własny, który realizował wymienione trzy kroki:
```
pipeline {
    agent any

    stages {
        stage('Preparation') {
            steps {
                echo 'Preparation'
                sh 'docker rmi irssi-builder irssi-test || true'
                sh 'rm -rf MDO2024_INO'
                
                sh 'mkdir MDO2024_INO'
                dir('./MDO2024_INO'){
                    git branch: 'TD412544', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
                }
                sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/dependencies.Dockerfile -t irssi-dependencies .'
            }
        }
        stage('Build') {
            steps {
                echo 'Build'
                dir ('./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES') {
                    sh 'docker build -f ./build.Dockerfile -t irssi-builder .'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Test'
                sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/test.Dockerfile -t irssi-test --progress=plain --no-cache .'
            }
        }
    }
}

```


### Sprawozdanie (wstęp)
* Opracuj dokument z diagramami UML, opisującymi proces CI. Opisz:
  * Wymagania wstępne środowiska
  * Diagram aktywności, pokazujący kolejne etapy (collect, build, test, report)
  * Diagram wdrożeniowy, opisujący relacje między składnikami, zasobami i artefaktami
* Diagram będzie naszym wzrocem do porównania w przyszłości
  

## Omówienie kroków pipelineu
### Preparation
W pierwszym kroku usuwam repozytorium i klonuje na nowo żeby zagwarantować że jego zawartość będzie czysta. Usuwam też zbudowane wcześniej obrazy żeby zapewnić pracę na nowych oraz folder z logami poprzedniego builda, dlatego że są archiwizowane jako artefakty.

```
stage('Preparation') {
  steps {
    echo 'Preparation'
    sh 'docker rmi irssi-dependencies irssi-builder irssi-test || true'
                
    sh 'rm -rf MDO2024_INO'
    sh 'rm -rf LOGS'
    
    sh 'mkdir MDO2024_INO'            
    sh 'mkdir LOGS'
                
    dir('./MDO2024_INO'){
      git branch: 'TD412544', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
    }
    sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/dependencies.Dockerfile -t irssi-dependencies .'
  }
}
```

Pierwsze polecenie powłoki usuwa obrazy (stosuje `|| true` żeby nie przerwać działania pipelineu gdy docker nie znajduje obrazu), następnie usuwane są foldery repozytorium i logów, po czym są na nowo tworzone żeby przygotować pipeline do dalszej pracy.

Używam plugina gita żeby Jenkins zklonował repozytorium i od razu przełączył się na moją gałąź.

Na koniec buduje kontener zawierający dependencje.
```
FROM fedora:40

RUN dnf -y update
RUN dnf -y install git gcc meson ninja* glib2-devel utf8proc-devel ncurses* perl-Ext* openssl-devel
```
Zdecydowałem się na wersję fedora:40, dlatego że jest to nowa wersja fedory, a aplikacja zarówno się na niej buduje jak i uruchamia.

### Build
Ten krok polega na uruchomieniu buildera za pomocą DIND i zarchiwizowaniu logów z procesu budowania.
```
stage('Build') {
  steps {
    echo 'Build'
    sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/build.Dockerfile -t irssi-builder . 2>&1 | tee ./LOGS/build_${BUILD_NUMBER}.txt'
    archiveArtifacts artifacts: "LOGS/build_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
  }
}
```
Przekierowuje stderr na stdout za pomocą `2>&1`, a następnie przepycham output do wersjonowanego pliku. Zmienna środowiskowa Jenkinsa `BUILD_NUMBER` oznacza który raz w tym pipelinie jest przeprowadzany build. Następnie zlecam archiwizację powstałych logów w postaci artefaktów z doprecyzowaniem, że chcę zapisac również w przypadku wystąpienia błędów.

### Test
Testowanie odbywa się w kontenerze bazującym na obrazie zbudowanym przez builder. Kontener ten wywyłuje polecenie `ninja test` w katalogu ze zbudowana aplikacją.
```
stage('Test') {
  steps {
    echo 'Test'
    sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/test.Dockerfile -t irssi-test --no-cache . 2>&1 | tee ./LOGS/test_${BUILD_NUMBER}.txt'
    archiveArtifacts artifacts: "LOGS/test_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
  }
}
```
Logi przeprowadzanej operacji, podobnie jak w przypadku builda, zapisywane są w pliku tekstowym i archiwizowane w postaci artefkatów.

Wynik builda:

![build](ss/1_6_build.png)

Wynik testów odczytany z artefaktu:

![tests](ss/1_7_tests.png)
### Deploy
Deployment rozumiem jako uruchomienie aplikacji w kontenerze, co zamierzam zrealizować dzięki nowemu obrazowi.
```
FROM irssi-builder
WORKDIR /irssi
RUN ninja -C Build install
ENTRYPOINT [ "irssi" ]
```
Powyższy dockerfile instaluje irssi zgodnie z zaleceniami z githuba. Jego entrypoint jest ustawiony na samą aplikację co znaczy, że uruchomienie kontenera "na sucho" będzie skutkowało w przejściu do irssi.

Krok ten zrealizowałem w pipelinie w ten sposób:
```
stage('Deploy'){
  steps{
    echo 'Deploy'
    sh 'docker build -f ./MDO2024_INO/INO/GCL1/TD412544/Sprawozdanie3/IRSSI_DOCKERFILES/deploy.Dockerfile -t irssi-deploy .'
    sh 'docker run --rm --name irssi-deploy -t -d -e TERM=xterm irssi-deploy'
    sh 'docker ps > LOGS/deploy_docker_ps_${BUILD_NUMBER}.txt'
    sh 'docker stop irssi-deploy'
    archiveArtifacts artifacts: "LOGS/deploy_docker_ps_${BUILD_NUMBER}.txt", onlyIfSuccessful: false
  }
}
```
Jako sposób weryfikacji działania obrałem sprawdzenie, czy po uruchomieniu kontenera pozostaje on uruchomiony (aplikacji irssi utrzymuje go przy życiu (i czy istnieje - flaga `--rm`)). Próbowałem zapisać interfejs aplikacji jako log (`docker logs irssi-deploy > log.txt`), ale wewnątrz Jenkinsa otrzymywałem plik o rozmarze 0B - poza Jenkinsem działało normalnie.

Zapisuje output `docker ps` w postaci logu z deploymentu jako artefakt.

![deploy](ss/1_8_deploy.png)

Zawartość logu (listing `docker ps`):

![deploy log](ss/1_9_deploy_log.png)

### Publish
Jako
