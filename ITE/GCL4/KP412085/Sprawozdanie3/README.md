# Sprawozdanie 3

Pierwsza część laboratoriów polegała na sprawdzeniu poprawności działania kontenerów budujących i testujących dla wybranej aplikacji z poprzednich zajęć. 

# Przygotowanie

**1. Przetestowanie kontenerów do budowania i testowania z poprzednich zajęć**
<br>
W tym celu korzystamy ze zbudowanego wcześniej pliku `docker-compose.yml`, który definiuje sposób uruchomienia kontenerów `build` i `test`. Sam plik jest zdefiniowany w następujący sposób:

>```dockerfile
>services:
>  irssi-build:
>    build:
>      context: .
>      dockerfile: irssi-build.Dockerfile
>    image: irssi-build:0.1
>    container_name: irssi-build
>
>    restart: 'no'
>
>  irssi-test:
>    build:
>      context: .
>      dockerfile: irssi-test.Dockerfile
>    image: irssi-test:0.1
>    container_name: irssi-test
>
>    depends_on:
>      - irssi-build
>    restart: 'no'
>```

Jego uruchomienie za pomocą poniższej komendy daje następujący wynik:
```
docker-compose -f <path_to_docker_compose> up
```

![docker_compose](./screenshots/docker-compose-up.png)

<br>

**2. Przygotowanie, uruchomienie i skonfigurowanie Jenkinsa w kontenerze z pluginem BlueOcean**

<br>

Przedstawione kroki wykonane zgodnie z instrukcją [https://www.jenkins.io/doc/book/installing/docker/](https://www.jenkins.io/doc/book/installing/docker/) zostały wykonane i opisane w poprzednim sprawozdaniu. Poniżej przedstawiam działjący kontener `jenkins-blueocean` oraz udostępniane porty i zbindowane wolumeny, które zapewniają zabezpieczenie przestrzeni roboczej `/var/jenkins_home` (logów).

![bluocean_config](./screenshots/blueocean-config.png)

**3. Blue Ocean**
<br>
>Blue Ocean as it stands provides easy-to-use Pipeline visualization. It was intended to be a rethink of the Jenkins user experience, designed from the ground up for Jenkins Pipeline. Blue Ocean was intended to reduce clutter and increases clarity for all users.

***Blue Ocean to plugin dostępny w Jenkinsie, który umożliwia bardziej intuicyjne UI do budowania pipelinów w Jenkinsie, oferując dynamiczną, złożoną wizualizację,edytor pipelinów, personalizację, natywną integrację pull requestów przy pracy w GitHubie lub BitBucket.***

# Uruchomienie 

**1. uname_job, odd_hour_job - zadania jenkinsa**
<br>
Pierwszym krokiem było zbudowanie dwóch prostych projektów. Pierwszy wyświetlający wynik komendy `uname`. Drugi kończący się jako `SUCCESS` lub `FAIL` w zależności od parzystości godziny. W tym celu tworzymy zadania dla każdego projektu. Wykonujemy to poprzez kroki: `Nowy projekt`, gdzie podajemy nazwę zadania oraz wybieramy opcję `general-puropse job`. Następnie dodajemy polecenie w konfiguracji zadania, w `Uruchom powłokę`, uruchamianej podczas budowania.

Dla zdania pierwszego polecenie wygląda następująco:
```bash
uname
```

Zadanie drugie:
```bash
#!/bin/bash

hour=$(date +%-H)

if (( hour % 2 != 0 )); then
    echo "Błąd: godzina $hour jest nieparzysta"
    exit 1
else
    echo "Godzina $hour jest parzysta"
    exit 0
fi
```

Logi tych zadań prezentują się następująco:

- Poprawne wykonanie buildu z jednym poleceniem `uname`

![uname_log](./screenshots/uname_log.png)

- Błąd zgodny z założeniem - nieparzysta godzina, status wykonania zadania `FAILED`

![odd_log](./screenshots/odd_log.png)

**2.Projekt irssi**
<br>
Aby uruchomić projekt z poprzednich zajęć poprzez zadanie Jenkinsa, które polega na sklonowaniu repozytorium, przełączeniu się na odpowiednią gałąź i zbudowaniu obrazów do budowania i testowania tworzymy nowy projekt. Nasze repozytorium jest publiczne, dlatego nie musimy podawać `credensials` aby umożliwić jego sklonowanie. Tym samym konfiguracja wygląda następująco:

![irssi_config](./screenshots/git_config.png)

Polecenie wykonywane w powłoce do uruchomienia zdefiniowanego na poprzednich zajęciach pliku `docker-compose`: 
```bash
cd ~/ITE/GCL4/KP412085/Sprawozdanie2/irssi/
docker-compose -f docker-compose.yml up
```
Jednak przed wykonaniem tego zadania sprawdzamy czy mamy w kontenerze jenkinsa zainstalowane rozszerzenie `docker-compose`. Możemy to sprawdzić poprzez:
```bash
docker exec -t <jenkins-container-id> bash docker-compose --help
```
Ponieważ instalowałem tylko rozszerzenie `docker`, polecenie to wyświetla błąd, dlatego poprzez UI Jenkinsa pobieram dodatkowego plugina `docker compose build step`:

![docker_install](./screenshots/docker_compose_jenkins.png)

Jest to jednak plugin tylko dodający `step` do projektu, co powoduje, że nie pobiera on `docker-compose`. Umożliwia on tylko graficzne zdefiniowanie zadania, zamiast definiowania polecenia w powłoce. Aby pobrać właściwe rozszerzenie korzystam z instrukcji [https://docs.docker.com/compose/install/linux/#install-using-the-repository](https://docs.docker.com/compose/install/linux/#install-using-the-repository), którą realizuję bezpośrednio w kontenerze jenkinsa. Rezultat jest następujący:

![dc_install](./screenshots/dcompose_install.png)

***Uwaga! Pobrane rozszerzenie to docker compose (nie docker-compose). Jest to nowsza wersja tej funkcjonalności instalowana domyślnie w Docker Desktop, przy czym stara wersja docker-compose oznaczona została jego deprecated i nie jest dalej wspierana.***

W związku z powyższym zamiast korzystania z pobranego pluginu, który korzysta ze starego polecenia `docker-compose` (poniżej zdefiniowany za pomocą plugina build step):

![build-step](./screenshots/docker-build-step.png)

Korzystamy z zdefiniowania polecenia `docker compose` w powłoce, co wygląda następująco:

![powloka-docker](./screenshots/compose-powloka.png)

Przed uruchomieniem tego zadania upewniamy się że mamy uruchomiony kontener zbudowany na wsześniejszych zajęciach za pomocą:

>```docker
>docker run /
> --name jenkins-docker /
>  --rm /
>  --detach /
>  --privileged /
>  --network jenkins  --network-alias docker /
>  --env DOCKER_TLS_CERTDIR=/certs /
>  --volume jenkins-docker-certs:/certs/client  --volume jenkins-data:/var/jenkins_home /
>  --publish 2376:2376 /
>  docker:dind /
>  --storage-driver overlay2
>```


Ostatecznie zadanie `irssi_job` po uruchomieniu zostaje zakończone z kodem sukcesu:

![irssi_log](./screenshots/irssi-log.png)

**3. Irssi pipeline**
<br> 

Na podstawie obrazów `dockerfile` z poprzednich zajęć tworzę pipeline'a dla aplikacji irssi. Zawiera on 3 etapy: `Prepare`, `Build` oraz `Test`. Obrazy budowane i testowane będą na dedykowanym `DIND` dla bezpieczeństawa wykonania. Dokładniejsze rozróżnienie pomiędzy przeprowadzaniem tych etapów w `DIND` lub bezpośrednio w kontenerze `CI` podam poniżej. Dla tego pipeline'a plik `Jenkinsfile` zostanie umieszczony w repozytorium w osobnym katalogu. 

Jenkinsfile dla `irssi_pipeline` wygląda następująco:
```Jenkinsfile
pipeline {
    agent any
    
    environment {
        IMAGE_TAG = new Date().getTime()
    }

    stages {
        stage('Prepare') {
            steps {
                sh 'rm -rf MDO2024_INO'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
                dir("MDO2024_INO"){
                    sh 'git checkout KP412085'
                }
            }
        }
        
        stage('Build') {
            steps {
                dir("MDO2024_INO/ITE/GCL4/KP412085/Sprawozdanie2/irssi"){
                    sh 'docker build --no-cache -t irssi-build:${IMAGE_TAG} -f irssi-build.Dockerfile .'
                }
            }
        }
        
        stage('Test') {
            steps {
                dir("MDO2024_INO/ITE/GCL4/KP412085/Sprawozdanie3/irssi"){
                    sh 'docker build --no-cache --build-arg IMAGE_TAG=$IMAGE_TAG -t irssi-test:${IMAGE_TAG} -f irssi-test-date-tag.Dockerfile .'
                }
            }
        }
    }
}
```

`IMAGE_TAG` to oznaczenie, które definiuje nasz konkretny obraz do budowania i testowania poprzez tag (może także wersjonować naszą wersją do deploymentu i publish). Data pobierana jest poprzez kod Groovy, i dołączana jako tag do każdego tworzonego obrazu na każdym etapie. Po sklonowaniu repozytorium i przełączeniu się na odpowiednią gałąź, przechodzimy do katalogu z projektem i budujemy obraz. Waże jest aby uwzględnić to, że przy każdym uruchomieniu piepeline'a, musimy usunąć repozytorium, które wcześniej sklonowaliśmy. Dzieje się tak dlatego, że wszystkie nasze projekty w Jenkinsie są zapisywane w kontenerze jenkinsa w lokalizacji `/var/jenkins_home`, która została zbindowana przy tworzeniu obrazu jenkinsa. Oznacza to, że wszystkie dane pipeline są zapisywane w tej lokalizacji w odpowiednim katalogu. Ponadto wykonując zagnieżone kroki, umieszczamy je w `dir(""){}`, aby zachować położenie pomiędzy kolejnymi poleceniami.

Dla celu zbudowania tego prostego pipeline'u modyfikuję także plik `dockerfile` do testowania w taki sposó, aby przyjmował jako argument budowania odpowiedni tag obrazu `build` z którego ma korzystać. Modyikacja ta jest następująca:

```dockerfile
ARG IMAGE_TAG

FROM irssi-test:$IMAGE_TAG

WORKDIR /irssi/Build

RUN ninja test
```

Uruchomienie takiego `dockerfila` wygląda następująco:

```bash
docker build --build-arg IMAGE_TAG=$IMAGE_TAG -t irssi-test:${IMAGE_TAG} -f irssi-test-date-tag.Dockerfile .
```

Po uruchomieniu takiego pipeline'a otrzymujemy następujący wynik:


**4. Róznica pomiędzy DIND oraz budowaniem bezpośrednio w kontenerze CI**

- <b>Budowanie na dedykowanym DIND (Docker-in-Docker):</b>
    - Izolacja środowiska: W tym podejściu każde zadanie budowania uruchamiane jest w oddzielnym kontenerze Docker, który działa wewnątrz innego kontenera Docker. Oznacza to, że proces budowania odbywa się w pełni izolowanym środowisku, które ma dostęp do pełnego stosu Docker.
    - Złożoność konfiguracji: Konfiguracja DIND może być bardziej złożona ze względu na potrzebę zapewnienia poprawnej konfiguracji warstw kontenerów. Wymaga to odpowiedniej konfiguracji uprawnień i ustawień, aby zapobiec potencjalnym problemom bezpieczeństwa i wydajności.
    - Wykorzystanie zasobów: Uruchomienie kontenera Docker w kontenerze może być bardziej zasobożerne niż uruchomienie kontenera CI bezpośrednio na hostu, ponieważ wymaga dodatkowej warstwy wirtualizacji.
- <b>Budowanie na kontenerze CI:</b>
    - Prostota konfiguracji: W przypadku bezpośredniego uruchomienia kontenera CI na hoście nie ma potrzeby konfigurowania DIND ani zarządzania warstwami kontenerów. Jest to zazwyczaj prostsze podejście konfiguracyjne.
    - Wykorzystanie zasobów: Uruchomienie kontenera CI bezpośrednio na hoście może być bardziej wydajne pod względem zużycia zasobów niż uruchomienie DIND, ponieważ eliminuje dodatkową warstwę wirtualizacji.
    - Izolacja środowiska: Mimo że uruchomienie kontenera CI na hoście może nie zapewniać takiej samej izolacji środowiska co DIND, to wciąż może być wystarczające dla wielu przypadków użycia.







