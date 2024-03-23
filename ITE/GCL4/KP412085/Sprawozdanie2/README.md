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
  dnf -y update && i dnf -y install git meson ninja* gcc
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

**3. Zamontowanie wolumenu do kontenera podczas jego tworzenia**
<br>
Ostatnia możliwość to zamontowanie wolumenu w taki sposób, aby dokcer sam skopiował ten plik w odpowiednie miejsce. Można to zrobić na kilka sposobów. Najłatwiejszym z nich jest zamontowanie wolumenu podczas uruchamiania kontenera za pomocą polecenia:

```docker
docker run -v ./Build:/irssi/Build/ irssi-builder:0.1
// -v <path_on_host>:<path_in_container> 
```


# Docker Compose

Aby wdrażać kontenery automatycznie możemy stowrzyć dla `Docker compose`, kótry będzie definiował sposób tworzenie kontenerów.
