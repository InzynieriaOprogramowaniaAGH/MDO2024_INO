# Sprawozdanie 2 - Konrad Rezler
## Zajęcia 03
## Dockerfiles, kontener jako definicja etapu
### Wybór oprogramowania na zajęcia
Aby wykonać automatyzację procesu tworzenia kontenera, wykorzystując Dockerfile, skorzystałem z następujących repozytoriów:
- irssi: https://github.com/irssi/irssi
- node-js-dummy-test: https://github.com/devenes/node-js-dummy-test

Warto zaznaczyć, że powyższe repozytoria zostały wybrane ze względu na możliwość buildowania oraz przeprowadzania na nich testów.

W związku z powyższym utworzyłem nowy katalog dla repozytorium "node-js-dummy-test" oraz skopiowałem do niego repozytorium 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/1. klonowanie repo.png">
</p>

Następnie doinstalowałem wymagane zależności
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/2. doinstaluj wymagane zaleznosci.png">
</p>

Później przeprowadziłem build programu
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/3.1. instalacja zaleznosci.png">
</p>

oraz uruchomiłem testy jednostkowe
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/3.1.1 testy jednostkowe.png">
</p>

### Przeprowadzenie buildu w kontenerze

Najpierw pobrałem obraz dla Node'a.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/4. pobranie obrazu node'a.png">
</p>

Następnie wszedłem z nim w tryb interaktywny
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/5. przejscie w tryb interaktywny.png">
</p>

oraz będąc w tym trybie sklonowałem do niego repozytorium.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/6. klonowanie repozytorium do kontenera w trybie interaktywny.png">

Później przeprowadziłem build oraz testy jednostkowe.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/7. isntalacje zaleznosci i testy jednostkowe.png">
</p>

Identyczne kroki jak powyżej przeprowadziłem dla repozytorium "Irssi", najpierw pobrałem obraz fedory
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/8. pobranie obrazu fedora.png">
</p>

następnie wszedłem w tryb interaktywny i pobrałem na nim gita
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/9. uruchomienie kontenera w trybie interaktywnym i pobranie gita.png">
</p>

oraz sklonowałem do niego repozytorium.
 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/10. pobranie gita i pobranie zaleznosci.png">
</p>

Jendakże zanim mogłem przeprowadzić build musiałem doinstalować następujące zależności:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/11. kolejne pobranie zaleznosci.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/12. kolejne zaleznosci.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/13. jeszcze kolejne zaleznosci.png">
</p>

Dzięki czemu mogłem przeprowadzić build
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/14. build programu.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/15. message do builda.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/16. build ciag dalszy.png">
</p>

oraz uruchomić unit testy.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/17. unit testy.png">
</p>

### Automatyzacja procesu - stworzenie plików dockerfile

W katalogu, w którym zamieszczone jest to sprawozdanie, stworzyłem folder "Dockerfiles" oraz dla wymienionych na początku repozytoriów utworzyłem katalog "node" oraz "irssi" i w kazdym z nich stworzyłem katalog "build" oraz "test", aby móc w nich utworzyć odpowiednie dla realizacji zajęć pliki dockerfile.

W katalogu "(..)/Sprawozdanie2/Dockerfiles/node/build" zamieściłem następującą treść w pliku dockerfile:
```
FROM node:latest as build-image

RUN git clone https://github.com/devenes/node-js-dummy-test

WORKDIR /node-js-dummy-test/ 

RUN npm install 
```

oraz przeprowadziłem przy jego pomocy build
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/18. tworzenie obrazu z dockerfila.png">
</p>

Następnie w katalogu "(..)/Sprawozdanie2/Dockerfiles/node/test" zamieściłem następującą treść w pliku dockerfile
```
FROM build-image 

CMD npm test
```

później przy jego pomocy zbudowałem obraz
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/20. budowa obrazu.png">
</p>

oraz uruchomiłem testy jednostkowe przy pomocy kontenera.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/21. uruchomienie kontenera.png">
</p>

Identyczne kroki poczyniłem dla repozytorium "Irssi".

Zacząłem od umieszczenia w pliku Dockerfile, znajdującym się w odpowednim katalogu, następującej treści
```
FROM fedora:latest as fedora-build-image

RUN dnf install -y git && \
git clone https://github.com/irssi/irssi

WORKDIR /irssi 

RUN dnf install -y meson ninja* gcc  glib2-devel utf8proc* ncurses* perl-Ext*

RUN meson build && \
ninja -C ./build
```

następnie zbudowałem dzięki temu plikowi obraz.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/22. Zbudowanie obraz.png">
</p>

Później stworzyłem plik Dockerfile w folderze do testowania i zamieściłem w nim następującą treść
```
FROM fedora-build-image

WORKDIR /irssi/build

CMD ninja test
```

oraz zbudowałem ten obraz.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/23. budowa obrazu do testowania.png">
</p>

Wykonane przeze mnie działania pozwoliły mi na stworzenie kontenerów, które wdrażają się i pracują poprawnie, o czym mogą świadczyć zakończone z sukcesem testy jednostkowe:
- dla "Node'a"
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/24. wykaz ze wdraza i pracuje.png">
</p>

- dla "Irssi"
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/25. wykaz ze wdraza i pracuje.png">
</p>

## Zajęcia 04
## Dodatkowa terminologia w konteneryzacji, instancja Jenkins
### Zachowywanie stanu

Aby zrealizować zajęcia należało skorzystać z woluminów, które są wykorzystywane w dockerze do izolacji i uruchamiania aplikacji w kontenerach. Woluminy w Dockerze są używane do przechowywania danych, dzięki czemu aplikacje mogą być przenoszone między różnymi środowiskami bez utraty danych oraz zapewniają elastyczność i skalowalność w zarządzaniu zasobami.

W związku z powyższym przygotowałem wolumin wejściowy i wyjściowy
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/1. Tworzenie woluminów.png">
</p>

oraz podłączyłem je do bazowego, z którego rozpoczynałem poprzednio pracę.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/2. podłącz je do kontenera bazowego, z którego rozpoczynano poprzednio pracę.png">
</p>

Następnie należało sklonować repozytorium na wolumin wejściowy.

Zacząłem od stworzenia nowego folderu oraz skopiowania do niego pożądanego repozytorium
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/3. stworzylem nowy folder i tam skopiowalem repo.png">
</p>

dzięki czemu następnie sklonowałem repozytorium na wolumin wejściowy.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/4. Sklonuj repozytorium na wolumin wejściowy.png">
</p>
Powyższa komenda kopiuje pliki z lokalnego kontenera o nazwie "node-js-dummy-test" do ścieżki "/app" w kontenerze o nazwie "lab4".

Później przeszedlem do kontenera i otworzylem katalog z zainstalowanym repozytorium, dzięki czemu uruchomiłem instalację zależności i uruchomiłem build w kontenerze.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/5. przeszedlem do kontenera i otworzylem katalog z zainstalowanym repo i uruchomilem instalacje zaleznosci.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/6. Uruchom build w kontenerzei.png">
</p>

Wracając do katalogu ":/app" zapisałem pliki na woluminie wyjściowym, tak by były dostępne po wyłączeniu kontenera.

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/7. zapisz powstałe-zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera..png">
</p>

Aby udowodnić powodzenie wykonanych przeze mnie akcji wyszukałem ścieżkę do wolumina wyjściowego, a następnie wyświetliłem jego zawartość.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/8. szukanie sciezki do wolumena wyjsciowego.png">
</p>

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/9. dowod przeniesienia.png">
</p>

### Eksponowanie portu

Eksponowanie portu z użyciem iperf3 umożliwia otwarcie określonego portu na hoście, na którym działa iperf3, aby umożliwić komunikację z innymi urządzeniami. Dzięki temu inne urządzenia mogą łączyć się z iperf3 poprzez ten port i wykonywać testy przepustowości sieci, mierzyć opóźnienia lub przeprowadzać inne diagnozy sieciowe.

Pracę nad tym etapem zajęć rozpocząłem od pobrania obrazu iperf3 i następnym uruchomieniu wewnątrz kontenera serwera iperf3.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/10. Pobranie obrazu.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/11. Uruchom wewnątrz kontenera serwer iperf.png">
</p>

Powyższa komenda uruchamia kontener Dockerowy z iperf3, eksponując port 5201 na hoście oraz uruchamia serwer iperf3 w trybie verbose, czyli zwiększającym szczegółowość informacji wyświetlanych przez program lub polecenie.

Aby wydobyć te informacje uruchomiłem kolejny terminal, gdzie wyszukałem id kontenera, a następnie połączyłem się z nim, aby zbadać ruch
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/12. sprawdzanie adresu ip kontenera.png">
</p>

- widok ze strony klienta:

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/13. Połącz się z nim z drugiego kontenera, zbadaj ruch - klient.png">
</p>

- widok ze strony serwera:

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/13. Połącz się z nim z drugiego kontenera, zbadaj ruch - serwer.png">
</p>

Następnie ponowiłem wyżej wykonane przeze mnie kroki, jednakże tym razem wykorzystując własną dedykowaną sieć mostkową. Warto zaznaczyć, że podczas tworzenia sieci w dockerze sieć mostkowa jest siecią domyślną:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/14. utworzenie sieci typu bridge (jest domyslna).png">
</p>

Później utworzyłem kontener w sieci, po czym wyszukałem adres IP sieci.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/15. Utworzenie kontenera w sieci.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/16. komenda do wypisania adresu  IP utworzenie sieci.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/17. znaleziony adres.png">
</p>

Wykorzystując sieć mostkową zbadałem ruch:

- widok ze strony klienta:

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/18. klient - moja siec.png">
</p>

- widok ze strony serwera:

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/19. serwer - moja siec.png">
</p>

Do zbadania ruchu spróbowałem też użyć rozwiązywania nazw:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/20. próba użycia rozwiązywania nazw.png">
</p>

Następnie przeszedłem do połączenia z serwerem iperf3 spoza kontenera, w tym celu na mojej maszynie wirtualnej zainstałowałem iperf3
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/21. instalacja iperfa.png">
</p>

oraz połączyem się z hosta.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/22. polacz sie spoza kontenera z hosta.png">
</p>

Ostatecznie wyciągnąłem log z kontenera, aby móc przedstawić przepustowość komunikacji 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/23. zapisanie logów z serwera.png">
</p>

### Instancja Jenkins

Jenkins to popularne narzędzie do ciągłej integracji i dostarczania (CI/CD), umożliwiające automatyzację procesów budowania, testowania i wdrażania oprogramowania w sposób zautomatyzowany i powtarzalny.

Aby przystąpić do jego instalacji wykonałem ciąg następujących komend:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/24. instalacja jenkinsa 1.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/25. zbudowania dockerfila nowoutworoznego.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/26. kolejna losowa komendra.png">
</p>

Dzięki powyższym akcjom mogłem odblokować Jenkins przechodząc do strony: `https://localhost:8080/`, która wyświetlała następującą zawartość:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/27. unlock jenkins.png">
</p>

Aby uzyskać hasło admninistratora skopiowałem wyniki komendy `sudo ls /var/jenkins_home/secrets/initialAdminPassword`, po czym przeszedłem do instalacji.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/28. instalacja .png">
</p>

Nastepnie zostałem przekierowany do ekranu logowania, gdzie po utworzeniu konta Jenkins był już gotowy do użytku.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/29. ekran logowania .png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/30. Po utworzeniu konta.png">
</p>
 
