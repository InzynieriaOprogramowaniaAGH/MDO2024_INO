Aleksandra Opalska
##Sprawozdanie 2

CEL: Celem labolatorium było utworzenie Dockerfiles oraz konteneru jako definicji etapu.

# Wybór oprogramowania
Repozytorium, które wybrałam działało proprawnie oraz posiadało testy w repozytorium, które można było uruchomić, dlatego zdecydowałam się go użyć to labolatorium i pobrałam repozytorium z prostą grą "ciepło zimno"
https://github.com/anamika8/react-hot-cold/blob/main/README.md
- Sklonowanie repozytorium za pomocą komendy 
```bash
git clone https://github.com/anamika8/react-hot-cold.git
```
![ ](./img/1.png)

- Zainstalowałam potrzebne do uruchomienia pakiety takie jak npm 
```bash
sudo apt install npm
```
![ ](./img/2.png)

- Zbudowałam projekt (build)
```bash
sudo run-script build 
```
![ ](./img/2.png)

- Uruchomiłam grę 
```bash
npm start 
```
po uruchomieniu pokazało się takie okienko, sugerujące, że gra działa
![ ](./img/3.png)

- Przeprowadziłam testy jednostkowe, gdzie "a" sugeruje aby uruchomić wszystkie testy, były również możliwe inne opcje co widać na screen'ie
```bash
npm test a 
```
![ ](./img/5.png)

# Przeprowadzenie buildu w kontenerze

- Pobranie obrazu
```bash
sudo docker pull node
```
pobrane obrazy
![ ](./img/7.png)
- Uruchomienie kontenera w trybie interaktywnym oraz ponowne wykonanie wcześniejszych kroków, takich jak pobranie gita, sklonowanie repozytorium oraz instalacja zależności
```bash
sudo docker run -it node sh
#apt-get update
#apt-get install -y git
#git clone https://github.com/anamika8/react-hot-cold.git
#cd react-hot-cold
#npm i
#npm run-script build
```
![ ](./img/8.png)

- Uruchomienie testów 
```bash
npm test a
```
![ ](./img/9.png)

2. Stworzene dwóch plików Dockerfile
- Stworzenie pierwszego Dockerfile o treści
![ ](./img/10.png)
Plik ten buduje obraz kontenera Docker, który zawiera aplikację React Hot and Cold, instalując wszystkie zależności, budując aplikację i ustawiając odpowiedni katalog roboczy.

- Zbudowanie obrazu
```bash
sudo docker build -t app_build .
```
Wystąpił błąd dotyczący nieprawidłowych ustawień proxy w pliku konfiguracyjnym npm
![ ](./img/11.png)
Naprawienie błędu
![ ](./img/12.png)
Prawidłowe działanie
![ ](./img/13.png)

- Stworzenie drugiego pliku Dockerfile, który jest kontynuacją poprzedniego i buduje testy i jest o treści
 ```bash                                                                                                                                                                                                                         
FROM app_build:latest
RUN CI=TRUE npm test a
```
- Zbudowanie obrazu
 ```bash 
sudo docker build -t app_test -f Dockerfile2 .
```

- Zdefiniowanie kompozycji tworzącej dwie usługi:
![ ](./img/14.png)
Definuje ona dwie usługi kontenerów Docker: build (budowanie obrazu aplikacji) i test (wykonywanie testów w usłudze "test", która zależy od zakończenia budowy obrazu w usłudze build)
- Wdrożenie
 ```bash 
sudo docker-compose build
 ```
![ ](./img/15.png)

#Podsumowanie
Program nie nadaje się do publikacji, gdyż plik docker-composer bardziej skupia się na budowie obrazu i testowaniu. Natomiast jeżeli program miałby być publikowany jako 
kontener Docker, finalnym artefaktem byłby obraz kontenera. Nie byłoby konieczne oczyszczanie go z pozostałości po budowaniu, ponieważ obraz kontenera jest autonomicznym 
pakietem zawierającym wszystko, co jest potrzebne do uruchomienia aplikacji. Jeśli jednak należałoby opublikować aplikację w formie innego pakietu,
można by było rozważyć użycie narzędzi do konwersji obrazu kontenera na wybrany format pakietu. W tym celu dobrą opcją byłoby użycie dodatkowego kroku w procesie budowania,
który konwertuje obraz kontenera na wybrany format pakietu.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Część II

##Zachowanie stanu
- Zapoznanie się z dokumentacją https://docs.docker.com/storage/volumes/
- Przygotowanie voluminów wejściowych i wyjściowych
```bash 
sudo docker volume create input_volume
sudo docker volume create output_volume
```
![ ](./img/16.png)
- Stworzenie nowego Dockerfile, który miał za zadanie updatować, ponieważ nie było wymagane instalowania żadnych zależności. 
![ ](./img/17.png)

- Zbudowanie nowego obrazu - my_image, który będzie używać wcześniej stworzonych woluminów
```bash 
sudo docker build -t my_image -f Dockerfile3 .
```
![ ](./img/18.png)
- Uruchomienie kontenera my_container na podstawie obrazu w trybie interaktywnym, wyświetlenie zawartości katalogu, przejście do katalogu input oraz sklonowanie repozytorium
```bash 
#ls
#cd input 
#cd git clone https://github.com/anamika8/react-hot-cold.git
```
- Zainstalowanie niezbędnych zależności 
```bash 
npm config set fetch-retry-mintimeout 2000
npm config set fetch-retry-maxtimeout 2000
npm i
```
![ ](./img/19.png)
- Uruchomienie builda
```bash 
#npm run-script build
```
![ ](./img/20.png)
- Zamknnięcie kontenera oraz zlokalizowanie plików zapisanych w woluminach
```bash 
sudo docker inspect input_volume
sudo docker inspect output_volume
```
![ ](./img/21.png)
- Sprawdzenie
![ ](./img/22.png)

Zachowanie stanu przeprowadziłam za pomocą docker build oraz pliku Dockerfile, jednak użyłam polecenia npm run-script build które służy głównie do budowania aplikacji, bez względu na lokalizację. 
Można jednak użyć flagi '--mount' która umożliwia montowanie zasobów podczas budowania obrazu.

#Eksponowanie portu
- Zapoznanie się z dokumentacją https://iperf.fr/
- Pobranie odpowiedniego obrazu 
```bash 
sudo docker pull networkstatic/iperf3
```
![ ](./img/23.png)
- Uruchomienie serwera w kontenerze wyeksponowanie portu 5201 na port 5201 na hoście
```bash 
sudo docker run -it --name my_container2 -p 5201:5201 networkstatic/iperf3 -s
```
![ ](./img/24.png)
- Sprawdzenie adresu IP kontenera oraz podłączenie się z serwerem z nowego kontenera 
```bash 
sudo docker inspect my_container2
sudo docker run -it --name my_container3 networkstatic/iperf3 -c 172.17.0.2
```
![ ](./img/25.png)
- Pobranie iperf3
- Połączenie się z serwerem 
```bash 
iperf3 -c 172.17.0.1 -p 5201
```
![ ](./img/26.png)

#Instalacja Jenkins
- Zapoznanie się z dokumentacją https://www.jenkins.io/doc/book/installing/docker/
- Stworzenie nowej sieci mostkowej w Dokerze
```bash 
sudo docker network create jenkins
```
![ ](./img/27.png)
- Pobranie i uruchomienie obrazów Docker używając komend podanych w dokumentacji
```bash 
sudo docker run --name jenkins-docker --rm --detach
--privileged --network jenkins --network-alias docker
--env DOCKER_TLS_CERTDIR=/certs
--volume jenkins-docker-certs:/certs/client
--volume jenkins-data:/var/jenkins_home
--publish 2376:2376
docker:dind --storage-driver overlay2
```
![ ](./img/28.png)
- Stworzenie pliku Dockerfile4 o treści zbliżonej do tej zawartej w dokumentacji
```bash 
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

- Stworzenie nowego obrazu na podstawie pliku Dockerfile4 i przypisanie mu nazwy myjenkins-blueocean:2.440.2-1"
```bash 
sudo docker build -t myjenkins-blueocean:2.440.2-1 -f Dockerfile4 .
```
![ ](./img/30.png)
- Uruchomienie własnego obrazu jako myjenkins-blueocean jako kontenera w Dokerze
```bash 
sudo docker run --name jenkins-blueocean --restart=on-failure --detach
--network jenkins --env DOCKER_HOST=tcp://docker:2376
--env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1
--publish 8080:8080 --publish 50000:50000
--volume jenkins-data:/var/jenkins_home
--volume jenkins-docker-certs:/certs/client:ro
myjenkins-blueocean:2.440.2-1
```
![ ](./img/31.png)
- Wyświetlenie aktywnych kontenerów
![ ](./img/32.png)
- Sprawdzenie IP hosta, gdyż aby uzyskać dostęp do serwera Jenkins należy przekierować odpowiednie porty z wirtualnej maszyny do systemu gospodarza.
![ ](./img/33.png)
- Dodanie nowego portu oraz wpisanie http://localhost:8080 w wyszukiwarkę
![ ](./img/34.png)
- Wyciągnięcie hasła ze wskazanej lokalizacji z kontenera jenkins-blueocean
```bash 
sudo docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
![ ](./img/35.png)
- Instalacja wymaganych wtyczek
![ ](./img/36.png)
- Utworzenie konta admina
![ ](./img/37.png)

#Napotkane błędy
Podczas labolatorium napotkałam błąd z brakiem pamięci. 
1. Na poczatku sprawdziłam zyżycie miejsca na dysku
```bash 
df -h
```
2. Znalazłam największe pliki
```bash 
du -h --max-depth=1 / | sort -rh
```
3. Usunęłam niepotrzebne pakiety zainstalowane przez apt
```bash 
sudo apt-get autoremove
```
4. Usunęłam pliki tymczasowe
```bash 
sudo apt-get clean
```
5. Niestety pamięć była nadal zbyt mała dlatego stworzyłam nową maszyne wirtualną z pamięcią dynamiczną. 