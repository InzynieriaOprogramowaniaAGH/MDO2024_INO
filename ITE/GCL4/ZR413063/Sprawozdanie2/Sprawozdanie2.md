Sprawozdanie 2

Laboratorium dotyczyło dalszej pracy z Dockerem. Jego celem było nabycie umiejętności przeprowadzenie builda projektu praz testów z udziałem konetenrów na dwa sposoby: w kontenerze i automatyzując wszystko za pomocą Dockerfile.

1. 1. Wybór repozytorium

Pierwszym krokiem było wybranie odpowiedniego repozytorium. Wybrałam to:
```
https://github.com/mogemimi/pomdog.git
```

Przedewszystkim posiada otwartą licencję MIT License, która umożliwia użytkowniką dowolną modyfikację, kopiowanie a nawet sprzedaż oprogramowania. W celu wykonania instrukcji upewniłam się, że powyższe repo da się zbudować. To konkretne korzysta z cmake oraz posiada testy.

Wybrane przeze mnie repozytorium to otwarte żródło silnika gier dla C++20.

1. 2. Build programu

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

# screen 1



Skopiowałam repozytorium na moją maszynę wirtualną:
```
git clone
```
 następnie przeszłam do katalogu projektu:
 ```
 cd 
 ```

 # screen 2
 
Zgodnie z plikami README zaczęłam budować projekt.
Sprawdziłam dołączone sub-moduły i je zaktualizowałam :
```
git submodule update --init --recursive
```
# screen 3
Następnie wygenerowałam pliki Ninja do zbudowania projektu. Komenda tworzy katalog build/linux w którym będą generowane pliki builda. Opcja -H. ustawia bieżący katalog (/pomdog) jako katalog źródłowy z którego CMake będzie czytał pliki. Opcja -G Ninja mówi CMake, że pliki builda mają zostać wygenerowane w systemie Ninja.
```
cmake -Bbuild/linux -H. -G Ninja
```
Kolejnym krokiem było przejście do wygenerowanego katalogu build/linux iw nim uruchomienie polecenia 
```
ninja
```
które zbudowało projekt.

# screen 3.5

Po pomyślnym zbudowaniu programu uruchomiłam załączone testy. W katalogu build/linux uruchomiłam testy jednostkowe projektu 
```
./test/pomdog_test
```
Wszystkie zakończyły się sukcesem.
# screen 4

1. 3. Build w kontenerze

Do przeprowadzenia builda w kontenerze musiałam najpierw ściągnąć obraz ubuntu, który w przypadku tego projektu był wystarczający. Następnie uruchomiłam kontener i podłączyłam do niego TTY by móc rozpocząć interaktywną pracę z nim:
```
docker run --name pom -it ubuntu bash
```
# screen 5


Tak jak w punkcie wyżej, musiałam zaoptarzyć swój kontener w wymagania wstępne dla projektu z wybranego repozytorium. Jedą komendą zainstalowałam wszystkie potrzebne biblioteki, programy i zależności:
```
apt-get update
apt-get upgrade -y
apt-get install -y wget gnupg git ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev
```
Następnie sklonowałam repozytorium w kontenerze:

# screen 6 

Przeprowadzenie builda programu i testów jednostkowych zrobiłam analogicznie tak jak wcześniej na maszynie.
Sprawdziłam submoduły

# screen 7

Przeszłam do przeprowadzenia builda w kontenerze:

# screen 8

Następnie do testów:

# screen 9

1. 4. Dockerfile dla builda i testów

Przeszłam do tworzenia Dockerfile.

Pierwszy Dockerfile miał wykonywać wszystkie kroki: od stworzenia obrazu aż po końcowy build. Dockerfile będzie odzwierciedleniem i zebraniem wszystkich kroków które wykonywałam przy poprzednich krokach instrukcji.

Po napisaniu pierwszego Dockerfile przeszłam do zbudowania obrazu pierwszego kontenera:
```
docker build -f Dockerfile.build -t pomdog_build .
```

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

#przejscie do katalogu bilda i zbudowanie programu
RUN cd build/linux && ninja
```

Napisałam kolejny Dockerfile, tym razem dla kontenera z testami, bazującego na kontenerze z buildem. 
```
#nalezy wpisac nazwe obrazu pierwszego kontenera 
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

1. 5. Działanie kontenera
By wykazać działanie kontenerów uruchomiłam kontener z testem:
```
docker run -it --rm pomdog_test
```
Jak widać wszytko działa prawidłowo.

1. 6. Docker Compose

Aplikacje bazujące na jednym kontenerze są raczej rzadkością. Bardzo często konteneryzuje się duże aplikacje i używa się do tego przynajmniej kilku kontenerów. By jednak nie musieć wdrażać każdego po kolej istanieje Docker Compose. Jest to narzędzie umożliwiające zarządzanie aplikacjami wielokontenerowymi. Wszstkie kontenery aplikacji uj uje się za pomocą jednego pliku YAML.

Posiadając dwa kontenery dla projektu z repozytorium mogę stworzyć plik YAML by móc za jego pomocą zdefiniować obie usługi:  build i test.

2. 1. Woluminy

Woluminy to mechanizm pozwalający przechowywać dane generowane i używane przez kontenery. Używane są do bezpiecznego przechowywania danych (nawet tych wrażliwych), współdzielenia ich między kontenerami. Ułatwiją równineż przenoszenia danych między maszynami. Są równiez trwałe gdyż nie zostają usunięte po zatrzymaniu/usunięciu kontenera. 

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

# screen 2.1

Następnie oba woluminy podłączyłam do kontenera bazowego, którym w tym przypadku był ubuntu oraz go uruchomiłam:
```
docker run -v wejsciowy:/input -v wyjsciowy:/output -it ubuntu bash
```

# screen 2.2

Korzystam z tego samego repozytorium co przy wykonywaniu zadań z instrukcji więc na kontener instaluje te same zależności wstępne oprócz gita.
```
apt-get update && apt-get upgrade -y && apt-get install -y wget gnupg ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev clang
```

# screen 2.3

2. 2. Klonowanie repozytorium bez gita

Klonowanie repozytorium bez gita rozpoczęłam od zainstalowania w kontenerze dodatkowych programów, które umożliwią mi realizację tego zadania.
```
apt-get install -y wget unzip
```
# screen 2.4

Postanowiłam pobrać repozytorium jako plik zip dzięki wget. Github oferuje możliwość pobrania repozytorium jako pliku zip dzięki specjelnemu adresowi URL, który pobiera główną gałąź main danego repozytorium jako paczkę z rozszerzeniem .zip .
```
wget https://github.com/mogemimi/pomdog/archive/refs/heads/main.zip
```

# screen 2.5

Dzięki podpiętemu woluminowi wejsciowemu do katalogu input w kontenerze mogę rozpakować tam moje repozytorium. Użyję do tego programu zip i komendy unzip:
```
unzip main.zip -d /input
```

# screen 2.6

Wykonując polecenie
```
ls /input
```
można sprawdzić, że faktycznie rozpakowane repozytorium już czeka w folderze do które został podpięty wejściowy wolumin.

# screen 2.7

Tutaj miał pojawić się build projektu. Niestety projekt który wczesniej wybrałam uzywa submodułów git i nie jestem w stanie go zbudować w ten sposób.
Wykażę działanie kontenera i woluminów w kolejnym podpunkcie instrukcji.



2. 3. Klonowanie repozytorium na wolumin z użyciem gita wewnątrz konetenera

Ponownie stworzyłam kontener, podepiełam do niego dwa woluminy: wejsciowy2 i wyjsciowy i zainstalowałam dodatkowe zależności:
```
docker run -it --name pomdog4 -v wejsciowy2:/input -v wyjsciowy:/output ubuntu bash
```

```
apt-get update && apt-get upgrade -y && apt-get install -y wget gnupg ninja-build cmake libc++-dev libc++abi-dev mesa-common-dev libglu1-mesa-dev freeglut3-dev libopenal1 libopenal-dev clang git
```

# screen 2.8

Następnie sklonowałam repozytorium na wolumin wejsciowy2, który mam podpięty do katalogu input:
```
git clone https://github.com/mogemimi/pomdog.git /input
```
# screen 2.9
i uruchomiłam builda tak jak robiłam to już wyżej.

Ze względu na problemy z katalogiem komendę generującą musiałam nieco zmodyfikować kierując na katalog /input
```
cmake -Bbuild/linux -H/input -G Ninja
```
Niestety ponownie wyskoczył błąd z którym nie wiedziałam jak sobie poradzić, podejrzewam że może mieć to związek z brakiem pamięci do przechowywania plików. Postanowiłam więc katalog builda spróbować skopiować na wolumin wyjściowy by zobaczyć czy zostanie on w pamięci woluminy po zamknięciu kontenera: 
```
cp -r build/linux /output/
```
Rekursywnie kopiuje katalog build/linux do katalogu output. Robię to przebywając w katalogu głównym projektu pomdog/

# screen 2. 10


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
# screen 2. 11


Wszystkie dotychczasowe problemy wynikły najpewniej z braku pamięci na dysku. Niestety projekt waży sporo gdyż samo usunięcie jednego kontenera dało mi 3,2 gb dodatkowej pamięci. Sprawdziłam to dzięki poleceniu:
```
df -h
```
By móc nadal korzystać z dotychczasowej maszyny wirtualnej muszę wyczyściś ją z niepotrzebnych plików, obrazów, kontenerów oraz bibliotek i zależności które nagromadziły się w pamięci przez różne próby i testowanie repozytoriów.

2. 4. Dockerfile i run --mount

Uważam że jak najbardziej wsyztskie dotychczasowe kroki dałoby się skompresować do jedngo pliku Dockerfile i uruchomienia odpowiedniego polecenia. Byłoby to znacznie szybsze i bardziej sensowne rozwiązanie. Znacznie łatwiej w przypadku wystąpienia problemów jest edytować Dockerfile niż wracać w pamięci do wcześniej wykonywanych kroków.

Run --mount miałby w tym przyoadku całkiem duże zastosowanie. Opcja --mount w poleceniu RUN w Dockerfile montuje katalogi podczs budowania obrazu. Korzysta w wtedy z pamięci zewnętrznej przez co proces budowy przebiega znacznie szybciej.

W tym przypadku opcja run --mount znalazłaby zastosowanie w kopiowaniu repozytorium do kontenera oraz kopiowania plików wyjściowyh do woluminu wyjściowego.

2. 5. Sewer iperf wewnątrz kontenera

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

# screen 2. 12

Mając adres ip serwera uruchomiłam kolejny kontener - klienta, którego połączę z serwerem  by przetestować przepustowość sieci. Uruchomie go z obrazu networkstatic/iperf3.
```
sudo docker run -it --rm networkstatic/iperf3 -c 172.17.0.2
```

# screen 2.13

2. 6. Dedykowana sieć mostkowa

Można korzystać z gotowych sieci mostkowych jednak stworzenie jej samemu jest znacznie bardziej korzystna. Dedykowane sieci mostkowe zapewniają lepszą izolację, większą elastyczność oraz swobodę ich konfiguracji.

By stworzyć własną sieć mostkową użyłam polecenia:
```
docker network create -d bridge moja_siec
```

# screen 2.14

Jeśli kontenery podłączone są do tej samej sieci zamiast odwoływać się do nich za pomocą aresów IP możem skorzystać z ich nazw. Należy uruchomić wtedy konener z opcją --net wskazując na sieć do której chcemy się podłączyć.
```
docker run --net=moja_siec --name=iperf3-server5 mlabbe/iperf3 -s
```
# screen 2.15

By połączy się spoza kontenera są dwie opcje:
- z hosta
- spoza hosta

Połączenie się z kontenerem z hosta wymaga użycia polecenia 
```
docker exec -it iperf3-server /bin/sh
```

# screen 2. 16


Połączenie się z kontenerem spoza hosta wymaga opublikowania portów kontenera na hoście za pomocą opcji -p podczas uruchamiania kontenera
```
docker run -p 5202:5201 --name=iperf4-server mlabbe/iperf3 -s
```
# screen 2. 17

Pobranie logów z kokntenera jest bardzo prsote wystarczy za pomocą odpowiedniej komendy pobrać logi z kontenera o danej nazzwie:
```
docker logs iperf3-server5
```

# screen 2. 18


2. 7. Jenkins

Instalację Jenkinsa musiałam odpuścić ze względu na problemy z pamięcią. By móc zacząć pracę z pipline najpewniej będę musiałam albo wyczyścić obecną maszynę wirtualną albo stworzyć nową. Proces instalacji Jenkinsa zosatnie przeze mnie wstawiony w kolejnym sprawozdaniu.