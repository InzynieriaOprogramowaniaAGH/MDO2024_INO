# Sprawozdanie 2
## Łukasz Oprych 410687 Informatyka Techniczna

## Lab 3

Celem następujących zajęć było zbudowanie i uruchomienie testów w repozytorium dwóch aplikacji dysponujących otwartą licencją, które posiadają narzędzia na kształt `make build` oraz `make test` (**meson**, **ninja** dla [**irssi**](https://github.com/irssi/irssi) **npm** dla [**todo web app**](https://github.com/devenes/node-js-dummy-test)).

#### 1. Wykonaj kroki build i test wewnątrz wybranego kontenera bazowego.

Na początek zaczniemy od aplikacji **irssi**, uruchomimy kontener, sklonujemy repozytorium i doinstalujemy wymagane zależności. 

Naszą pracę rozpoczniemy od uruchomienia kontenera interaktywnie z fedorą, który w prosty sposób umożliwi nam pracę na tym repozytorium, ponieważ kod aplikacji głównie jest stworzony w języku C.


![runfedora](runfedora.png)

Następnie w celu sklonowania repozytorium oraz kompilacji programu, musimy doinstalować kompilator **gcc**, buildery **meson, ninja** oraz **git'a**

Aby je zainstalować użyjemy poniższego polecenia:

![dnfupd](dnfupd.png)


Następnie sklonujemy repozytorium następującym poleceniem:

![clonecd](clonecd.png)

Po wykonaniu powyższych kroków, można przejść do katalogu z pobranego repozytorium 

```
cd irssi
```
i zbudujemy aplikację poleceniem 
```
meson build
```

![mesonbuild](mesonbuild.png)

Aby skompilować poprawnie program, [**dokumentacja**](https://github.com/irssi/irssi/blob/master/INSTALL) w repozytorium informuje nas, że należy doinstalować między innymi niniejsze narzędzia

![irssidocs](irssidocs.png)

Doinstalujmy je:

![doinstalowanie](doinstalowanie.png)

Po doinstalowaniu ponownie zbudujemy poleceniem `meson build`

![mesonbuildpodoinstalowaniu](mesonbuildpodoinstalowaniu.png)

następnie w celu zbudowania aplikacji używamy polecenia 

```
ninja -C irssi/Build
```

![ninja-c](ninja-c.png)

Po zbudowaniu aplikacji uruchomimy testy ze sklonowanego repozytorium poleceniem 

```
ninja test
```

![ninjatest](ninjatest.png)

Jak widać wszystkie testy przeszły pozytywnie.

Kolejnym przykładem aplikacji będzie **To do web app**, które będzie wymagać mniejszej ilości działań w celu udanej konfiguracji aplikacji.

Uruchomimy interaktywnie kontener node'owy, który usunie się po zamknięciu poleceniem:
```
sudo docker run --rm -it node /bin/bash
```

![containerrun](containerrun.png)

Owy obraz wybrano ponieważ, aplikacja została napisana przy użyciu Node.js.

Następnie aktualizujemy menadżer paczek, instalujemy gita 
```
apt-get update
apt-get install git
```

Podobnie jak na wcześniejszym przykładzie klonujemy repo poleceniem `git clone <https://github.com/<repo>>`.

![aptupdategitcd](aptupdategitcd.png)

Do instalacji zależności określonych pliku package.json używamy polecenia 

```
npm install
```

![npminstall](npminstallcont.png)

Następnie po instalacji niezbędnych zależności, można uruchomić test dołączony do sklonowanego repozytorium poleceniem 

```
npm test
```

![runtestcont](runtestcont.png)

#### 2. Stwórz dwa pliki Dockerfile automatyzujące kroki powyżej.

#### Kontener pierwszy ma przeprowadzić kroki aż do builda

W celu zautomatyzowania naszych działań tworzymy pliki `Dockerfile`. W przypadku aplikacji node `node-builder.Dockerfile`, który zbuduje nam sklonowaną aplikację oraz `node-test.Dockerfile` dzięki któremu wykonamy testy na podstawie utworzonego  uprzednio `buildera`. 

**node-builder.Dockerfile**
```
FROM node

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
```
Polecenie `FROM node` oznacza, że obraz będzie oparty na obrazie bazowym zawierającym środowisko uruchomieniowe *Node.js*

Następnie wykonuje się polecenie `RUN git clone https://github.com/devenes/node-js-dummy-test`, które pobiera kod źródłowy z repozytorium zdalnego.

Kolejnym krokiem jest ustawienie katalogu roboczego na `/node-js-dummy-test` za pomocą polecenia `WORKDIR /node-js-dummy-test`, dzięki temu wszystkie kolejne operacje będą wykonywane w tym katalogu.

Ostatecznie, polecenie `RUN npm install` instaluje wszystkie zależności Node.js zdefiniowane w pliku package.json znajdującym się w katalogu projektu.

**node-test.Dockerfile**

```
FROM node-builder
RUN npm test
```
Polecenie `FROM node-builder` oznacza, że obraz będzie oparty o obraz bazowy, którym jest uprzednio utworzony *node-builder.Dockerfile*. Następnie wykonuje się polecenie `RUN npm test`, które uruchamia testy.

#### Wykaż, że kontener wdraża się i pracuje poprawnie

Następnie w celu wdrożenia kontenera, w uprzednio stworzonym katalogu `node` budujemy obraz za pomocą polecenia 

```
sudo docker build -t node-builder:0.1 -f ./node-builder.Dockerfile .
```
Gdzie `-t` mówi nam, że obraz będzie nazywał się `node-builder` z tagiem `0:1`, `-f`, że będzie on zbudowany przy użyciu pliku znajdującego się w aktualnym katalogu o nazwie `node-builder.Dockerfile`, w bieżącym katalogu `.`

![buildnodebuilder](buildbuildernodeauto.png)

Po zbudowaniu buildera możemy zbudować obraz odpowiadający za testy na podobnej zasadzie poleceniem 

```
sudo docker build -t node-test:0.1 -f node-test.Dockerfile .
```

![buildtest](buildtest.png)

W celu sprawdzenia działania budowania i testowania, można uruchomić kontenery builder i test poleceniem `sudo docker run <nazwa_obraz>`, lecz próba ich uruchomienia nie zwróci nam konkretnego wyniku.

Jedynie poleceniem `echo $?` możemy sprawdzić czy zakończenie działania kontenerów było pozytywne **zakończone zerem**

![runbuilder](runbuilder.png)
![runtest](runtest.png)

Następnie na przykładzie irssi również tworzymy obrazy builder i test.

**irssi-builder.Dockerfile**
```
FROM fedora
RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

RUN git clone https://github.com/irssi/irssi

WORKDIR /irssi
RUN meson Build
RUN ninja -C /irssi/Build
```

Poleceniem `RUN Fedora` opieramy nasz tworzony obraz o obraz systemu Fedora, który stosujemy identycznie jak we wcześniejszym poleceniu ze względu na technologię, w której stworzono aplikację.

Poleceniem `RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*` podobnie jak przy ręcznej budowie obrazów aktualizujemy system i instalujemy wymagane zależności, takie jak git, meson, ninja etc.

Poleceniem `RUN git clone https://github.com/irssi/irssi`klonujemy repo.

Poleceniem `WORKDIR /irssi` ustawiamy katalog roboczy na irssi

Poleceniem `RUN meson Build` przygotowujemy środowiska do budowania

Poleceniem `RUN ninja -C /irssi/Build` w katalogu irssi/build dokonujemy kompilacji programu irssi przy użyciu ninja.

**irssi-test.Dockerfile**
```
FROM irssi-builder

WORKDIR /irssi/Build

RUN ninja test
```
W przypadku obrazu testowego opieramy go uprzednio utworzony obraz `irssi-builder`
poleceniem `FROM irssi-builder`. Ustawiamy katalog roboczy na /irssi/build, dzięki `WORKDIR /irssi/Build` i uruchamiamy testy poleceniem `RUN ninja test`.

Analogicznie budujemy obraz buildera poleceniem w uprzednio utworzonym katalogu irssi

```
sudo docker build -t irssi-builder -f ./irssi-builder.Dockerfile .
```

![buildbuilder](buildbuilder.png)

Obraz test budujemy poniższym poleceniem 

```
sudo docker build -t irssi-builder -f ./irssi-builder.Dockerfile .
```

![buildtestirssi](buildtestirssi.png)

Następnie uruchamiamy kontenery 

![run](run.png)

i sprawdzamy poleceniem `sudo docker container ps -a` efekt uruchomienia kontenerów oraz wynik wyjściowy, jak widać `exited (0)` czyli działanie zakończyło się poprawnie.

![ps-a](ps-a.png)

## Lab 4

