# Sprawozdanie 2
## Marcin Pigoń
## ITE gr. 4

### Cel: Zapoznanie się z Dockerfile oraz sieciami w Dockerze.

### Lab 3
***
Tworząc programy, często korzystamy z bibliotek oraz frameworków - zależności zewnętrznych, które niekoniecznie muszą być zainstalowane na maszynie klienta. W tym celu stosujemy kontenery Dockera - odizolowane środowiska, w których możemy uruchamiać nasze aplikacje wraz z ich zależnościami, niezależnie od systemu operacyjnego czy konfiguracji maszyny docelowej. Dzięki temu zapewniamy spójność środowiska uruchomieniowego oraz ułatwiamy proces wdrażania aplikacji, eliminując potencjalne problemy związane z różnicami w środowiskach wykonawczych. Jednak, każdorazowa konfiguracja takiego kontenera jest czasochłonna i może być ułatwiona poprzez wykorzystanie narzędzia do definiowania obrazów kontenerowych, takiego jak Dockerfile. Dockerfile to plik tekstowy zawierający instrukcje służące do budowania obrazu kontenera.

W Dockerfile możemy zdefiniować wszystkie kroki niezbędne do skonfigurowania środowiska uruchomieniowego naszej aplikacji. Możemy określić bazowy obraz, instalować zależności, kopiować pliki aplikacji do kontenera, konfigurować zmienne środowiskowe oraz uruchamiać polecenia inicjalizacyjne.

W tym ćwiczeniu należało wykorzystać Dockerfile do automatyzacji procesu tworzenia kontenera. W tym celu wykorzystano dwa repozytoria:
- node-js-dummy-test: https://github.com/devenes/node-js-dummy-test
- irssi: https://github.com/irssi/irssi 

Oba repozytoria zawierały możliwość buildowania oraz przeprowadzania testów; w repozytorium node.js używamy *npm*, a dla irssi *ninja*. 

Przykładowo, chcąc przeprowadzić instalację programu irssi w nowym środowisku, należałoby instalować wszystkie zależności zanim możemy przeprowadzić instalację programu i jego uruchomienie. Lista zależności wygląda następująco: *git meson ninja gcc glib2-devel utf8proc ncurses perl-Ext openssl*. Każdorazowa instalacja ręcznie jest dość uciążliwa, więc możemy napisać prosty plik *irssi-builder.Dockerfile*, który skraca wgrywanie wszystkich zależności do jednej komendy *docker build*. 

W Dockerfile'u korzystamy z różnych poleceń, takich jak:

- FROM: definiuje bazowy obraz, na którym rozwijamy nasz kontener.
- RUN: polecenia, które mają zostać wykonane podczas budowania obrazu.
- WORKDIR: katalog roboczy.
- CMD: domyślna komenda, która ma być uruchomiona w kontenerze, gdy nie podamy innej. 

![alt text](image-1.png)

Warto również zauważyć, że mamy osobne biblioteki developerskie - przykładowo *glib2-devel*, które są wyposażone w dodatkową funkcjonalność w porównaniu co do zwykłej. Dlatego również trzeba uważnie czytać dokumentację programów, żeby nie mieć później problemów z brakującymi zależnościami.

W wyniku polecenia:
*docker build -t irssi-builder -f irssi-builder.Dockerfile .* 
Otrzymujemy obraz z zainstalowanym i zbudowanym programem irssi. Konteneryzacja upraszcza przenoszenie budowania aplikacji do innych maszyn.

W analogiczny sposób zbudowano obraz wykorzystując Dockerfile do wykonywania testów dla tej aplikacji - irssi-tester.Dockerfile:

![alt text](image-3.png)

Używamy RUN zamiast CMD, ponieważ chcemy, żeby testy się wykonały od razu podczas budowania obrazu do testów, a nie podczas jego odpalenia. W dodatku używamy RUN, kiedy nie chcemy pozwolić użytkownikowi na wykonywanie dodatkowych czynności w terminalu (po wykonaniu testów), gdyż może to naruszać na bezpieczeństwo lub konfiguracje kontenera.

Sprawdzam używając 'docker images' powstałe obrazy do budowania i testowania. Na ich podstawie teraz mógłbym uruchomić kontener, ale bez polecenia początkowego kontener od razu się wyłączy. Jednak trzeba się zastanowić nad sensownością tworzenia kontenera dla tego programu - irssi jest systemem chatu IRC (Internet Relay Chat), więc nie jest to często spotykany use-case dla konteneryzacji.

![alt text](image-2.png)

Częściej spotyka się kontenery dla usług sieciowych lub innych backendowych programów. Przykładem jest aplikacja node'owa.

W analogiczny sposób stworzono dockerfile do budowania, testowania oraz deployowania:

node-builder.Dockerfile

![alt text](image-4.png)

![alt text](image-5.png)

node-tester.Dockerfile

![alt text](image-6.png)

![alt text](image-7.png)

node-deployer.Dockerfile

![alt text](image-8.png)

Odpalając dockerfile używając run widzimy aktywację portu - nasz kontener się zbudował z obrazu node-builder a następnie przy uruchomieniu odpalił się z poleceniem npm start.

![alt text](image-9.png)

Sprawdzając odpalone kontenery używając docker ps widzimy odpalony kontener irssi oraz node.

![alt text](image-10.png)

### Lab 4

W Dockerze, "volumes" są używane do trwałego przechowywania danych pomiędzy kontenerami i hostem, umożliwiając separację danych od kontenerów oraz łatwiejsze zarządzanie nimi. Stosuje się je do takich celów jak bazy danych, pliki konfiguracyjne i logi, zapewniając dostępność danych po ponownym uruchomieniu kontenera.

Tworzymy volume za pomocą polecenia docker volume create.

![alt text](image.png)

Następnie sprawdzamy czy poprawnie zostały stworzone woluminy przez ls

![alt text](image-11.png)

Zadanie polegało na sklonowaniu repozytorium za pośrednictwem volumes bez instalacji git'a w kontenerze. 

Osiągnąłem to poprzez stworzenie kontenera pomocniczego, który klonuje repozytorium do woluminu, a nastepnie włączam kontener z woluminem. 

sudo docker run -it --rm --name temp_container --mount source=vol_in,target=/input node bash

Teraz w kontenerze pomocniczym klonuje repozytorium:

![alt text](image-12.png)

Teraz mamy repozytorium w woluminie i możemy utworzyć kontener bazowy z oba woluminami - in i out. Z vol_in mogę skopiować repozytorium do vol_out. 

![alt text](image-13.png)

Buduję program poprzez npm install

![alt text](image-14.png)

Poleceniem cp (copy) mogę przenieść zbudowany program do woluminu wyjściowego

![alt text](image-15.png)
![alt text](image-16.png)

Można spróbować użyć polecenia VOLUME w Dockerfile'u do utworzenia woluminu, przykładowo polecenie to mogłoby wyglądać:

![alt text](image-18.png)

Niestety jednak nie tworzy to woluminy jak przy volume create. 

![alt text](image-19.png)

Inną możliwością jest uruchomieniem dockerfile'a z poleceniem RUN --mount i dołączeniem odpowiednich woluminów.

Kolejne zadanie polegało na zbudowaniu 