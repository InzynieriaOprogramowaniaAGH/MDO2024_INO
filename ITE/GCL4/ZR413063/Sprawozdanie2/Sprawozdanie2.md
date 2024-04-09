# Sprawozdanie 2

Laboratorium dotyczyło dalszej pracy z Dockerem. Jego celem było nabycie umiejętności przeprowadzenie builda projektu oraz testów z udziałem konetenrów na dwa sposoby: w kontenerze i automatyzując wszystko za pomocą Dockerfile.

# 1. 1. Wybór repozytorium

Pierwszym krokiem było wybranie odpowiedniego repozytorium. Wybrałam to:
```
https://github.com/mogemimi/pomdog.git
```

Przedewszystkim posiada otwartą licencję MIT License, która umożliwia użytkownikom dowolną modyfikację, kopiowanie a nawet sprzedaż oprogramowania. W celu wykonania instrukcji upewniłam się, że powyższe repo da się zbudować. To konkretne korzysta z cmake oraz posiada testy.

Wybrane przeze mnie repozytorium to otwarte żródło silnika gier dla C++20.

# 1. 2. Build programu

Najpierw przeprowadziłam standardowy build programu. 
Doinstalowałam dodatkowe zależności, które są wymagane przez repozytorium :
- cmake 
```
sudo apt-get install cmake
```
- Ninja - program do budowania
```
sudo apt-get install ninja-build
```
- Clang - kompilator dla języków C i C++
```
sudo apt-get install clang
```

Doinstalowałm również wszystkie dodatkowe biblioteki:
```
apt-get install -y wget gnupg  libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/c37501bf-add2-4be0-be2a-7f5463095693)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/a230b4e0-be25-4640-8184-6fd3f406fdd2)




Skopiowałam repozytorium na moją maszynę wirtualną:
```
git clone git@github.com:mogemimi/pomdog.git
```
 następnie przeszłam do katalogu projektu:
 ```
 cd pomdog/
 ```

 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/12c78fab-05b6-4dfd-aa1e-c51c5b6b4659)

 
Zgodnie z plikami README zaczęłam budować projekt.
Sprawdziłam dołączone sub-moduły i je zaktualizowałam :
```
git submodule update --init --recursive
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/b4b507b3-5576-4427-89ac-5388831c3bcd)

Następnie wygenerowałam pliki Ninja do zbudowania projektu. Komenda tworzy katalog build/linux w którym będą generowane pliki builda. Opcja -H. ustawia bieżący katalog (/pomdog) jako katalog źródłowy z którego CMake będzie czytał pliki. Opcja -G Ninja mówi CMake, że pliki builda mają zostać wygenerowane w systemie Ninja.
```
cmake -Bbuild/linux -H. -G Ninja
```
Kolejnym krokiem było przejście do wygenerowanego katalogu build/linux i w nim uruchomienie polecenia, które zbudowało projekt.
```
ninja
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/ea9bd384-6082-428b-9a15-378060fec49c)


Po pomyślnym zbudowaniu programu uruchomiłam załączone testy. W katalogu build/linux uruchomiłam testy jednostkowe projektu 
```
./test/pomdog_test
```
Wszystkie zakończyły się sukcesem.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/629ec283-f697-4c9b-8048-531edcc33dac)


# 1. 3. Build w kontenerze

Do przeprowadzenia builda w kontenerze musiałam najpierw ściągnąć obraz ubuntu, który w przypadku tego projektu był wystarczający. Następnie uruchomiłam kontener w trybie interaktywnym:
```
docker run --name pom -it ubuntu bash
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/ded896e3-5b9c-47c5-8dc7-a04295a96a5f)

Tak jak w punkcie wyżej, musiałam zaoptarzyć swój kontener w wymagania wstępne dla projektu z wybranego repozytorium. Jedną komendą zainstalowałam wszystkie potrzebne biblioteki, programy i zależności:
```
apt-get update
apt-get upgrade -y
apt-get install -y wget gnupg git ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev
```
Następnie sklonowałam repozytorium w kontenerze:

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/2fa3522d-8fa4-4b2e-bf18-53793e42084c)


Przeprowadzenie builda programu i testów jednostkowych zrobiłam analogicznie tak jak wcześniej na maszynie.
Sprawdziłam submoduły

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/72c47345-4be9-4a19-867a-60bf27fec755)


Przeszłam do przeprowadzenia builda w kontenerze:

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/dfcd4759-c11d-44d4-bb08-ff8f1845aaa6)


Następnie do testów:

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/32f0eac1-4f5f-4a72-8b2c-e7cf12046268)


# 1. 4. Dockerfile dla builda i testów

Przeszłam do tworzenia Dockerfile.

Pierwszy Dockerfile miał wykonywać wszystkie kroki: od stworzenia obrazu aż po końcowy build. Dockerfile będzie odzwierciedleniem i zebraniem wszystkich kroków które wykonywałam przy poprzednich podpunktach instrukcji.

Po napisaniu pierwszego Dockerfile przeszłam do zbudowania obrazu pierwszego kontenera:
```
docker build -f Dockerfile.build -t pomdog_build .
```

Treść Dockerfile do budowania:
```
FROM ubuntu:latest

#pobranie wszystkich wstepnych zaleznonsci
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget gnupg git ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev clang

#klonowanie repozytorium
RUN git clone https://github.com/mogemimi/pomdog.git

#ustaweinie katalogu roboczego
Workdir /pomdog

#aktualizacja submodulow
RUN git submodule update --init --recursive

#generowanie plikow ninja
RUN cmake -Bbuild/linux -H. -G Ninja

#przejscie do katalogu builda i zbudowanie programu
RUN cd build/linux && ninja
```

Napisałam kolejny Dockerfile, tym razem dla kontenera z testami, bazującego na kontenerze z buildem. 
```
#nazwa obrazu pierwszego kontenera 
FROM pomdog_build:latest

#ustawienie katalogu roboczego
WORKDIR /pomdog/build/linux

#wskazanie ktora komenda ma zostac wywolana po uruchomieniu kontenera
CMD ["./test/pomdog_test"]
```


Zbudowałam kontener:
```
docker build -f Dockerfile.test -t pomdog_test .
```
a następnie go uruchomiłam:
```
docker run -it pomdog_test
```

# 1. 5. Działanie kontenera

By wykazać działanie kontenerów uruchomiłabym kontener z testem:
```
docker run -it --rm pomdog_test
```
Najprawdopodobniej ze względów problemu z pamięcią maszyny wirtualnej nie mogłam zbudować projektu.

# 1. 6. Docker Compose

Aplikacje bazujące na jednym kontenerze są raczej rzadkością. Bardzo często konteneryzuje się duże aplikacje i używa się do tego przynajmniej kilku kontenerów. By jednak nie musieć wdrażać każdego po kolej istanieje Docker Compose. Jest to narzędzie umożliwiające zarządzanie aplikacjami wielokontenerowymi. Wszstkie kontenery aplikacji ujmuje się za pomocą jednego pliku YAML.

Posiadając dwa kontenery dla projektu z repozytorium mogę stworzyć plik YAML by móc za jego pomocą zdefiniować obie usługi:  build i test. Mój plik YAML mógłby wyglądać tak:
```
version: '3'
services:
build:
build: 
context: .
dockerfile: Dockerfile.build
volumes:
- .:/app
test:
build:
context: .
dockerfile: Dockerfile.test
volumes:
- .:/app
```

# 2. 1. Woluminy

Woluminy to mechanizm pozwalający przechowywać dane generowane i używane przez kontenery. Używane są do bezpiecznego przechowywania danych (nawet tych wrażliwych), współdzielenia ich między kontenerami. Ułatwiają równineż przenoszenia danych między maszynami. Są trwałe gdyż nie zostają usunięte po zatrzymaniu/usunięciu kontenera. 

Zaczęłam od stworzenia dwóch woluminówy: wejściowego i wyjściowego:
```
docker volume create wejsciowy
```
```
docker volume create wyjsciowy
```

Można sprawdzić stworzone woluminy za pomocą:
```
docker volume ls
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cc06fc18-15d0-4d6e-86e5-09ab915cbfd3)


Następnie oba woluminy podłączyłam do kontenera bazowego, którym w tym przypadku był ubuntu, oraz go uruchomiłam:
```
docker run -v wejsciowy:/input -v wyjsciowy:/output -it ubuntu bash
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/79975480-6423-40ba-99fe-80bc797c3320)


Korzystam z tego samego repozytorium co przy wykonywaniu zadań z instrukcji 3 więc na kontener instaluje te same zależności wstępne oprócz gita.
```
apt-get update && apt-get upgrade -y && apt-get install -y wget gnupg ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev clang
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/bf403265-ccd1-4638-b5ba-9dc0e6f38b09)


# 2. 2. Klonowanie repozytorium bez gita

Klonowanie repozytorium bez gita rozpoczęłam od zainstalowania w kontenerze dodatkowych programów, które umożliwją mi realizację tego zadania.
```
apt-get install -y wget unzip
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/4295c8bc-a874-4c72-b929-c6f3a1b64a35)


Postanowiłam pobrać repozytorium jako plik zip dzięki wget. Github oferuje możliwość pobrania repozytorium jako pliku zip dzięki specjelnemu adresowi URL, który pobiera główną gałąź main danego repozytorium jako paczkę z rozszerzeniem .zip .
```
wget https://github.com/mogemimi/pomdog/archive/refs/heads/main.zip
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/7848fd54-eb1d-45a5-96c2-92e36240d0d5)


Dzięki podpiętemu woluminowi wejściowemu do katalogu input w kontenerze mogę rozpakować tam moje repozytorium. Użyję do tego programu zip i komendy unzip:
```
unzip main.zip -d /input
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/0bdc92dc-5467-4c3a-bed2-38297ec1f710)


Wykonując polecenie:
```
ls /input
```
można sprawdzić, że faktycznie rozpakowane repozytorium już czeka w folderze do którego został podpięty wejściowy wolumin.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/9a6ee85a-7aa1-4529-9cca-f2c02fc8a939)


Tutaj miał pojawić się build projektu. Niestety projekt który wczesniej wybrałam używa submodułów git i nie jestem w stanie go zbudować w ten sposób.



# 2. 3. Klonowanie repozytorium na wolumin z użyciem gita wewnątrz konetenera

Ponownie stworzyłam kontener, podpięłam do niego dwa woluminy: wejsciowy2 i wyjsciowy i zainstalowałam dodatkowe zależności:
```
docker run -it --name pomdog4 -v wejsciowy2:/input -v wyjsciowy:/output ubuntu bash
```

```
apt-get update && apt-get upgrade -y && apt-get install -y wget gnupg ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev clang git
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/a062e15a-4396-43ba-b009-da317396a75c)


Następnie sklonowałam repozytorium na wolumin wejsciowy2, który mam podpięty do katalogu input:
```
git clone https://github.com/mogemimi/pomdog.git /input
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/2d88b998-5176-443f-a085-6292e98a690a)

Próbowałam uruchomić builda tak jak to robiłam wcześniej. Niestety, najprawdopodobnie ze względu na problemy z katalogiem komendę generującą musiałam nieco zmodyfikować kierując na katalog /input
```
cmake -Bbuild/linux -H/input -G Ninja
```
Niestety ponownie wyskoczył błąd z którym nie wiedziałam jak sobie poradzić, podejrzewam że może mieć to związek z brakiem pamięci do przechowywania plików. Postanowiłam więc katalog builda spróbować skopiować na wolumin wyjściowy by zobaczyć czy zostanie on w pamięci woluminu po zamknięciu kontenera: 
```
cp -r build/linux /output/
```
Rekursywnie kopiuje katalog build/linux do katalogu output. Robię to przebywając w katalogu głównym projektu pomdog/

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/0a3e4b56-6c42-47d0-ba6c-90bd43688b8f)



By wykazać dostępność skopiowanych plików na woluminie wyjściowy zamknęłam kontener używając 
```
exit
```
A następnie uruchomiłam nowy kontener Docker z woluminem wyjsciowym
```
docker run -it --rm -v wyjsciowy:/output ubuntu bash
```
i wykazałam zawartość katalogu /output:
```
ls /output
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/879179a9-c948-4189-a19e-cdb8340c054d)



Wszystkie dotychczasowe problemy wynikły najpewniej z braku pamięci na dysku. Niestety projekt waży sporo gdyż samo usunięcie jednego kontenera dało mi 3,2 gb dodatkowej pamięci. Sprawdziłam to dzięki poleceniu:
```
df -h
```
By móc nadal korzystać z dotychczasowej maszyny wirtualnej muszę wyczyściś ją z niepotrzebnych plików, obrazów, kontenerów oraz bibliotek i zależności które nagromadziły się w pamięci przez różne próby i testowanie repozytoriów.

# 2. 4. Dockerfile i run --mount

Uważam że jak najbardziej wszytskie dotychczasowe kroki dałoby się skompresować do jedngo pliku Dockerfile i uruchomienia odpowiedniego polecenia. Byłoby to znacznie szybsze i bardziej sensowne rozwiązanie. Znacznie łatwiej w przypadku wystąpienia problemów jest edytować Dockerfile niż wracać w pamięci do wcześniej wykonywanych kroków.

Run --mount miałby w tym przyoadku całkiem duże zastosowanie. Opcja --mount w poleceniu RUN w Dockerfile montuje katalogi podczs budowania obrazu. Korzysta w wtedy z pamięci zewnętrznej przez co proces budowy przebiega znacznie szybciej.

W tym przypadku opcja run --mount znalazłaby zastosowanie w kopiowaniu repozytorium do kontenera oraz kopiowania plików wyjściowyh do woluminu wyjściowego.

# 2. 5. Serwer iperf wewnątrz kontenera

Iperf jest narzędziem stosowanym do pomiaru strojenia sieci. Generuje ustandaryzowane pomiary wydajności dla dowolnie wybranej sieci. Może też służyć do tworzenia strumienia danych do pomiaru przepustowowści między dwoma końcami klienta i serwera. Serwer iperf jest częścią tego narzędzia i umożliwia nasłuchiwanie połączenia od klienta iperf.

By móc uruchomić wewnątrz kontenera serwer iperf można użyć obrazu mlabbe/iperf3
```
sudo docker run --name=iperf3-server -d --restart=unless-stopped -p 5201:5201/tcp -p 5201:5201/udp mlabbe/iperf3
```
Polecenie uruchomi kotener o nazwie iperf3-server z obrazu mlabbe/iperf3. Będzie działał jako serwej iperf nasłuchując na porcie 5201 dla protokołów TCP i UDP.

By zbadać ruch muszę połączyć do stworzonego kontenera za pomocą nowego kontenera. Do tego będzi mi potrzebny adres IP serwera iperf który uzyskam za pomocą komendy:
```
sudo docker inspect --format "{{ .NetworkSettings.IPAddress }}" iperf3-server
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/c88b398e-8d94-4cca-907a-4564a958a6db)


Mając adres ip serwera uruchomiłam kolejny kontener - klienta, którego połączę z serwerem  by przetestować przepustowość sieci. Uruchomie go z obrazu networkstatic/iperf3.
```
sudo docker run -it --rm networkstatic/iperf3 -c 172.17.0.2
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/999ec128-a375-49ed-9fb3-2b669f78f2ae)


# 2. 6. Dedykowana sieć mostkowa

Można korzystać z gotowych sieci mostkowych jednak stworzenie jej samemu jest znacznie bardziej korzystna. Dedykowane sieci mostkowe zapewniają lepszą izolację, większą elastyczność oraz swobodę ich konfiguracji.

By stworzyć własną sieć mostkową użyłam polecenia:
```
docker network create -d bridge moja_siec
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/b827fed5-f0c4-4390-bafb-5aed824c1bb1)


Jeśli kontenery podłączone są do tej samej sieci zamiast odwoływać się do nich za pomocą aresów IP możem skorzystać z ich nazw. Należy uruchomić wtedy konener z opcją --net wskazując na sieć do której chcemy się podłączyć.
```
docker run --net=moja_siec --name=iperf3-server5 mlabbe/iperf3 -s
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/99b6f165-72b1-462b-b6a2-0570a89181e0)


By połączy się spoza kontenera są dwie opcje:
- z hosta
- spoza hosta

Połączenie się z kontenerem z hosta wymaga użycia polecenia 
```
docker exec -it iperf3-server /bin/sh
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/83ee779b-118b-485f-a6a8-453c655fd59a)



Połączenie się z kontenerem spoza hosta wymaga opublikowania portów kontenera na hoście za pomocą opcji -p podczas uruchamiania kontenera
```
docker run -p 5202:5201 --name=iperf4-server mlabbe/iperf3 -s
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/a6bd3c94-3ecf-4918-9127-a4a68017ec26)


Pobranie logów z kokntenera jest bardzo prsote wystarczy za pomocą odpowiedniej komendy pobrać logi z kontenera o danej nazzwie:
```
docker logs iperf3-server5
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/f13ea38a-8d1c-4e0e-9fb3-5650dc7b1d06)



# 2. 7. Jenkins

Instalację Jenkinsa musiałam odpuścić ze względu na problemy z pamięcią maszyny wirtualnej. By móc zacząć pracę z pipline najpewniej będę musiałam albo wyczyścić obecną maszynę wirtualną albo stworzyć nową. Proces instalacji Jenkinsa zostanie przeze mnie wstawiony w kolejnym sprawozdaniu.
