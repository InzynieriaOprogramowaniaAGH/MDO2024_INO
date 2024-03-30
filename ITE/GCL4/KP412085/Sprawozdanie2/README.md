# Sprawozdanie 2

Pierwsza część drugiego sprawozdania przedstawia przeprowadzenie operacji `build ` oraz `test` dla wybranych aplikacji, które korzystają z programów do buodwania i testowania (npm, meson, maven itd.). Następnie na tej podstawie napiszemy pliki `Dockerfile`, które pozwolą na automatyzację tych procesów w oparciu o budowę kontenerów. Ważnym aspektem tej części jest zbudowanie świadomości, że budowa takich kontenerów bez definiowania w obrazach na bazie których powstają żadnych operacji `CMD` czy `ENTRYPOINT` pozwala na osiągnięcie efektu, w którym po uruchomieniu polecenia `docker run` obrazy ze zdefiniowanym procesem `build` lub `run` tworzą się ale natychmiastowo kończą swoje wykonanie (po poprawnej definicji obrazów) z kodem `exit 0`. Kontenery te służą bowiem jedynie do zbudowania i przetestowania aplikacji, a nie do jej uruchomienia. Pozwala to na stworzenie środowiska do budowania i testowania, które ma ściśle zdefiniowaną architekturę, zależności i konfigurację oraz ma bardzo małe wymagania sprzętowe (wystarczy mechanizm konteneryzacji a nie osobna fizyczna maszyna, czy konfigurowana maszyna wirtualna). Takie rozwiązanie daje w następstnie dużą możliwość automatyzacji całego procesu budowania, testowania i deploymentu aplikacji, czyli tworzenia mechanizmu `Continuous Integration`.

Repozytoria programów z których skorzystamy:
- https://github.com/devenes/node-js-dummy-test (npm)
- https://github.com/irssi/irssi (meson, ninja)

# Przeprowadzenie build oraz test w kontenerze oraz automatyzacja prcesów za pomocą Dockerfile'i 

- **Prosta aplikacja wykorzystująca npm jako środowisko do budowania i testowania**
<br></br>
*Aby przeprowadzić build w kontenerze zbudowanym z obrazu `node`, uruchamiamy w kontenerze w trybie interaktywnym proces /bin/bash, pobieramy konieczne pakiety (git powinien być już domyslnie zainstalowany), klonujemy repozytorium, a nastepnie pobieramy wszystkie zależności z pliku package.json i budujemy oraz testujemy aplikację za pomocą skrytpów npm zdefiniowanych pliku packaage.json*
```bash
docker run --rm -it node /bin/bash
apt-get update && apt-get install git
git clone https://github.com/devenes/node-js-dummy-test.git
cd node-js-dummy-test/
npm install
npm run test
```
<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/4a744199-06f9-45be-b72a-ece99fd873df" width="300" height="400" />
</p>
<p align="center">
<i>Budowa i testowanie w kontenerze bez automatyzacji procesu</i>
</p>

- **Automatyzacja powyższego procesu**
<br></br>
Główną ideą automatyzacji tego procesu jest stworzenie kontenerów, które wykonają budowę i testowanie aplikacji, i jeśli operacje te zakończą się sukcesem zwrócą kod `exit 0`. W ten sposób stworzymy podstawę do automatyzacji całego procesu `CI`. W takim zbudowanym kontenerze znajduje się katalog ze zbudowanym rozwiązaniem, które następnie będzie można "wydostać" w celu wdrożenie go na środowisku produkcyjnym. W naszym wypdaku aplikacja ta może zostać odpalona ostatecznie w kontenerze dlatego tworzymy plik `node-deploy.Dockerfile`, który umożliwia uruchomienie zbudowanej i przetestowanej aplikacji.

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/181cd4cf-91d7-46aa-8ee8-ceeb5391e670" />
</p>
<p align="center">
<i>Pliki node-builder.Dockerfile, node-tester.Dockerfile oraz node-deploy.Dockerfile</i>
</p>

***Uwaga, kontener do deploymentu powinien eliminować wszystkie zależności deweloperskie i dostarczać tylko pliki wykonawcze, środowsiko uruchomieniowe i konieczne zależności i konfigurację. Takie ograniczenie znacznie zmniejsza rozmiar końcowego obrazu, ale przede wszystkim zapewnia większe bezpieczeństwo i stabilność aplikacji (wykluczamy dodatkowe zależności, które z czasem mogą stać się przestarzałe i niewspierane i stanowić potencjalne źródło awarii lub ataku). Powyższy dockerfile nie spełnia tych zasad, jest tylko przykładem uruchomienia aplikacji w kontenerze***
<br></br>
- **Sprawdzenie poprawności wykonania**
  <br></br>

  W celu przeprowadzenia zbudowania i przetestowania uruchamiamy obydwa kontenery ze zbudowanych wczesniej obrazów. Podstawowym sprawdzeniem poprawności ich działania może być sprawdzenie z jakim kodem się zakończyły. Kod `exit 0` sugeruje, że budowa takiego kontenera przebiegła poprawnie.
  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/c8890e2a-5ba2-4a18-81b4-987e66ca7c67" width="350" height="100" />
  </p>
  
  Jeśli chcemy dokładnie sprawdzić poprawność działania, zawsze istnieje możliwość uruchomienia takiego kontenera ze zbudowaną aplikacją, z własnym `entrypoint'em` , którym jest powłoka systemowa, i uruchomienie takiej aplikacji. Może to być wykonane za pomocą polecenia:
  ```
  docker run <image_id> /bin/bash
  ```
  Lub poprzez zbudowanie kontenera z obrazu `node-deploy.Dockerfile`

- **Aplikacja wykorzystująca meson i ninja jako środowisko do budowania i testowania**

  Analogicznie do poprzedniej aplikacji uruchamiamy ją w kontenerze. W tym przypadku jednak aplikacja jest napisana w C, dlatego jej środowiskiem uruchomieniowym będzie `Fedora`. Po uruchomieniu kontenera instalujemy podstawowe zależności takie jak kompilator, builder i git. Niestety w przypadku bardziej skomplikowanej aplikacji nie zawsze będziemy znali wszystkie dodatkowe zależności dlatego po sklonowaniu repozytorium uruchamiamy buildera i na podstawie wyników jego działania instalujemy wszystkie dodatkowe zależności.

  ```bash
  docker run --rm -it fedora
  dnf -y update && dnf -y install git meson ninja* gcc
  git clone https://github.com/irssi/irssi
  cd irssi
  meson Build
  ```
  <br></br>
  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/f86caa56-9758-4d02-99c5-40aac1079e0f" width="550" height="200"/>
  </p>

  Działanie skrytpu budującego pokazało brak zależności `glib-2.0`. W komunikacje znajduje się jednak informacja o konieczności zainstalowania rozszerzonej wersji tej biblioteki `glib2-devel` do celów deweloperskich dla systemów `RHEL`, czyli również `Fedory`, która działa w naszym kontenerze. Po zainstalowaniu ponownie uruchamiamiamy skrypt budujący.

  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/f342bac0-6210-41e7-9a63-6d4a8774e88b" width="700" height="180"/>
  </p>

  Skrypt budujący przekazał informację o wszystkich brakujących zależnościach. Teraz po ich dodaniu budowa projektu powinna zakończyć się sukcesem. W związku z tym instalujemy zależności, a kolejno zgodnie z komunikatem skryptu budującego wywołujemy polecenie `ninja -C /irssi/Build` aby zbudować aplikację
  ```bash
  dnf -y install glib2-devel utf8proc* ncurses* perl-Ext*
  meson Build
  ninja -C /irssi/Build
  ```

  W tym momencie budowa aplikacji zostaje poprawnie zakończona, i zbudowany zostaje katalog Build:
  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/10ace330-ba0c-468b-aca2-fb9f8aa6a8e4" width="900" height="160"/>
  </p>

- **Automatyzacja powyższego procesu**

  Automatyzacja procesu budowy i testowania przebiega analogicznie jak wcześniej, poniżej umieszczam pliki `Dokcerfile` odpowiedzialne za wykonanie wszystkich wcześniejszych czynności, które umożliwiły nam poprawne zbudowanie kontenera

  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/ce4946d7-c41d-4058-b061-f1511e62111c"/>
  </p>

  Po uruchomieniu kontenerów sprawdzamy ich kod wyjścia:
  <p align="center">
    <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/bea54978-d3fa-471f-b345-9a321018e897"/>
  </p>

# "Wyciąganie" zbudowanej aplikacji z konenera do budowania

Po poprawnym zbudowaniu i przetestowaniu aplikacji konieczne jest pozyskanie zbudowanej aplikacji, aby umożliwić jej wdrożenie. Można zrobić to na kilka sposobów.

**1. Uruchomienie kontenera**
<br>
Pierwszą opcją jest uruchomienie kontenera. Jednak, aby to zrobić musimy uruchomić w kontenerze jakiś proces, ponieważ definicja obrazu, z którego ten kontener powstał zakłada, że po zbudowaniu kontenera (czyli zbudowaniu aplikacji) natychmiast się zamyka. W związku z tym możemy przekazać podczas uruchomienia własny entrypoint np. `sleep`, po czym za pomocą polecenia `docker cp` skopiować odpowiednie pliki we wskazane miejsce, a następnie zamknąć kontener. Ciąg poleceń umożliwiających takie działanie:
```bash
docker run <image> sleep <seconds>
docker cp <container_name>:</path_in_container/build>  </host_path>
docker stop <container_name> //albo poczekać na zakończenie sleep
```
<br></br>
<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/c3e41c8f-f272-4947-b0ca-0ff79ac48505" width="800" height="200"/>
</p>
<p align="center">
  <i>Poprawne skopiowanie katalogu Build z kontenera na hosta</i>
</p>

**2. Skopiowanie pliku z maszyny wirtualnej dockera**
<br>
Docker jako uruchomiony na hoście proces zapisuje wszystkie swoje dane. W związku z tym istnieje możliwość odszukania danych danego kontenera w plikach zapisywanych przez dockera i skopiowanie z tamtąd odpowiednich plików
<br></br>
<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/33088eb1-a5e3-4cf4-9bd0-82a949335a6a" width="700" height="200"/>
</p>
<p align="center">
  <i>Znalezione pliki zapisane przez proces dockera w /var/lib/docker/overlay2 </i>
</p>

**(?)3. Zamontowanie wolumenu do kontenera podczas jego tworzenia**
<br>
Ostatnia możliwość to zamontowanie wolumenu w taki sposób, aby dokcer sam skopiował ten plik w odpowiednie miejsce. Można to zrobić na kilka sposobów. Najłatwiejszym z nich jest zamontowanie wolumenu podczas uruchamiania kontenera za pomocą polecenia:

```docker
docker run -v ./Build:/irssi/Build/ irssi-builder:0.1
// -v <path_on_host>:<path_in_container> 
```

***Uwaga, polecenie to powoduje, że na lokalnym hoście powstaje katalog ale dane z katalogu z kontenere nie są przepisywane. Dlaczego ?***


# Docker Compose

Aby wdrażać kontenery automatycznie możemy stowrzyć dla `Docker compose`, kótry będzie definiował sposób tworzenie kontenerów. Przykładowy plik `docker-compose.yml` dla budowania kontenerów do budowania i testowania dla aplikacji `irssi` wygląda następująco:
```docker-compose
services:
  irssi-build:
    build:
      context: .
      dockerfile: irssi-build.Dockerfile
    image: irssi-build:0.1
    container_name: irssi-build

    restart: 'no'

  irssi-test:
    build:
      context: .
      dockerfile: irssi-test.Dockerfile
    image: irssi-test:0.1
    container_name: irssi-test

    depends_on:
      - irssi-build
    restart: 'no'
```

Abu uruchomić ten plik potrzebujemy pobrać rozszerzenie do dockera `dnf install docker-compose`. Po poprawnym pobraniu możemy wykonać operację:
```
docker-compose up
```
<br>
<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/a802ff48-78b1-4a44-a54e-552b9cc2314f" width="800" height="160"/>
</p>
<p align="center"><i>Wynik budowy kontenerów za pomocą docker-compose</i></p>

# Zachowywanie stanu

Na stan danej aplikacji, a zatem również takiej działającej w kontenerze składa się kilka rzeczy, m.in. są to:
- ENV, czyli zmienne środowsikowe,
- pliki konfiguracyjne
- dane z bazy danych
- pliki tymczasowe, wygenerowane w trakcie działania aplikacji
- RAM
- pamięć cache

W momencie zamknięcia kontenera ważne jest, aby część z tych danych przechowywać, w zależności od tego jaki cel chcemy osiągnąć. Bardzo ważne jest zapisywanie w wolumenie (specjalny mechanizm dockera, który umożliwia zapiswanie danych w pamięci lokalnej, co umożliwia ich dostarczanie do uruchamianego kontenera oraz ich zachowywanie z zamykanego kontenera) danych z bazy danych. Natomiast w celu zachowania pełnego stanu aplikacji, co umożliwiłoby nam błyskawiczne odtworzenie kontenera, musimy zachować wszystkie z powyższych oprócz plików tymczasowych (oraz ew. cache, który zostanie pobrany ponownie, ale spowolni przywracanie stanu aplikacji).
<br></br>
W związku z tym w celu realizacji tej części sprawozdania, zbudujemy kontener do budowania aplikacji `irssi`, ale w taki sposób, że dostarczymy do niego kod źródłowy, po czym zbudowny katalog `Build` zapiszemy w wolumenie "wyjściowym". Umożliwi nam to wyizolowanie danych aplikacji koniecznych do jej prawidłowego uruchomienia do osobnych wolumenów (konieczne będzie tylko doinstalowanie zależności w kontenerze docelowym).

**1. Tworzymy potrzebne wolumeny**
<br>
Potrzebujemy łącznie dwóch wolumenów. W `irssi_src` zapiszemy sklonowane repozytorium projektu, natomiast w `irssi_Build` zapiszemy z kontenera docelowego zbudowaną aplikację.
```bash
docker volume create irssi_src
docker volume create irssi_Build
```

**2. Kontener pomocniczy**
<br>
W celu sklonowania projektu i zapisania zależności tworzymy pomocniczy kontener w któym realizujemy te działania. Aby zamontować dany wolumen do kontenera używamy polecenia `--mount source=<volume>,destination=<path_in_container>` (można użyć uproszczonej składni: `-v <volume>:<path_in_container>`)

```bash
docker run --rm -it --mount source=irssi_src,destination=/irssi fedora bash
```

Po utworzeniu kontenera klonujemy repozytorium na ścieżkę `/` (nadpisuje to nasz istniejący katalog irssi zapisując tam repozytorium) oraz instalujemy wszystkie zależności zgodnie z wcześniejszymi instrukcjami dla tej aplikacji:

```bash
dnf -y update && dnf -y install git //git dostepny w obrazie Fedora39
git clone https://github.com/irssi/irssi
```

Po zakończeniu procesu, dla upewnienia się, ponownie uruchamiamy taki sam kontener i sprawdzamy czy wszystko się zgadza:

<p align="center">
  <image src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/018e092f-72b5-45bc-b8eb-f9e261c069a5" width="900"></image>
</p>

**3. Budowanie w docelowym kontenerze**

Ostatnim etapem jest uruchomienie kontenera z podpiętymi wszystkimi stworzonymi wolumenami i zbudowanie aplikacji na podstawie dostarczonych plików źródłowych i po pobraniu zależności. Wynikowy katalog ze zbudowaną aplikacją umieszczamy w wolumenie `irssi_Build`.
<br>
```bash
//uruchamiamy kontener
docker run --rm -it --mount source=irssi_src,destination=/irssi --mount source=irssi_Build,destination=/irssi/Build fedora bash

//instalujemy wszystkie potrzebne zależności
dnf -y update && dnf -y install meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

//przechodzimy do katalogu projektu i budujemy go
cd irssi
meson Build
ninja -C irssi/Build
```

<p align="center">
  <image src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/b927639b-5ee0-4a06-92b0-4beb66c5c382" height="350" width="550"></image>
</p>


**4. Przeniesienie procesu do Dockerfile**
<br>
Korzystając z opcji `RUN --mount=type=cache` można podczas budowania obrazu zamontować do niego cache, który będzie przechowywany pomiędzy kolejnymi budowaniami obrazu (chyba że nastąpi ingerencja do warstwy obrazu w której budujemy ten cache, co spowoduje jego ponowne zbudowanie). Opcja `RUN --mount=type=bind` pozwoli natomiast "zainstalować" katalog z hosta ze sklonowanym repozytorium (lub można bezpośrednio sklonować repozytorium w obrazie) oraz dodając do niego opcję `rw`, umożliwimy zapis w katalogu nowego katalogu z plikami wynikowymi pod ścieżką `irssi/Build`. Przykładowy `dockerfile` realizujący takie działanie może wyglądać następująco:

```Dockerfile
FROM fedora:39

RUN --mount=type=cache,target=/var/cache/dnf \
 dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

# 1 opcja (pobieramy repozytorium)
#RUN git clone https://github.com/irssi/irssi

# 2 opcja (bindujemy wolumen z istniejącym repozytorium na hoscie)
# opcja rw - read/write, ENV musi zostac podany jako parametr przy budowaniu
ARG HOME=$HOME

RUN mkdir -p /irssi
RUN --mount=type=bind,source=$HOME/irssi,target=/irssi,rw

WORKDIR /irssi

RUN meson Build && ninja -C /irssi/Build
```

Podczas budowy obrazu podajemy argument `--build-arg`, który jest ścieżką do katalogu z kodem źródłowym aplikacji
```
docker build --build-arg HOME=$HOME -t irssi-build-v:0.1 -f irssi-build-volume.Dockerfile .
```

# Eksponowanie portu

Iperf3 to program pozwalający na pomiar szybkości połączenia pomiędzy klientem a serwerem. Za jego pomocą w tej części będziemy sprawdzać szybkość połączenia pomiędzy kontenerami oraz hostem i kontenerm. Program ten pobieramy na dystrybucję `Fedora39` za pomoca `dnf install iperf3`. Uruchomienie programu jako serwera wykonuje się za pomocą polecenia `iperf -s`, natomiast jako klienta `iperf -c <IP_ADDR>`

**1. Połączenie kontenerów domyślną siecią Dockera**

Obraz sieci w moim przypadku wygląda następująco. Mój host ma adres `192.168.0.100/24`. Maszyna wirtualna, na której pracuję ma adres z tej samej podsieci `192.168.0.104` co umożliwia jej komunikację z hostem. `Docker` odpalany na maszynie jest dodatkowo wirtualizowany, wieć ostatecznie proces `dockerd` odpala się na specjalnym wirtualizatorze konfigurowanym przez dockera. Wraz z nim tworzona jest nowa podsieć, na naszej maszynie wirtualnej, która umozliwia komuniację pomiędzy `VM`, a `dockerem`. Adres ten ma postać `172.17.0.1/16`. W momencie tworzenia kontenerów z domyślnymi ustawieniami sieci (nie zdefiniowanymi), docker przydziela im kolejne adresy z własnej podsieci, dlatego jak pokazane na 2 screen'ie, adres pierwszego utworzonego kontenera to `172.17.0.2`. Taka konfiguracja umożliwia połączenie pomiędzy dowolnymi tworzonymi w tej domyślnej podsieci kontenerami. 

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/bdfe7cdb-75e7-4551-95cd-41eb5638440b"  width="800" height="250"/>
</p>
<p align="center"><i>Omawiane powyżej adresy VM i dockera</i></p>

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/a3f83e7f-64bf-407c-8558-968deba0387b"  width="800" height="300"/>
</p>
<p align="center"><i>Sprawdzenie sieci domyślnej utworzonej przez dockera dla kontenera służącego jako serwer dla iperf3</i></p>

Za pomocą programu `iperf3` testujemy szybkość połączenia pomiędzy 2 kontenerami utworzonymi w domyślnej sieci:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/c2a513d7-e79c-47ed-bfd5-6d5791c12581"/>
</p>
<p align="center"><i>Wyniki połączenia</i></p>

**2. Połączenie kontenerów stworzoną dedykowaną siecią mostkową**

Sieć dedykowaną tworzymy za pomocą polecenia:

```
docker network create -d bridge my_net
```

Takie utworzenie nowej sieci możemy sprawdzić analogicznie jak poprzednio, poprzez inspekcję sieci. Zanim to robimy tworzymy dodatkowo dwa kontenery podłączone do tej sieci:

```docker
docker run --rm -it --network my_net --name serwer fedora bash
docker run --rm -it --network my_net --name client fedora bash
```

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/b7ae0445-0201-4581-a7d5-b597773f7ada" width="700" height="500"/>
</p>
<p align="center"><i>docker network inspect my_net</i></p>

Jak widać powyżej, docker network inspect my_net ukazuje powstanie nowej podsieci `172.19.0.0/16` oraz dodane do niej 2 adresy nowo utworzonych kontenerów. Przeprowadzamy pomiar szybkości analogicznie jak poprzednio i otrzymujemy następujące wyniki:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/c9bcd44f-12be-408e-b402-9cdd265d6dc7" width="600" height="400"/>
</p>

***UWAGA ! Dzięki utworzeniu nowej sieci i połączeniu z nią kontenrów, możemy odwoływać się wzajemnie do kontenerów po nazwie a nie adresie - Docker tworzy i konfiguruje za nas DNS***

**3. Połączenie kontenera z hostem**

Uruchamiamy kontener z opcją przekierowywania portów. Umożliwi to na przesyłanie pakietów do kontenera - serwera `iperf` w momencie jeśli z hosta wyślemy takie pakiety na adres maszyny wirtualnej na której działa docker, na odpowiedni port. Dzieje się tak dlatego, że kierujemy komunikację na adres w podsieci porta -> maszynę wirtualną, a ona wewnętrznie ma skonfigurowane połączenie z podsiecią dockera.

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/77264dc9-1c59-4c82-8398-296b5cd83234" width="700" height="400"/>
</p>

**4.Wyciąganie log'ów z kontenera**

Aby sprawdzić problemy z komunikacją w przypadku ich wystąpienia możemy posłużyć się logami rejestrowanymi przez program iperf3. Takie działanie umozliwia polecenie:

```
docker logs <container_name>
```

Innym sposobem jest zamonotwanie wolumenu w taki sposób aby logi były zapisywane na nim. Można to zrobić uruchamiając kontener z programem iperf, którego wyniki działania zapiszemy do pliku zlokalizowanego na zamontowanym wolumenie. Jednak nie możemy uruchomić wtedy bezpośrednio kontenera z obrazu programu iperf, (nie ma konsoli ani innych poleceń systemowych do zapisu) tylko musimy uruchomić iperf3 na obrazie jakiegoś systemu.

```
docker run --rm -it --name serwer -p 5201:5201 -v serwer_logs:/logs fedora bash -c "sudo dnf -y update && sudo dnf -y install iperf3 && iperf3 -s > /logs/iperf3.log"
```

Po poprawnym połączeniu z serwerem, zamykamy go, a następnie uruchamiamy nowy kontener z dołączonym wolumenem `serwer_logs` i sprawdzamy czy logi serwera zostały poprawnie zapisane:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/991176ea-3e49-4046-8630-2d16ec4e91cb" width="700" height="400"/>
</p>

<br></br>
**5.Podsumowanie szybkości połączeń**
<br></br>

<table align="center">
    <tr>
        <th>Rodzaj Połączenia</th>
        <th>Bitrate</th>
    </tr>
    <tr>
        <td>Połączenie kontenerów domyślną siecią Dockera</td>
        <td>5.65 Gbits/sec</td>
    </tr>
    <tr>
        <td>Połączenie kontenerów stworzoną dedykowaną siecią mostkową</td>
        <td>30.2 Gbits/sec</td>
    </tr>
    <tr>
        <td>Połączenie kontenera z hostem</td>
        <td>618 Mbits/sec</td>
    </tr>
</table>

# Instancja Jenskins

Zgodnie z instrukcjami na stronie [https://www.jenkins.io/doc/book/installing/docker/](https://www.jenkins.io/doc/book/installing/docker/), tworzymy sieć dla `jenkinsa`:

> ```
> docker network create jenkins
> ```

Nastepnie przeprowadzamy instalację skonteneryzowanej instancji `Jenkinsa` z pomocnikim `DIND`

>```docker
>docker run \
>  --name jenkins-docker \
>  --rm \
>  --detach \
>  --privileged \
>  --network jenkins \
>  --network-alias docker \
>  --env DOCKER_TLS_CERTDIR=/certs \
>  --volume jenkins-docker-certs:/certs/client \
>  --volume jenkins-data:/var/jenkins_home \
>  --publish 2376:2376 \
>  docker:dind \
>  --storage-driver overlay2
>```

Kolejno zgodnie z instrukcją tworzymy nowy obraz jenkinsa z dockerem (domyślnie zgodnie z instrukcją) oraz budujemy go:
```
docker build -t myjenkins-blueocean:2.440.2-1 -f jenkins.Dockerfile
```

Uruchamiamy nowy kontener na podstawie zbudowanego obrazu:
>```docker
>docker run \
>  --name jenkins-blueocean \
>  --restart=on-failure \
>  --detach \
>  --network jenkins \
>  --env DOCKER_HOST=tcp://docker:2376 \
>  --env DOCKER_CERT_PATH=/certs/client \
>  --env DOCKER_TLS_VERIFY=1 \
>  --publish 8080:8080 \
>  --publish 50000:50000 \
>  --volume jenkins-data:/var/jenkins_home \
>  --volume jenkins-docker-certs:/certs/client:ro \
>  myjenkins-blueocean:2.440.2-1
>```

Po poprawnej inicjalizacji kontenera otrzymujemy w przeglądarce pod adresem maszyny wirtualnej i portu `8080` klienta jenkins:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/a0c56520-20fa-44aa-9ad6-4a210648ac16" width="700" height="500"/>
</p>

Działające kontenery i sposób dostępu do hasła:
<br></br>
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/469f61c5-5bf2-4056-a730-e5c3718868c8)


















