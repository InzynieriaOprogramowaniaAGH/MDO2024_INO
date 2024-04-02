# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 3 - Dockerfiles, kontener jako definicja etapu

### Opis celu i streszczenie projektu:

Celem zajeć jest zapoznanie się z technikami konstruowania aplikacji oraz pogłębianie wiedzy o Dockerfile. Dodatkowo, poznanie nowych pojęć związanych z konteneryzacją - 
woluminy oraz eksponowanie portów (aspekt sieciowy).

Projekt rozpoczynamy od wyboru odpowiedniego oprogramowania, jego konstrukcji oraz przetestowania w naszym aktualnym środowisku. To pozwoli nam na zebranie niezbędnych informacji do późniejszego przeprowadzenia tych samych kroków w środowisku konteneryzowanym.
Zapoznamy się również z terminem "wolumin" oraz jego zastosowaniem - jeden do budowy naszego oprogramowania, a drugi do przeniesienia zawartości zbudowanego projektu.
Dodatkowo, zainicjujemy serwer iperf, nawiążemy do niego połączenie z kontenerem, przetestujemy ruch sieciowy oraz sprawdzimy możliwość połączenia spoza hosta. Na zakończenie, przeprowadzimy instalację Jenkinsa.

## Zrealizowane kroki:
### 1. Znaleziono repozytorium z kodem dowolnego oprogramowania na GitHub - prosty projekt "Game-of-Life" przedstawiający grę w życie, napisany w języku Python. Projekt umożliwia łatwe wywołanie testów jednostkowych.

Repozytorium projektu: https://github.com/fairoos-nm/Game-of-Life/
![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/game_of_life.jpg)

Skopiowanie zawartości presonal access token oraz sklonowanie repozytorium:

```bash
git clone https://${TOKEN}@github.com/fairoos-nm/Game-of-Life.git
```

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/1.jpg)

### 2. Przeprowadzono budowę (build programu) oraz konfigurację środowiska Python na moim OS.
Otworzenie pobranego repozytorium:
```bash
cd Game-of-Life
```
Instalacja oraz konfiguracja środowiska Python:
```bash
sudo apt install python3-pip
```
![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/2.jpg)

Kompilacja oraz uruchomienie programu:
```bash
python3 main.py
```
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/3.jpg)

### 3. Uruchomienie testów jednostkowych dołączonych do repozytorium na OS.

Instalacja oraz konfiguracja środowiska do testowania w Python:
```bash
pip install pytest
```
![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/4.jpg)
```bash
sudo apt install python-pytest
```
![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/5.jpg)

Wykonanie testów jednostkowych:
```bash
~/.local/bin/pytest
```
![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/6.jpg)

Wniosek: 5 testów aplikacji przeszło, 1 test nie przeszedł.

### 4. Przeprowadzono build interaktywnie w kontenerze.

Upewnienie się, że docker jest zainstalowany:
```bash
docker --version
```
Zalogowanie się do docker:
```bash
docker login
```
![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/7.jpg)

Pobranie odpowiedniego oprogramowania na podstawie wybranego programu:
```bash
docker pull ubuntu:latest
```
Wyświetlenie pobranych obrazów:
```bash
docker images
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/8.jpg)

Interaktywne uruchomienie ubuntu oraz wyjście z kontenera:
```bash
docker run -it ubuntu
exit
```
![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/9.jpg)

Wyświetlenie kontenerów:
```bash
docker ps -a
```
Uruchomienie konkretnego kontenera:
```bash
docker start <CONTAINER_ID>
```
![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/10.jpg)

Ponowne interaktywne uruchomienie kontenera ubuntu:
```bash
docker exec -it <CONTAINER_ID> bash
```
Upewnienie się, czy git jest zainstalowany wewnątrz kontenera, oraz instalowanie środowiska git:
```bash
git --version

apt-get update && apt-get install -y git
```
![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/11.jpg)

Klonowanie aplikacji z repozytorium github'a:
```bash
git clone https://${TOKEN}@github.com/fairoos-nm/Game-of-Life.git
```
![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/12.jpg)

Otworzenie pobranego repozytorium, wyświetlenie jego zawartości oraz konfiguracja środowiska wewnątrz kontenera:
```bash
cd Game-of-Life
ls
```
![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/13.jpg)
```bash
apt-get install -y python3 python3-pip
python3 -m pip install pytest
```
![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/14.jpg)
![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/15.jpg)

Kompilacja oraz uruchomienie programu wewnątrz kontenera:
```bash
python3 main.py
```
![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/16.jpg)

Uruchomienie testów jednostkowych wewnątrz kontenera:
```bash
pytest
```
![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/17.jpg)

Wyjście z kontenera:
```bash
exit
```
![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/18.jpg)

### 5. Utworzono dwa pliki Dockerfile automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
#### Kontener pierwszy ma przeprowadza wszystkie kroki aż do builda:

Tworzenie pliku **Dockerfile**:
```bash
nano Dockerfile
```
Treść pliku **Dockerfile**:
```bash
FROM ubuntu:latest

RUN apt-get update && apt-get install -y git

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

RUN git clone https://$GITHUB_TOKEN@github.com/fairoos-nm/Game-of-Life.git

WORKDIR /Game-of-Life

RUN apt-get update && apt-get install -y python3 python3-pip

RUN python3 -m pip install pytest
```
![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/19.jpg)

Utworzenie obrazu o nazwie **builder** w trybie interaktywnym.
```bash
docker build --build-arg TOKEN="<TOKEN>" -t builder .
```
![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/20.jpg)

Wyświetlenie utworzonych obrazów:
```bash
docker images
```
![22](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/21.jpg)

Interaktywne uruchomienie obrazu **builder**, wyświetlenie jego zawartości oraz wyjście z kontenera:
```bash
docker run -it builder
ls
exit
```
![23](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/22.jpg)

Wyświetlenie kontenerów:
```bash
docker ps -a
```
![24](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/23.jpg)

#### Kontener drugi - tester - bazuje na pierwszym obrazie - builder - i wykonuje testy jednostkowe (bez budowy):
Tworzenie pliku **Dockerfile2**:
```bash
nano Dockerfile2
```
![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/24.jpg)
Treść pliku **Dockerfile2**:
```bash
FROM builder

WORKDIR /Game-of-Life

CMD ["pytest"]
```
![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/25.jpg)

Budowanie obrazu o nazwie **tester** w trybie interaktywnym:
```bash
docker build -t tester -f Dockerfile2 .
```
![27](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/26.jpg)

Wyświetlenie pobranych oraz utworzonych obrazów:
```bash
docker images
```
![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/27.jpg)

Interaktywne uruchomienie obrazu **tester**:
```bash
docker run -it tester
```
![29](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/28.jpg)

Pierwszy kontener **builder** wykonuje wszystkie kroki aż do budowy.
Drugi kontener **tester** bazuje na pierwszym kontenerze i przeprowadza testy.
Testy jednostkowe osiągnęły identyczne wyniki, jak we wcześniejszych podpuktach.

Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?

## Zakres rozszerzony tematu sprawozdania

### 1. Zdefiniowano kompozycję - zamiast ręcznie wdrażać kontenery - która tworzy dwie usługi. Pierwszą na bazie dockerfile'a budującego, a drugą na bazie pierwszej.
Tworzenie pliku **docker-compose.yml**:
```bash
nano docker-compose.yml
```
![30](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/29.jpg)

Treść pliku **docker-compose.yml**:
```bash
version: '3.7'

services:
  builder:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - TOKEN=${TOKEN}

  tester:
    build:
      context: .
      dockerfile: Dockerfile2
    depends_on:
      - builder

```
![31](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/30.jpg)

### 2. Kompozycję wdrożono używając **docker-compose**.

Instalacja niezbędnych zależności:
![32](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/31.jpg)

Wdrożenie kompozycji **docker-compose**:
```bash
docker-compose up --build
```
![33](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/32.jpg)
![34](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/33.jpg)

### Przygotowanie do wdrożenia (deploy): dyskusje

### Czy wybrany program nadaje się do wdrażania i publikowania jako kontener, czy taki sposób interakcji nadaje się tylko do builda:
Aplikacja "Game-of-Life" może być łatwo uruchamiana jako kontener, jednak może zajść konieczność interakcji poza kontenerem, zwłaszcza gdy mamy do 
czynienia z oprogramowaniem interaktywnym, które wymaga bezpośredniej interakcji użytkownika z systemem operacyjnym lub innymi zasobami niedostępnymi 
w środowisku kontenerowym.

### W jaki sposób miałoby zachodzić przygotowanie finalnego artefaktu:

#### jeżeli program miałby być publikowany jako kontener:

W przypadku publikacji programu jako kontenera, istnieje konieczność oczyszczenia go z pozostałości po procesie budowania. Jest to istotne 
z punktu widzenia optymalizacji rozmiaru obrazu, aby zminimalizować zajmowane miejsce przez zbędne biblioteki i pliki.

#### jeżeli dedykowany deploy-and-publish byłby oddzielną ścieżką (inne Dockerfiles):

Można zastosować różne pliki Dockerfile dla różnych etapów procesu budowania i wdrażania aplikacji. 
Pierwszy Dockerfile może być użyty do budowania obrazu zawierającego kod źródłowy oraz wszystkie potrzebne zależności do uruchomienia aplikacji w kontenerze. 
Drugi Dockerfile może być wykorzystany wyłącznie do uruchomienia testów na już skompilowanym obrazie. 
Trzeci Dockerfile może być przeznaczony do przygotowania finalnego obrazu, który będzie zawierał tylko niezbędne pliki i zależności, 
a także zostanie oczyszczony ze zbędnych danych, aby był gotowy do wdrożenia.

#### Czy zbudowany program należałoby dystrybuować jako pakiet, np. JAR, DEB, RPM, EGG:

Format dystrybucji aplikacji zależy od konkretnych wymagań projektu oraz środowiska, w którym aplikacja będzie wdrażana. Na przykład, jeśli aplikacja jest napisana w języku Java, to JAR może być odpowiednim formatem dystrybucji, umożliwiając przenośność i łatwe uruchamianie na różnych platformach. Natomiast w przypadku systemów operacyjnych opartych na Linuxie, takich jak Ubuntu, bardziej odpowiednimi formatami mogą być DEB lub RPM, które pozwalają na łatwą instalację, zarządzanie zależnościami oraz integrują się z systemem pakietów. Ważne jest dostosowanie formatu dystrybucji do potrzeb i charakterystyki środowiska, w którym aplikacja będzie używana, aby zapewnić optymalną wydajność i łatwość zarządzania.

#### W jaki sposób zapewnić taki format:

Aby zagwarantować odpowiedni format, można zastosować trzeci kontener w procesie budowania. Na przykład, można stworzyć Dockerfile dla tego trzeciego kontenera, który będzie wyposażony w narzędzia umożliwiające tworzenie pakietów w wybranym formacie. Następnie, pliki i zależności niezbędne do utworzenia finalnego pakietu gotowego do dystrybucji mogą być skopiowane z obrazu drugiego kontenera do trzeciego.

### 6. Dodano sprawozdanie, zrzuty ekranu oraz listing historii poleceń.

Wykorzystane polecenia: 
```bash
git add .

git commit -m "WB410023 sprawozdanie, screenshoty, listing oraz Dockerfile"

git push origin WB410023
```

## Laboratorium 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Zrealizowane kroki:

### Zachowywanie stanu:

### 1. Zapoznano się z dokumentacją https://docs.docker.com/storage/volumes/.

### 2. Przygotowano wolumin wejściowy i wyjściowy oraz podłączono je do kontenera bazowego z Lab03.

Utworzenie woluminu wejściowego i wyjściowego o nazwach **input_volume** i **output_volume**.
```bash
docker volume create input_volume
docker volume create output_volume
```
![35](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image1.jpg)

### 3. Uruchomiono kontener, zainstalowano niezbędne wymagania wstępne (bez gita).
Uruchamienie kontenera bazowego z obrazem **Ubuntu**:
```bash
docker run -v input_volume:/input -v output_volume:/output -it ubuntu
```
![36](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image2.jpg)

Instalacja niezbędnych wymagań wstępnych:
```bash
apt-get update
```
![37](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image3.jpg)

### 4. Sklonowano repozytorium na wolumin wejściowy.
Klonowanie repozytorium z katalogu na dysku do katalogu **input**:
```bash
docker cp Game-of-Life ${CONTAINER_ID}:/input
```
![38](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image4.jpg)

Interaktywne uruchomienie kontenera oraz wyświetlenie zawartości katalogu **input**:
```bash
docker start ${CONTAINER_ID}
docker exec -it ${CONTAINER_ID} bash
```
![39](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image5.jpg)
```bash
cd input
ls
```
![40](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image6.jpg)

### 5. Uruchomiono build w kontenerze.
Budowanie zależności w kontenerze:
```bash
cd Game-of-Life
apt-get install -y python3 python3-pip
```
![41](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image7.jpg)

```bash
pip install pytest
```
![42](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image8.jpg)

Uruchomienie testów:
```bash
pytest
```
![43](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image9.jpg)

### 6. Zapisano zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.
Aplikacja jest napisana w języku Python - nie zwraca żadnych plików. Z tego powodu na woluminie wyjściowym wstawiono katalog Game-of-Life.
Kopiowanie katalogu Game-of-Life do woluminu wyjściowego:
```bash
cd output
```
![44](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image10.jpg)
```bash
cp -r ../input/Game-of-Life/ .
```
![45](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image11.jpg)

Uruchomienie testów na woluminie wyjściowym:
```bash
cd Game-of-Life
pytest
```
![46](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image12.jpg)

### Eksponowanie portu:

### 1. Zapoznano się z dokumentacją https://iperf.fr/.
Pobranie obrazu networkstatic/iperf3:
```bash
docker pull networkstatic/iperf3
```
![47](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image13.jpg)

### 2. Uruchomiono serwer **iperf3** wewnątrz kontenera.
```bash
docker run -it --name=server -p 5201:5201 networkstatic/iperf3 -s
```
![48](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image14.jpg)


### 3. Połączono się z serwerem z drugiego kontenera oraz zbadano ruch.
Sprawdzenie adresu IP serwera:
```bash
docker inspect server
```
![49](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image15.jpg)

Otworzono drugi terminal (klienta).
Interaktywne połączenie się z serwerem z kontenera klienta:
```bash
docker run -it --name=client networkstatic/iperf3 -c ${IP_ADDRESS}
```
![50](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image16.jpg)
Kontener serwera:
![51](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image17.jpg)


### 4. Połączono się z hosta.
Aktualizacja zależności:
```bash
sudo apt update
```
![52](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image18.jpg)

Instalacja iperf3:
```bash
sudo apt install iperf3
```
![53](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image19.jpg)


Połączenie się z hostem z kontenera klienta:
```bash
iperf3 -c localhost -p 5201
```
![54](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image20.jpg)

Kontener serwera:

![55](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image21.jpg)


### 5. Połączono się spoza kontenera (spoza hosta).
Aby wykonać to zadanie wykorzystałem drugie urządzenie (laptop), które jest w tej samej sieci.

Pobrano tam aplikację iperf z strony: https://iperf.fr/iperf-download.php#windows

Sprawdzenie adresu IP na urządzeniu serwera:
```bash
ipconfig
```

Próba połączenia się z urządzeniem spoza hosta:
```bash
.\iperf3.exe -c ${IP_ADDRESS} -p 5201
```
![56](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image23.jpg)

Nie udało się połączyć, prawdopodobnie dlatego, że adres IP może być niewidoczny.


### 6. Przedstawiono przepustowość komunikacji:
- **Kontener-Kontener** -> 27.0 Gbits/sec
- **Kontener-Host** -> 28.4 Gbits/sec
- **Kontener-Host Zewnętrzny** -> udało się połączyć.

### 7. Zainstalowanie niezbędnych narzędzi:

```bash
sudo apt install net-tools
```
![57](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image22.jpg)

### 8. Wyciągnięto oraz wyświetlono logi z kontenera.
```bash
docker logs server > logs.txt
cat logs.txt
```
![58](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image24.jpg)

![59](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image25.jpg)

### Instancja **Jenkins**:

### 1. Zapoznano się z dokumentacją:
- https://www.jenkins.io/doc/book/installing/docker/ 

### 2. Przeprowadzono instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND.
Utworzenie nowej sieci o nazwie **jenkins** w Dockerze oraz wyświetlenie sieci:
```bash
docker network create jenkins
docker network ls
```
![60](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image26.jpg)

Uruchomienie kontenera z usługą **Docker-in-Docker (DinD)**:
```bash
docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2
```
![61](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image27.jpg)

Utworzenie Dockerfile:
```bash
nano Dockerfile
```
![61](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image28.jpg)

Zawartość pliku Dockerfile:
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
![61](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image29.jpg)

Zbudowanie obrazu **my-jenkins**:
```bash
docker build -t my-jenkins .
```
![62](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image30.jpg)

![63](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image31.jpg)

### 3. Zainicjalizowano instację, wykazano działające kontenery, wyświetloono ekran logowania.
Uruchomienie kontenera **Jenkins** z wtyczką **Blue Ocean**:
```bash
docker run --name jenkins-blueocean --restart=on-failure --detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro --publish 8080:8080 --publish 50000:50000 my-jenkins
```
![64](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image32.jpg)

Wyświetlenie obrazów:
```bash
docker ps
```
![65](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image33.jpg)

Uruchomienie w przeglądarce **localhost:8080**:
![66](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image34.jpg)

Wyświetlenie hasła:
```bash
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
![67](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image35.jpg)

Jenkins po wpisaniu wyświetlonego w terminalu hasła:
![68](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image36.jpg)

Instalacja wtyczek:
![69](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image37.jpg)

Dodawanie nowego użytkownika - stworzenie konta:
![70](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image38.jpg)

Jenkins po zalogowaniu:
![71](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie2/images/image39.jpg)

### 4. Dodano sprawozdanie, zrzuty ekranu oraz listing historii poleceń.

Wykorzystane polecenia: 
```bash
git add .

git commit -m "WB410023 sprawozdanie, screenshoty, listing oraz plików dockerfiles i logs"

git push origin WB410023
```

### 5. Wystawiłam Pull Request do gałęzi grupowej.