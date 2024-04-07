# Sprawozdanie 2

## Dockerfiles, kontener jako definicja etapu

Laboratoria z których niniejsze sprawozdanie się składa obejmowało dwa zasadnicze tematy: Dockerfile oraz woluminy dockera.
Pierwszym z nich natomiast jest Dockerfile oraz użycie kontenera jako definicji etapu tzn. używanie dockera do określonych zadań, a w naszym przypadku: budowania i testowania osobno programu.  

Moim programem wyboru jest [Redis](https://github.com/redis/redis/), czyli nierelacyjna baza danych przechowywująca dane pamięci podręcznej w strukturze *klucz - wartość* w pamięci operacyjnej serwera, działająca jako np. klasyczna baza danych.

Redis jest głównie napisany w języku C, Tcl *(Tool command language)*, pythonie i innych. Program przykuł moją uwagę swoją użytecznością w konteneryzacji i przede wszystkim środowiskiem wykonawczym, które pozwala poprzez Makefile i komendy `makefile` na utworzenie builda (`make build`) oraz testowania środowiska (`make test`).

Redis zapewnia już [obraz programu na docker hubie](https://hub.docker.com/_/redis) i dobrą dokumentację z [instrukcją](https://redis.io/docs/install/install-stack/docker). Wyodrębnienie Redisa od systemu operacyjnego posiada wiele zalet a kluczowymi jest prostota w ustawianiu środowiska, skalowalność i izolacja dzięki której nie ma problemu z dependencjami. Redis jest programem który dobrze działa w kontenerach: traktujemy to jako bazę danych, dlatego wystarczy ustanowić połączenie z kontenerem redisa i poprzez CLI można się połączyć z programem.

## Działanie programu w kontenerze

Początkowo przeszedłem przez cały proces instalacji zależnośći i koniecznych programów by później wszystko móc zwięźle umieść w Dockerfile'u.


Użyte komendy to:
```sh
sudo apt install -y wget make gcc tcl tk
wget https://download.redis.io/redis-stable.tar.gz
tar -xzvf redis-stable.tar.gz
cd redis-stable
```

Rozpoczęcie wykonania komend:
**Zrzut Ekranu 9**

Konsola po zakończeniu rozpakowywania repozytorium.  
**Zrzut ekranu 10**

### Uruchomienie testów jednostkowych dołączonych do repozytorium.
Ja użyłem komendy `make test` która uruchamia testy jednostkowe, lecz zasadniczo komenda ta także powoduje budowanie tego środowiska.

Uruchomienie załączonych testów jednostkowych odbywa się komendą:

```sh
make test MALLOC=libc
```
Rozpoczęcie działania:
**Zrzut Ekranu 11**

Gdy program nie widzi danych potrzebnych dependencji instaluje je automatycznie:  
**Zrzut Ekranu 12**

Przykładowe testy podczas działania:  
**Zrzut Ekranu 5**

Zakończenie działania:  
**Zrzut Ekranu 13**

Po uruchomieniu `make test` jeśli się uruchomi samo `make` program praktycznie jest cały zainstalowany:  
**Zrzut Ekranu 14**

Program zbudował się poprawnie i Wszystkie testy zostały wykonane poprawnie na mojej maszynie wirtualnej. Następnym krokiem jest zrobienie tego samego ale w kontenerze. Podobnie jak w poprzednich laboratoriach, użyję obrazu bazowego fedory i na nim będę opierał dalsze części laboratoriów.

## Przeprowadzenie buildu w kontenerze
Teraz należy zrobić to samo, ale dla przypadku kontenera:

Uruchomienie fedory interaktywnie w kontenerze odbywa się komendą:
```sh
docker run -it fedora bash 
```

Użyte komendy to:
```sh
dnf install -y wget make gcc tcl tcl-devel tk procps which
yum install tcl tcl-devel tk
wget https://download.redis.io/redis-stable.tar.gz
tar -xzvf redis-stable.tar.gz
cd redis-stable
```
Zasadniczo, na początku należy pobrać zależności: `wget` do pobrania repozytorium, `make` w celu zbudowania programu, `gcc` do kompilacji, `tcl`, `tcl-devel`, `tk`, ponieważ program używa tych zależności (`tcl` to język skryptowy), `procps` aby testy poprawnie się wykonały, `which` jest konieczne do tego aby program dobrze rozpoznawał poprawną wersję tcl (powinna być przynajmniej 8.5).

Komenda yum wyłącznie pozwala rozwiązać niektóre błędy (obejście).

Zakończenie aktualizacji bibliotek  
**Zrzut ekranu 1**  
<img src="images/Zrzut ekranu 2024-03-30 162846.png">

Konsola po zakończeniu rozpakowywania repozytorium.  
**Zrzut ekranu 3**  
<img src="images/Zrzut ekranu 2024-03-30 163515.png">

### Uruchomienie testów jednostkowych w kontenerze dołączonych do repozytorium.
Uruchomienie załączonych testów jednostkowych odbywa się komendą:

```sh
make test MALLOC=libc
```

Rozpoczęcie działania:  
**Zrzut Ekranu 4**  
<img src="images/Zrzut ekranu 2024-03-30 164226.png">


Zakończenie testowania:  
**Zrzut Ekranu 6**  
<img src="images/Zrzut ekranu 2024-03-30 164750.png">


Jak widać na ostatnim zrzucie ekranu, wszystkie testy przeszły poprawnie, lecz w moim przypadku była to **rzadkość**. Podejrzewam, że może być to spowodowane działaniem na wirtualnej maszynie i w kontenerze w okrojonej skali, przez co kontener może mieć przydzielone za mało zasobów np. do utrzymania konsekwentnego rozmiaru klustera podczas działania równoległego.  
Jeśli jakieś testy nie przeszły, to na końcu ukazuje się error i informacja o wyjściu i ukończeniu działania. [Jeden ze współtwórców mówi, że tego typu błąd jest celowy](https://github.com/redis/redis/issues/9790) (inny przypadek).

Tak samo na wirtualnej maszynie, najpierw została uruchomiona komenda `make test` a następnie `make`, to wynik jest praktycznie identyczny:

**Zrzut Ekranu 7**  
<img src="images/Zrzut ekranu 2024-03-30 165718.png">


Ostatecznie, dzięki ww. komendom możliwe jest uruchomienie budowania i uruchamiania testów w kontenerze fedory w sposób interaktywny.

Działanie serwera Redisa:

**Zrzut Ekranu 8**
<img src="images/Zrzut ekranu 2024-03-30 170439.png">

## Stworzenie plików Dockerfile do automatyzacji budowania i testowania aplikacji
W tym kroku stworzenie programu ma się odbywać w osobnym Dockerfile, dlatego tym razem wykonam to w domyślnej kolejności.

Wykonując dwa pliki Dockerfile należy mieć na uwadze ich wykluczanie nazw. Możliwa jest [konwencja jak w oficjalnej dokumentacji](https://docs.docker.com/reference/cli/docker/image/build/#file):  
```
Dockerfile.<purpose>
<purpose>.Dockerfile
```
A następnie uruchomienie poprzez:  
```sh
docker build -f dockerfiles/Dockerfile.<purpose> -t nazwa-obrazu 
```
Będę się trzymał dalej tej konwencji.

### Build

Zawartość `Dockerfile.build` przedstawia się następująco:  
```Dockerfile
FROM fedora

RUN dnf install -y wget make gcc tcl tcl-devel tk procps which && \
    wget https://download.redis.io/redis-stable.tar.gz && \
    tar -xzvf redis-stable.tar.gz
    
WORKDIR /redis-stable

RUN make
```

Tworzenie obrazu wykonuje się poprzez `docker build`.  
Sama komenda potrzebuje argumentu gdzie szukać plików Dockerfile, natomiast `-f` nazwy pliku Dockerfile, a `-t` ustawia nazwę nowego obrazu.
```sh
docker build -f INO/GCL1/MJ410315/Sprawozdanie2/dockerfiles/Dockerfile.build -t redis_build .
```
Początek budowania:  
**Zrzut Ekranu 15**  
<img src="images/Zrzut ekranu 2024-03-30 175853.png">

Zakończenie budowania obrazu:  
**Zrzut Ekranu 16**  
<img src="images/Zrzut ekranu 2024-03-30 182052.png">

### Test
Zawartość `Dockerfile.test` przedstawia się następująco:  
```Dockerfile
FROM redis_build

WORKDIR /redis-stable

RUN make test
```
*Note: komenda `RUN make test MALLOC=libc` w tym przypadku zwracała nieoczekiwany błąd, ale `RUN make test` działa poprawnie*

Początek budowania:  
**Zrzut Ekranu 17**  
<img src="images/Zrzut ekranu 2024-03-30 182433.png">

Nie wszystkie testy przechodzą poprawnie, co powoduje, że obraz nie jest w stanie się zbudować:    
**Zrzut Ekranu 18**  
<img src="images/Zrzut ekranu 2024-03-30 185654.png">

Następne uruchomienie komendy powoduje zwrócenie trochę innych testów co każe sądzić, że wynik może być niedeterministyczny (oparty np o architekturę lub eksploatację urządzenia):  
**Zrzut Ekranu 19**
<img src="images/Zrzut ekranu 2024-03-30 190906.png">

[Ta odpowiedź](https://github.com/redis/redis/issues/8265#issuecomment-756764695) sugeruje, że błąd który się pojawia można zignorować, zatem jest to błąd natury niedopatrzenia, lecz sam program będzie działał poprawnie.

Natomiast na poniższym zrzucie ekranu widać że kontener uruchamia się z obrazu `redis_build` poprawnie.  
**Zrzut Ekranu 20**  
<img src="images/Zrzut ekranu 2024-04-01 164346.png">

Niestety, nie jestem w stanie stworzyć obrazu `redis_test` prawdopodobnie ze względu na ograniczenia maszynowe.

Po zbudowaniu kontenerów, nie są one w stanie samodzielnie wykonać żadnych czynności. Dzieje się tak, ponieważ w Dockerfile nie został zdefiniowany polecenie CMD, co oznacza brak automatycznego uruchamiania skryptu po uruchomieniu kontenera.

Należy zwrócić uwagę, że testy nie są uruchamiane podczas startu kontenera (CMD), ale wyłącznie podczas procesu budowania (RUN). 

## Dodatkowa terminologia w konteneryzacji

Druga część sprawozdania polega na użyciu woluminów dockera. W poniższych krokach stworzymy dwa woluminy, jeden na którym będziemy budować program, a drugi na który skopiujemy projekt. Uruchomimy następnie serwer iperf w celu zmierzenia wydajności kontenera pod względem połączenia, a na końcu zainstalujemy Jenkinsa.

## Zachowywanie stanu

Po pierwsze, należało przygotować dwa woluminy: wejściowy i wyjściowy.

Sam wolumin natomiast to to trwała przestrzeń dyskowa, niezależna od cyklu życia kontenera, przeznaczona do przechowywania danych.

Użyte komendy do celu stworzenia:  
```sh
docker volume create input_volume
docker volume create output_volume
```

Sprawdzenie natomiast stworzonych woluminów wykonuje komenda:  
```sh
docker volume ls
```
**Zrzut Ekranu 1**  
<img src="images/Zrzut ekranu 2024-03-25 180116.png">

W poprzednich laboratoriach używałem kontenera fedory jako bazowy. Podczas uruchamiania konteneru z obrazu możemy podłączyć wolumin poprzez flagę *--mount*, natomiast trzeba określić parametry *source* (nazwa woluminu) oraz *target* (lokalizację woluminu) oddzielone przecinkiem.

Ja użyłem komendy:  
```sh
docker run -it --rm --name volume_fedora --mount source=input_volume,target=/in fedora /bin/bash
```

**Zrzut Ekranu 2**
<img src="images/Zrzut ekranu 2024-03-25 182931.png">

Jak widać, po uruchomieniu kontenera wolumin znajduje się w kontenerze w folderze o nazwie "*in*". 

### Uruchomienie kontenera, zainstalowanie wymagań bez **gita**.

Tak jak poprzednio, wymagania należy zainstalować, w moim konkretnym przypadku użyję po prostu komendy:  

```sh
dnf install -y make gcc tcl tcl-devel tk procps which git
```

W pierwszym kroku należało sklonować za pomocą gita w kontenerze, dlatego dodałem go do programów do instalacji. (Sam git został zainstalowany później).

**Zrzut Ekranu 3**
<img src="images/Zrzut ekranu 2024-04-02 132610.png">

Poprzednio, pobierałem kod źródłowy z hostowanego prywatnie przez redisa repozytorium, lecz możliwe jest także pobranie tego przez git: najnowsza stabilna wersja (którą poprzednio także pobrałem) jest **redis 7.2**. Jest możliwe sklonowanie tylko tego brancha z oficjalnego repozytorium z githuba komendą:  

```sh
git clone -b 7.2 https://github.com/redis/redis.git
```

Następnym krokiem w laboratorium jest sklonowanie programu na wolumin wejściowy w kontenerze, czyli przejście do folderu *in* oraz uruchomienie powyższej komendy:  

**Zrzut Ekranu 4**
<img src="images/Zrzut ekranu 2024-04-02 135401.png">

Kolejno, należało uruchomić budowanie programu komendą `make`, ale wcześniej trzeba było uruchomić jeszcze raz kontener, ale z podłączonym drugim - wyjściowym woluminem komendą:  
```sh
docker run -it --rm --name volume_fedora --mount source=input_volume,target=/in --mount source=output_volume,target=/out fedora /bin/bash
```  

Uruchomienie buildu w kontenerze na woluminie:  
**Zrzut Ekranu 5**  
<img src="images/Zrzut ekranu 2024-04-02 135726.png">

Zakończenie budowania na woluminie:  
**Zrzut Ekranu 6**  
<img src="images/Zrzut ekranu 2024-04-02 140039.png">

W poniższy sposób można skopiować repozytorium do wnętrzna kontenera dzięki komendzie:  
```sh
cp -r redis/ ../
```  
**Zrzut Ekranu 7**  
<img src="images/Zrzut ekranu 2024-04-02 141900.png">

Niestety, projekt ten jest skomplikowany i nie jest jasne, gdzie wszystkie zbudowane pliki się znajdują, ale pliki wykonawcze takie jak `redis-server` oraz `redis-cli` znajdują się w folderze `src`, dlatego zapiszę właśnie ten folder w woluminie wyjściowym aby można było mieć dostęp do plików po wyłączeniu kontenera.

```sh
cp -r src ../../out/
```

**Zrzut Ekranu 8**  
<img src="images/Zrzut ekranu 2024-04-02 142506.png">

Zapisane pliki w woluminach:  

**Zrzut Ekranu 9**  
<img src="images/Zrzut ekranu 2024-04-02 142709.png">

Ponowienie operacji klonowania na wolumin wejściowy ale z kontenera jest bardzo proste, różni się jedynie folderem do którego należy zapisać sklonowane repozytorium, ja zapiszę do nowego folderu `new_redis`:  

```sh
git clone -b 7.2 https://github.com/redis/redis.git /in/new_redis
```

**Zrzut Ekranu 10**  
<img src="images/Zrzut ekranu 2024-04-02 144303.png">

### Sprawdzenie wykonania powyższych kroków za pomocą pliku Dockerfile

Niestety moja próba nie okazała się skuteczna w podłączeniu wolumina przez Dockerfile. Poniższa treść pliku oraz użyta komenda:  

```dockerfile
From fedora

RUN mkdir in
RUN mkdir out

RUN --mount=type=bind,source=var/snap/docker/common/var-lib-docker/volumes/input_volume/_data,target=/in \
    --mount=type=bind,source=var/snap/docker/common/var-lib-docker/volumes/output_volume/_data,target=/out,rw

WORKDIR /in

RUN dnf install -y make gcc tcl tcl-devel tk procps which git
RUN git clone -b 7.2 https://github.com/redis/redis.git ./dockerfile_redis

WORKDIR /in/dockerfile_redis

RUN git make

RUN cp -r src ../../out/dockerfile_src
```

Poniżej do uruchomienia użyłem komendy:

```sh
sudo docker build -f /home/michaljurzak/repo/MDO2024_INO/INO/GCL1/MJ410315/Sprawozdanie2/dockerfiles/Dockerfile.volume -t vol_fedora .
```

Potwierdzenie istnienia błędu:  
**Zrzut Ekranu 11**  

[Ta odpowiedź](https://stackoverflow.com/a/26053710/21148299) sugeruje, że nie jest możliwe podłączenie woluminu, a możliwe jest to jedynie przez linię komend, poniważ ograniczałoby to przenośność oprogramowania.

W powyższej treści dockerfile umieściłem folder który miałby być bindowany, ale użycie jako źródła nazwy woluminu (`input_volume`, `output_volume`) również kończyło się niepowodzeniem sugerując nieznalezienie folderu.

## Eksponowanie portu

Kolejnym zadaniem było pobranie i uruchomienie serwera **iperf**, które jest narzędziem pomiaru wydajności łącza wraz z jego analizą 

W kontenerze fedory (którą wybrałem) pobiera się za pomocą:  

```sh
dnf install iperf3
```
Następnie, uruchamia się serwer komendą:  
```sh
iperf3 -s
```
**Zrzut Ekranu 13**
<img src="images/Zrzut ekranu 2024-04-02 164241.png">

W celu sprawdzenia adresu serwera użyłem komendy:  

```sh
docker inspect -f'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <id_konteneru>
```
  
**Zrzut Ekranu 12**  
<img src="images/Zrzut ekranu 2024-04-02 164128.png">

Z drugiego kontenera można się połączyć jako klient z serwerem poprzez komendę:
```sh
iperf3 -c <ip_serwera>
```

Po wpisaniu komendy otrzymujemy (po lewej stronie klient, po prawej serwer), natępujący komunikat:  

**Zrzut Ekranu 14**
<img src="images/Zrzut ekranu 2024-04-02 164842.png">

Iperf testuje szybkość między kontenerami, w moim przypadku prękość ta to średnio 15.7 Gb/s.  

Do tworzenia nowych sieci w Dockerze służy olecenie `docker network create`. Domyślnie tworzy ona sieć mostkową, co oznacza, że kontenery podłączone do tej samej sieci będą mogły komunikować się ze sobą, ale nie będą widoczne z zewnątrz.

Stworzenie nowej sieci odbywa się:  

```sh
docker network create ntwrk
```

Teraz dzięki stworzonej sieci można podłączyć dwa kontenery które się będą komunikować w sieci dzięki nazwie przez korzystanie z DNS. Tworzenie wygląda następująco:  

```sh
docker run -it --name iperf3_server --network ntwrk fedora_updated bash
docker run -it --name iperf3_client --network ntwrk fedora_updated bash
```

Po uruchomieniu obu kontenerów uruchamiam serwer, sprawdzam adres sieci (`docker network ls`) i można sprawdzić adresy dołączonych kontenerów komendą  
```sh
docker network inspect <id_sieci>
```

**Zrzut Ekranu 15**  
<img src="images/Zrzut ekranu 2024-04-02 170230.png">

### Połączenie Z wirtualnej maszyny (z hosta)

Docker tworzy swoją sieć, przez co różni się od wirtualnej maszyny. Należy się teraz połączyć z niej (w moim przypadku to jest ubuntu) i wykonujemy to jako klient do działającego serwera w kontenerze. Nasłuchiwany port to `5201`. Należy uruchomić jeszcze raz kontener jako serwer ale z innymi opcjami, gdzie eksponujemy port.  

```sh
docker run -it --network ntwrk --name iperf3_server -p 5201:5201 fedora_updated bash
```

Następnie podobnie jak poprzednio, traktując VM jako klienta łączę się przez:  
```sh
iperf3 -c 172.19.0.2
```

**Zrzut Ekranu 16**  
<img src="images/Zrzut ekranu 2024-04-02 174045.png">

Już na pierwszy rzut oka widać, że prędkość jest większa. Może to być spowodowane mniejszą ilością warstw przez które informacja musi przebiec, co sprawia mniejszą latencję.

W tym też punkcie użyłem flagi `--logfile f` w celu uzyskania pliku log. Zapisał się on na kliencie, na woluminie natomiast nie, a jego treść jest jak poniżej:

```log
Connecting to host 172.19.0.2, port 5201
[  6] local 172.19.0.1 port 34620 connected to 172.19.0.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  6]   0.00-1.00   sec  2.10 GBytes  18.0 Gbits/sec    0   2.53 MBytes       
[  6]   1.00-2.00   sec  2.09 GBytes  18.0 Gbits/sec    1   2.80 MBytes       
[  6]   2.00-3.00   sec  2.45 GBytes  21.1 Gbits/sec    0   2.80 MBytes       
[  6]   3.00-4.00   sec  2.27 GBytes  19.5 Gbits/sec    0   2.81 MBytes       
[  6]   4.00-5.00   sec  2.51 GBytes  21.6 Gbits/sec    0   2.82 MBytes       
[  6]   5.00-6.00   sec  2.05 GBytes  17.6 Gbits/sec    0   2.84 MBytes       
[  6]   6.00-7.00   sec  2.23 GBytes  19.1 Gbits/sec    1   2.87 MBytes       
[  6]   7.00-8.00   sec  2.31 GBytes  19.9 Gbits/sec    0   2.92 MBytes       
[  6]   8.00-9.00   sec  2.55 GBytes  21.9 Gbits/sec    0   2.94 MBytes       
[  6]   9.00-10.00  sec  2.56 GBytes  22.0 Gbits/sec    0   2.99 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  6]   0.00-10.00  sec  23.1 GBytes  19.9 Gbits/sec    2             sender
[  6]   0.00-10.00  sec  23.1 GBytes  19.9 Gbits/sec                  receiver

iperf Done.
```

### Połączenie spoza wirtualnej maszyny (spoza hosta)

Mając pobrany WSL (*Windows Subsystem for Linux*) uznałem, że będzie najprościej użyć tego narzędzia, lecz było to błędne myślenie. Mimo, że prawidłowe porty zostały eksponowane, nie byłem w stanie się połączyć z maszyną wirtualną w żaden sposób. Pobrałem więc iperf3 na Windowsa i nie bez problemów udało mi się ostatecznie nawiązać połączenie. Ostatecznie, być może reset maszyny wirtualnej pomógł, ale nie jestem do końca pewien czy jest to pomocne w każdym przypadku.  

**Zrzut Ekranu 23**
<img src="images/Zrzut ekranu 2024-04-02 214754.png">

## Instalacja Jenkins

Instalację Jenkinsa zaczynamy poprzez stworzenie sieci mostkowej Jenkins:  

```sh
docker network create jenkins
```

**Zrzut Ekranu 17**  
<img src="images/Zrzut ekranu 2024-04-02 210832.png">

Następnie należy pobrać obraz dockera poprzez uruchomienie konteneru z opcjami zawartymi w [instrukcji](https://www.jenkins.io/doc/book/installing/docker/):  

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

### Inicjalizacja instacji

Aby utworzyć customowy obraz jenkinsa wystarczy uruchomić załączony w instrukcji plik Dockerfile:  

```dockerfile
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

Zbudowanie obrazu polega na uruchomieniu instrukcji z utworzonym Dockerfilem:  

```
docker build -t myjenkins-blueocean:2.440.2-1 -f ./INO/GCL1/MJ410315/Sprawozdanie2/dockerfiles/Dockerfile.jenkins .
```

Ponownie, korzystając z oficjalnej instrukcji można uruchumić kontener z obrazu dzięki komendzie:  

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

Poniżej na zrzucie ekranu widać że kontener z Jenkinsem działa poprawnie:  
**Zrzut Ekranu 18**  
<img src="images/Zrzut ekranu 2024-04-02 212620.png">

Aby uruchomić ekran logowania do Jenkinsa należy dodać przekierowanie portów w sieci NAT z której korzysta VirtualBox. Na początku konieczny jest adres IP:

```sh
ip addr
```

Ukazuje się wiele pozycji, ale istotna jest druga: publiczny adres. Dla mnie wynosi on `10.0.2.15`.

**Zrzut Ekranu 19**  
<img src="images/Zrzut ekranu 2024-04-02 212939.png">

W kliencie VirtualBoxa należy wejść w Ustawienia->Sieć->Zaawansowane->Przekierowania Portów->

**Zrzut Ekranu 20**  
<img src="images/Zrzut ekranu 2024-04-02 213143.png">

Jenkins domyślnie korzysta z portu 8080, zatem taki ustawiłem. Aby otworzyć panel logowania należy w przeglądarce wpisać `localhost:8080` a następnie ukaże się widok jak na poniższym zrzucie ekranu:  

**Zrzut Ekranu 21**  
<img src="images/Zrzut ekranu 2024-04-02 213759.png">

Na ekranie po wpisaniu w maszynie wirtualnej komendy:  

```sh
sudo docker exec 5846ded81d6f cat /var/jenkins_home/secrets/initialAdminPassword
```
Ukazuje się następujący ekran:

**Zrzut Ekranu 22**
<img src="images/Zrzut ekranu 2024-04-02 214207.png">

*Note*: Zrzuty ekranu są numerowane według kolejności w folderze
