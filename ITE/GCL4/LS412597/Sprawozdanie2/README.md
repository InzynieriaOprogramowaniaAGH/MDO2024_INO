# Zajęcia 03 - Dockerfiles, kontener jako definicja etapu

---

## Sawina Łukasz - LS412597

### Wstęp

Zajęcia zostały wykonane przy wykorzystaniu Hyper-V do utworzenia wirtualnego systemu oraz systemu Fedora w wersji 39. Do komunikacji z maszyna wykorzystywane jest połączenie przy pomocy SSH oraz Visual Studio Code (VSC) jako edytor plików z rozszerzeniem `Remote Explorer`.
Do wykonania poniższych czynności wymagane jest wykonanie kroków ze sprawozdania nr. 1 (wymagany git oraz docker na maszynie)

### Wybór oprogramowania na zajęcia

Do wykonania tego zadania potrzebujemy aplikacji OpenSource, która będzie pozwalała na uruchomienie w repozytorium czegoś na kształt `make build` oraz `make test`. W tym celu wykorzystane zostaną dwa repozytoria:

- IRSI - link: https://github.com/irssi/irssi. Aplikacja ta pozwala na wcześniej wspomniane mechaniki, w tym przypadku jednak zamiast `make` wykorzystywane jest `ninja`,
- To Do Web App - link: https://github.com/devenes/node-js-dummy-test. Aplikacja jest napisana z wykorzystaniem Node.js dzięki czemu zamiast `make` możemy wykorzystywać polecenie `npm`.

Przed przystąpieniem do pracy z dockerem zapoznamy się z tymi dwoma aplikacjami lokalnie, na pierwszy rzut pójdzie To Do Web App.

- Do przygotowanego wczesniej katalogu testowego `~/test` klonujemy repozytorium.

  ![Klonowanie repo](Images/Zdj1.png)

- Ponieważ jest to aplikacja napisana z wykorzystaniem Node.js w takim celu musimy pobrać takową paczkę.
  Do tego wykorzystamy polecenie:

  ```bash
    sudo dnf install nodejs
  ```

  ![Instalacja node.js](Images/Zdj2.png)

- Teraz, gdy mamy potrzebne narzędzia do uruchomienia aplikajci przechodzimy do jej lokalizacji i przy pomocy polecenia `npm install` pobieramy wszystkie potrzebne zależności, to polecenie jest naszym odpowienikiem polecenia `make build`, którego poszukiwaliśmy w aplikacji.

  ![Instalacja zależności](Images/Zdj3.png)

- Po zainstalowaniu wszystkich zależności nie zostało nic innego jak uruchomienie testów przy pomocy `npm test` oraz uruchomienie aplikacji przy pomocy polecenia `npm start`.

  ![Uruchomienie testów](Images/Zdj4.png)

> Jak widać w aplikacji znajduje się tylko jeden test i całe szczęście przechodzi bez zarzutów.

![Uruchomienie aplikacji](Images/Zdj5.png)

> Aplikacja została uruchomiona i dostaliśmy informację, że można się z nią połączyć pod adresem http://localhost:3000. Jednak otwarcie jej w przeglądarce poza wirtualną maszyną wymagałoby dodatkowej pracy, więc uznajemy, że aplikacja działa.

Po przetestowaniu uruchomienia pierwszej aplikacji, przyszła pora na drugą, trudniejszą do uruchomienia.

- Podobnie jak w poprzedniej apliakcji zaczynamy od sklonowania repozytorium

  ![Sklonowanie repozytorim](Images/Zdj6.png)

- Z repozytorium aplikacji możemy wyczytać, że do kompilacji wymagane jest wcześniejsze pobranie:

  - meson-0.53 build system with ninja-1.8 or greater
  - pkg-config (or compatible)
  - glib-2.32 or greater
  - openssl (for ssl support)
  - perl-5.8 or greater (for building, and optionally Perl scripts)
  - terminfo or ncurses (for text frontend)

  dlatego kolejnym krokiem będzie doinstalowanie wszystkich potrzebnych zależności. Kroku tego możemy dokonać w jednym poleceniu lub pobierać każdy z nich z osobna.

  ```bash
  sudo dnf -y install meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*
  ```

  > Ponieważ instalowane jest wiele rzeczy i pokazywanie całego wyniku instalacji mija się z sensem pomijam zrzut ekranu tego kroku.

- Po pobraniu wszystkich potrzebnych zależności możemy przejść do katalogu repozytorium i rozpocząć budowanie:

  ```bash
    cd irssi/
    meson Build
    cd Build/
    ninja
  ```

  ![Budowanie aplikajci](Images/Zdj7.png)
  ![Budowanie aplikajci](Images/Zdj8.png)
  ![Budowanie aplikajci](Images/Zdj9.png)

- Po zbudowaniu aplikacji przyszła pora na uruchomienie testów, w tym celu w lokalizajci `/irssa/Build` uruchomimy testy `ninja test`

  ![Testy](Images/Zdj10.png)
  Jak widać wszystkie testy zakończyły się pozytywnie :)

### Przeprowadzenie buildu w kontenerze

### 1. Wykonaj kroki build i test wewnątrz wybranego kontenera bazowego

> Powyższy krok został wykonany nie w kontenerze a w systemie głównym dlatego pomijam ten punkt, wykonanie jest jednakowe, jedyna różnica, to miejsce w którym jest wykonywany.

## IRSSI

### 2. Stwórz dwa pliki Dockerfile automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:

- Kontener pierwszy ma przeprowadzać wszystkie kroki aż do builda.

W tym celu tworzymy nasz pierwszy plik DockerFile, dla ujednolicenia nazewnictwa nazwy plików będziemy poprzedać nazwą aplikacji. Tak oto tworzymy plik `irssi_builder.Dockerfile`

```Dockerfile
  FROM fedora:39
  RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*
  RUN git clone https://github.com/irssi/irssi
  WORKDIR /irssi
  RUN meson Build
  RUN ninja -C /irssi/Build
```

Jak można zauważyć idą kolejno zawartością pliku:

> FROM: kontener opieramy na obrazie z systemem Fedora w wersji 39,

> RUN dnf: wykonujemy aktualizację pakietów systemowych i następnie instaluje zestaw narzędzi i bibliotek wymaganych do budowy oprogramowania, warto zauważyć, że dodatkowo pobieramy git'a ponieważ nie jest on domyślnie w systemie Fedora (przy testowym budowaniu i uruchamianiu aplikajci nie pobieraliśmy go, ponieważ już był zainstalowany na systemie),

> RUN git clone: klonujemy repozytorium Irssi z GitHuba

> WORKDIR: ustawiamy katalog roboczy na `/irssi`,

> RUN meson Build: wykonujemy komendę meson w do skonfigurowania budowy Irssi,

> RUN ninja: uruchamiamy komendę ninja w celu wykonania faktycznej budowy Irssi.

- Kontener drugi ma bazować na pierwszym i wykonywać testy

Tworzymy kolejny plik Dockerfile, tym razem będzie to plik do tworzenia obrazu z uruchomionymi testami:

```Dockerfile
  FROM irssi_build
  WORKDIR /irssi/Build
  RUN ninja test
```

> WAŻNE przy twozreniu orbazu z pierwszego dockerfila musimy ustawić nazwę obrazu taką jak w tym pliku, lub ewentualnie zmienić ją w tym pliku.

Idąc kolejno zawartością pliku:

> FROM irssi-buil: obraz bedziemy opierali na obrazie utworzonym przez poprzedni dockerfile.

> WORKDIR: ustawiamy katalog roboczy na `/irssi/Build`

> RUN ninja test: uruchamiamy testy.

### 3. Wykaż, że kontener wdraża się i pracuje poprawnie.

Do zbudowania naszych dockerfilów użyjemy polecenia:

```bash
 docker build -t <nazwa_obrazu> -f ./<nazwa_pliku+Dockerfile> .
```

Zaczniemy od zbudowania obrazu `Irssi_build`, w tym celu wykonamy polecenie

```bash
 docker build -t irssi_build -f ./irssi_builder.Dockerfile .
```

![Budowa Irssi_build](Images/Zdj11.png)
![Budowa Irssi_build](Images/Zdj12.png)

Jak widać nasz obraz został zbudowany. Obecnie w tym obrazie znajduje się system Fedora z pobranymi pewnymi zewnętrznymi narzędziami i zbudowaną aplikacją. Nic więcej się w niej nie znajduje. Przy próbie uruchomienia naszego obrazu nie dostaniemy żadnego wyniku, ponieważ kontener będzie oczekiwał na polecenie do wykonania i od razu go wyłączy, ponieważ żadne polecenie nie zostanie przekazane.

![Uruchomienie obrazu](Images/Zdj13.png)

Po zbudowaniu obrazu `Irssi_build` możemy zbudować nasz Dockerfile zawierający uruchomienie testów, nazwiemy go `irssi_test`:

```bash
 docker build -t irssi_test -f ./irssi_tester.Dockerfile .
```

![Uruchomienie obrazu](Images/Zdj14.png)

Jak widać nasz obraz został zbudowany, a w trakcie budowania zostały wykonane testy. Tutaj podobnie, gdybyśmy chcieli uruchomić nasz obraz nie dostaniemy żadnego wyniku.

## TO DO WEB APP

### 2. Stwórz dwa pliki Dockerfile

- Dla tej aplikacji powtórzymy wcześniejsze kroki, zaczniemy od utworzenia dockerfila dla budowania aplikacji. W tym celu możemy wykorzystać już istniejący obraz `Node`, który na szczęście posiada w sobie wszystkie niezbędzne narzędzia do zbudowania naszej aplikacji, nawet posiada w sobie narzędzie git. Tworzymy plik `nodeapp_builder.Dockerfile`

```Dockerfile
FROM node
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /node-js-dummy-test
RUN npm install
```

nasz plik wygląda podobnie jak w przypadku poprzedniej aplikacji. Obraz opieramy na obrazie `Node`, klonujemy repozytorium, zmieniamy katalog roboczy, instalujemy wszystkie zależności.

Następnie tworzomy dockerfila dla testów, będziemy go opierali o wcześniej utworzony obraz i wykonamy w nim polecenie `npm test`.

```Dockerfile
FROM nodeapp_build
RUN npm test
```

### 3. Wykaż, że kontener wdraża się i pracuje poprawnie.

Tutaj identycznie jak wcześniej będziemy budowac nasze pliki dockerfile.

Zaczniemy od pliku `nodeapp_builder.Dockerfile`

```bash
 docker build -t nodeapp_build -f ./nodeapp_builder.Dockerfile .
```

![Budowa obrazu build](Images/Zdj15.png)

Po zbudowaniu obrazu ze zbudowaną aplikacją możemy zbudować nasz obraz z testami.

```bash
 docker build -t nodeapp_test -f ./nodeapp_tester.Dockerfile .
```

![Budowa obrazu test](Images/Zdj16.png)

Dla obu tych obrazów próba uruchomienia ich nie da żadnego efektu, ponieważ nie podaliśmy żadnej komendy, którą nasz obraz ma wykonać.

### Docker Compose

Jeśli chcielibyśmy bardziej zautomatyzować nasz proces, aby nie musieć ręcznie budować jednego obrazu, a następnie drugiego, możemy cały ten proces zawrzeć w docker-compose. W tym celu musimy doinstalować potrzebne narzędzia oraz rozszerzenie do Docker'a.

W pierwszej kolejności, ponieważ pracujemy na systemie Fedora musimy doinstalować narzędzie dnf-plugins-core:

```bash
  sudo dnf -y install dnf-plugins-core
```

A następnie przy jego pomocy dodać repozytorium:

```bash
 sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

Po wykonaniu tych kroków możemy doinstalować docker-compose:

```bash
sudo dnf install docker-compose-plugin
```

![Instalacja docker-compose-plugin](Images/Zdj17.png)

Gdy już mamy zainstalowany docker-compose-plugin możemy przejść do tworzenia naszego pliku docker-compose. W tym celu wcześniej wykonałem małe porządki w katalogach, mianowicie wszystkie dockerfile zostały odpowiednio skatalogowane.

![Katalogi](Images/Zdj18.png)

Teraz możemy przejść do tworzenia docker-compose, zaniczemy od aplikacji Irssi. W tym celu w katalogu `/Irsii` utworzymy nowy plik o nazwie `docker-compose.yml`.

```YML
version: '3'

services:
  irssi_build:
    build:
      context: .
      dockerfile: ./irssi_builder.Dockerfile
    image: irssi_build

  irssi_test:
    build:
      context: .
      dockerfile: ./irssi_tester.Dockerfile
    image: irssi_test
    depends_on:
      - irssi_build
```

W pliku tym dodajemy kolejne serwisy, mianowicie obraz ze zbudowaną aplikacja, oraz obraz z przeprowadzonymi testami. Jak widać obraz z testami jest zależny od obrazu ze zbudowaną aplikacja. Dodatkowo obrazy dostały określone z góry nazwy, ponieważ w pliku irssi_tester.Dockerfile mamy określone na jakim obrazie ma bazować.

Po napisaniu całego pliku możemy przejść do uruchomienia, znajdując sie w katalogu z plikiem `docker-compose.yml` uruchamiamy polecenie:

```bash
docker-compose up
```

> Warto przed tym usunąć wcześniej utworzone obrazy.

![docker-compose up](Images/Zdj19.png)
![docker-compose up](Images/Zdj20.png)

Jak widać oba nasze dockerfile zostały zbudowane przy pomocy jednego polecenia. Udało się nam ten proces bardziej zautomatyzować, dodatkowo przy pomocy `docker images` widzimy, że nasze obrazy zostały utworzone.

Dla aplikacji To Do Web App wykonujemy identyczne czynności, w tym przypadku jednak dodamy jeden dodatkowy Dockerfile, będzie to wdrożeniowy dockerfila.

Jego zawartość będzie wyglądała następująco:

```Dockerfile
FROM nodeapp_build

CMD ["npm", "start"]
```

Obraz ten po uruchomieniu będzie wykonywał polecenie `npm start`, które uruchomi naszą aplikację.

Plik docker-compose będzie wyglądał następująco:

```YML
version: '3'

services:
  nodeapp_build:
    build:
      context: .
      dockerfile: ./nodeapp_builder.Dockerfile
    image: nodeapp_build

  nodeapp_test:
    build:
      context: .
      dockerfile: ./nodeapp_tester.Dockerfile
    image: nodeapp_test
    depends_on:
      - nodeapp_build

  nodeapp_depoy:
    build:
      context: .
      dockerfile: ./nodeapp_deploy.Dockerfile
    image: nodeapp_deploy
    depends_on:
      - nodeapp_build
```

Uruchamiamy go identycznie jak poprzednio.

![docker-compose up](Images/Zdj21.png)
![docker-compose up](Images/Zdj22.png)

Jak widać nasza aplikacja została zbudowana, przetestowana oraz uruchomiona i jest dostępna pod adresem `http://localhost:3000`

W ten sposób dodaliśmy kolejny etap, który jest wdrożeniem, nasza aplikacja na podstawie zbudowanego obrazu uruchomiła nam aplikację.

### Dyskusja

- Czy program nadaje się do wdrażania i publikowania jako kontener, czy taki sposób interakcji nadaje się tylko do builda

> W przypadku aplikacji Irssi obecna konfiguracja Dockefilów nadaje się tylko do budowania oraz testowania. Jest to spowodowane specyfiką aplikacji, aplikacja w terminalu tworzy interfej użytkownika, który nie nada się nam przy wykorzystaniu z kontenerem. Inaczej jest jednak w przypadku aplikacji napisanej w nodejs. W jej przypadku możemy wykorzystać nasze Dockerfile do budowania, testowania oraz wrażania aplikacji, wymagało by to od nas dodatkowej konfiguracji, tak aby w obrazie wdrożeniowym znajdowała się tylko nasza aplikacja, bez kodu źródłowego, ponieważ nie chcemy go udostępniać przy końcowym etapie. Dodatkowo aplikacja napisana w nodejs działa jako serwis w tle, z którym się łączymy przy pomocy przeglądarki.

- Opisz w jaki sposób miałoby zachodzić przygotowanie finalnego artefaktu

> Do przygotowania finalnego artefaktu aplikacja musiała by przejść przez kilka etapów:
>
> - Budowanie: zbudowanie aplikacji w kontenerze. Ten krok obejmował by pobranie źródeł aplikacji, instalację zależności, kompilację kodu źródłowego itp.
> - Testowanie: Po zbudowaniu aplikacji musimy uruchomić nasze testy sprawdzajace czy aplikacja na pewno poprawnie działa. Od tego kroku może zależeć czy kolejne etapy zostana wykonane, w przypadku niepowodzenia przy którymś teście nasz proces by się przerywał.
> - Pakowanie: utworzenie pakietu zawierającego gotową aplikację
> - Przeniesienie pakietu: nasz pakiet przenosimy z kontenera do innego miejsca, gdzie będzie dostępny dla użytkowników lub dla dalszego wykorzystania
> - Dystrybucja: po uzyskaniu pakietu możemy go udostępnić użytkownikom lub systemowi np. udostępnienie innym użytkownikom, wdrożenie na serwer lub chmurę.

- Jeżeli program miałby być publikowany jako kontener - czy trzeba go oczyszczać z pozostałości po buildzie?

> Oczywiście, w przypadku gdybyśmy chcieli publikować nasz obraz nie chcemy udostępniać przede wszystkim kodu źródłowego, naszym celem jest udostępnienie tylko zbudowanej aplikacji. Osoba, która bedzie pracowała na tym kontenerze nie powinna mieć wglądu na kod źródłowy, aby nic w nim nie zmienić. Dodatkowo będziemy chcieli usunąć wszystkie niepotrzebne pliki oraz artefakty związane z procesem budowania.

- A może dedykowany deploy-and-publish byłby oddzielną ścieżką (inne Dockerfiles)?

> Takie podejście jest dobrym pomysłem, w ten sposób będziemy mogli oddzielić budowanie i publikowanie przy użyciu np. różnych Dockerfile'ów. W ten sposób będziemy mieć jeden zestaw instrukcji do budowania obrazu używaneto podczas tworzenia aplikacji oraz drugi do publikacji gotowego obrazu do użycia. W ten sposób proces budowania będzie mógł zawierać kod źródłowy, wszelkie zależności, narzędzia developerskie, które będą potrzebne przy budowaniu aplikacji, a proces publikacji będzie się skupiał tylko na minimalizacji rozmiaru obrazu oraz zapewnieniu niezbędnych elementów dla środowiska wdrożeniowego.

- Czy zbudowany program należałoby dystrybuować jako pakiet, np. JAR, DEB, RPM, EGG?

> Dużo w tym przypadku zależy od tego w jakim środowisku oraz jakie wymagania mamy do naszego pakietu. Ogólnie takie podejście da nam dużo korzyści, takich jak łatwość instalacji, łatwiejsze zarządzanie aktualizacjiami, zarządzanie zależnościami itp.

- W jaki sposób zapewnić taki format? Dodatkowy krok (trzeci kontener)? Jakiś przykład?

> Do takiego podejścia możemy wykorzystywać gotowe narzędzia budowania pakietów, które są dostępne dla danej platformy/systemu. Możemy również dodać trzeci kontener, który będzie służył jako kontener do formatowania naszego pakietu. Po zbudowaniu oraz przetestowaniu aplikacji przez poprzednie kontenery, trzeci kontener będzie używany do utworzenia pakietu z gotową aplikacją. Przykładowo, jeśli tworzymy aplikację na system Linux, mozemy dodać trzeci kontener oparty na obrazie zawierającym narzędzia do tworzenia pakietów, np. dpkg-dev. Następnie możemy użyć tego kontenera do utworzenia pakieto DEB z gotową aplikacją.

# Zajęcia 04 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Zachowywanie stanu

### Przygotuj woluminy wejściowy i wyjściowy, o dowolnych nazwach, i podłącz je do kontenera bazowego, z którego rozpoczynano poprzednio pracę

Do utworzenia woluminu możemy wykorzystać polecenie:

```bash
 docker volume create <nazwa_woluminu>
```

W celu wykonania zadania tworzymy dwa woluminy o nazwach 'vin' oraz 'vout', które będą odpowiednio woluminem wejściowym oraz wyjściowym. Do wyświetlenia utwrzonych woluminów możemy wykonać polecenie

```bash
  docker volume ls
```

![docker volume list](Images/Zdj23.png)

### Uruchom kontener, zainstaluj niezbędne wymagania wstępne (jeżeli istnieją), ale bez gita

W celu zainstalowania niezbędnych wymagań wstępnych na kontenerze, ale bez wykorzystania git'a, możemy wykorzystać dodatkowy kontener, na którym zainstalujemy git'a oraz podepniemy do niego wolumin wejściowy. Po podpięciu zainstalujemy wszystkie potrzebne wymagania, a następnie w docelowym kontenerze zbudujemy nasz projekt, który znajduje się w podpiętym woluminie wejściowym.

![Uruchomienie roboczego kontenera](Images/Zdj24.png)
Jak widać w pierwszej kolejności uruchamiamy kontener z fedorą podpinająć do niego wolumin vout jako katalog `/tmp`. W tym celu używamy polecenia:

```bash
docker run -it -v <nazwa_woluminu>:/ścieżka/w/kontenerze --name nazwa_kontenera obraz_kontenera
```

> nazwa_kontenera jest dodatkową opcją, nie jest konieczna do uruchomienia

### Sklonuj repozytorium na wolumin wejściowy (opisz dokładnie, jak zostało to zrobione)

![Uruchomienie roboczego kontenera](Images/Zdj25.png)
W kolejnym kroku przechodzimy do katalogu `/tmp` i instalujemy git, aby mieć dostęp do naszego repozytorium.

> Katalog node_modules jest pozostałością, której nie będzie przy wykonywaniu tego pierwszy raz.

### Uruchom build w kontenerze

Teraz, gdy mamy dostępny nasz kod źródłowy, możemy utworzyć kontener do builda, podepniemy do niego dwa woluminy, a konkretnie wejściowy vin, który posiada w sobie kod aplikacji oraz vout w którym znajdą się wyniki zbudowania naszej aplikajci, ponieważ budujemy aplikację napisaną w node.js jako vout określimy katalog `/node_modules` jako volumin.
![Kontener budowniczy](Images/Zdj26.png)

Jak można zauważyć w naszym kontenerze instnieje już katalog z kodem aplikacji, dlatego nasz wolumin został prawidłowo podpięty. Teraz możemy doinstal node.js ponieważ nie ma go domyślnie w kontenerze.
![Instalacja node.js](Images/Zdj27.png)

Jedyne co nam teraz zostało to pobrać wszystkie zależnośći naszej aplikację przy pomocy polecenia `npm install`.

![Instalacja dependencji](Images/Zdj28.png)

Nasza aplikacja została zbudowana, a wszystkie zainstalowane zależności znajdują się w katalogu node_modules.

![Uruchomienie apki](Images/Zdj29.png)

Dzięki temu przy uruchomieniu nowego kontenera oraz doinstalowania mu node.js (cały czas pracujemy w oparciu o czystą fedorę) oraz dołączeniu voluminów wejściowych i wyjściowych możemy uruchomić aplikację.

![Apka w nowym kontenerze](Images/Zdj31.png)
![Apka w nowym kontenerze](Images/Zdj30.png)

DYSKUSJA

## Eksponowanie portu

### Uruchom wewnątrz kontenera serwer iperf (iperf3)

Do uruchomienia serwera iperf możemy wykorzystac dedykowany obraz `networkstatic/iperf3`. Możemy utworzyć taki kontener wykorzystując polecenie:

```bash
  docker run -d --name kontener-server -p 5201:5201 networkstatic/iperf3 -s
```

Jak widać dodatkowo udostępniamy porty 5201, który jest domyślnym portem dla iperf3, dzięki czemu inne kontenery będą się mogły odwoływać do naszego kontenera.

![Utworzenie kontenera serwer](Images/Zdj32.png)

Następnie sprawdzimy jaki adres ip ma nasz kontener, do tego wykorzystamy polecenie:

```bash
  docker inspect <nazwa_kontenera>
```

![Adres ip](Images/Zdj33.png)

Następnie poszukujemy sekcji `NetworkSettings` i w niej mamy `IPAddress`. Ten adres zapisujemy na później

![Adres ip](Images/Zdj34.png)

Teraz, gdy mamy pracujący serwer, możemy uruchomić kontener dla klienta, będzie to kontener z fedorą do którego doinstalujemy iperf3, po czym spróbujemy połączyć się z serwerem.

![Klient połączenie](Images/Zdj35.png)
![Klient połączenie](Images/Zdj36.png)

Do połączenia się z serwerem wykorzystaliśmy polecenie:

```bash
  iperf3 -c 172.17.0.2 -p 5201
```

jak można zauważyć podaliśmy ip serwera oraz port na przez który ma się połączyć. W wyniku otrzymaliśmy udaną komunikację poniędzy dwoma kontenerami, dodatkowo możemy sprawdzić komunikację w drugą stronę czyli z serwera na klienta

![Klient połączenie](Images/Zdj37.png)

### Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową

Do utworzenia sieci w Docker wykorzystujemy polecenie:

```bash
  docker network create <nazwa_sieci>
```

![Nowa sieć](Images/Zdj38.png)

Sieci typu bridge są domyślnymi sieciami w Docker. Teraz, gdy mamy naszą sieć tworzomy ponownie dwa kontenery, tylko tym razem określamy im z jakiej sieci mają korzystać.

Serwer:

```bash
  docker run -d --name kontener-server --network siec_testowa networkstatic/iperf3 -s
```

Do uruchamiania kontenera dodajemy opcję --network po której określamy nazwę naszej sieci. identycznie robimy w przypadku klienta.

![Uruchomiony serwer](Images/Zdj39.png)

Po wykonaniu inspek na kontenerze serwera widzimy, że w konfiguracji sieci pojawiła się nasza nazwa sieci:

![Sieci serwera](Images/Zdj40.png)

Identyczna konfiguracja pojawia się nam na kliencie. Teraz jak wykonamy test połączenia otrzymamy pomyślną komunikację.

Klient -> Serwer
![Komunikacja](Images/Zdj41.png)

Serwer -> Klient
![Komunikacja](Images/Zdj42.png)

### Połącz się spoza kontenera (z hosta i spoza hosta)

W tym celu na systemie fedora, na którzym uruchamiane są wszystkie kontenery wykonam identyczne czynności jak dla klienta, zainstaluję iperf3 oraz spróbuję połączyć się z serwerem.

![Komunikacja](Images/Zdj43.png)

Jak widać udało się połączyć przy wykorzystaniu adresu IP kontenera, jednak gdy użyłem nazwy kontnera DNS nie rozpoznał tej nazwy (Jest to ważny punkt przy dalszej części zadania).

Teraz identyczny krok postaram się wykonać z poziomu Windows. Na poniższym zdjęciu zobaczymy trzy próby wykonania tego. (iperf3 musi zostać pobrane dodatkowo, ponieważ nie jest wbudowane w windows)

![Komunikacja](Images/Zdj44.png)

Pierwsza z nich jest wykonywana przez podanie adresu 127.0.0.1 zamiast adresu kontenera, dodatkowo kontnere jest tym samym co był uruchomiony przed chwilą. Powodem dlaczego nie możemy się połączyć, chociaż podaliśmy nawet port przez który musi się połączyć jest brak "Włączenia" tych portów w kontenerze, w tym celu musimy uruchomić nasz kontener w następujący sposób:

```bash
docker run -d --name kontener-server --network siec_testowa -p 5201:5201 networkstatic/iperf3 -s
```

Teraz serwer będzie uruchomiony tak samo jak przed chwilą, ale dodatkowo ma wyeksonowany port 5201, dzięki czemu komunikacja przebiegnie pomyślnie, co pokazuje druga próba. W trzeciej próbie testowane było połączenie się przy pomocy adresu kontenera, a nie localhost, jak widać nie powiodło się.

### Odwołuj się do kontenera serwerowego za pomocą nazw, a nie adresów IP

W tym celu dalej wykorzystujemy nasze kontenery klienta oraz serwera połączone do jednej sieci `siec_testowa`.

Po wykonaniu polecenia:

```bash
  docker network inspect <nazwa_sieci>
```

Możemy zobaczyć dokładne informacje o naszej sieci, jedną z nich jest lista podłączonych kontenerów.

![Sieć](Images/Zdj45.png)

Jak widać nasze oba kontenery zostały dodane do sieci, w takim razie możemy spróbować wykonac połączenie, tylko tym razem klient zamist podawać adres IP serwera, poda nazwę konteneru.

![Komunikacja](Images/Zdj46.png)

Jak widać mamy wielki sukces!! To pokazuje, że nasze kontenery zostały połączone w sieć, gdzie przykłądowo system na którym uruchamiana jest fedora nie znajduje się w tej sieci, porzez co nie może wykonać komunikacji przez nazwę kontenera.

## Instancja Jenkins

Do zainstalowania skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND w pierwszej kolejności musimy utworzyć sięc dla kontenerów:

```bash
  docker network create jenkins
```

Po tym możemy wykorzystać dostarczoną na oficjalnej stronie komendę docker run, która skonfiguruje nam instację Jenkins'a

```bash
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
  --storage-driver overlay2
```

![Jenkins](Images/Zdj47.png)

Następnie tworzymy Dockerfile do wprowadzenia zmian w oficialnym obvrazie Jenkins Docker

```Dockerfile
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

Po czym uruchamiamy go przy pomocy polecenia:

```bash
    docker build -t myjenkins-blueocean:2.440.2-1 .
```

![Jenkins](Images/Zdj48.png)

Ostatnim krokiem jaki pozostał to uruchomienie kontenera z instancją Jenkins, ponownie wykorzystujemy komendę dostarczoną na oficjalnej stronie:

```bash
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

![Jenkins](Images/Zdj49.png)

Jak widać nasz kontener z instancją Jenkins jest uruchomiony, teraz możemy przejść na przeglądarce na adres http://localhost:8080, aby dokończyć cały proces.

![Jenkins](Images/Zdj50.png)

Następnie musimy znaleźć hasło administratorskie, na stronie widać dokładną ścieżkę gdzie się znajduje, więc przechodzimy do niej i wyświetlamy zawartość pliku.

![Jenkins](Images/Zdj51.png)

Po podaniu hasła dostajemy możliwość pobrania dodatkowych wtyczek, wybieram sugerowane, ponieważ nie wiem jakie wybrać :(

Po wszystkim dostajemy okno dodania pierwszego administratora

![Jenkins](Images/Zdj52.png)

Po skończeniu konfiguracji Jenkins otrzymujemy ekran główny i możemy rozpoczynać pracę z naszymi pipelinami :)

![Jenkins](Images/Zdj53.png)
