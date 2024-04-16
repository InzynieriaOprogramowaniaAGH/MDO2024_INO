# Sprawozdanie 2 - Konrad Rezler
## Zajęcia 03
## Dockerfiles, kontener jako definicja etapu
### Wybór oprogramowania na zajęcia
Aby wykonać automatyzację procesu tworzenia kontenera, wykorzystując Dockerfile, skorzystałem z następujących repozytoriów:
- irssi: https://github.com/irssi/irssi
- node-js-dummy-test: https://github.com/devenes/node-js-dummy-test

Warto zaznaczyć, że powyższe repozytoria zostały wybrane ze względu na możliwość buildowania oraz przeprowadzania na nich testów.

W związku z powyższym utworzyłem nowy katalog dla repozytorium "node-js-dummy-test" oraz skopiowałem dla niego repozytorium 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/1. klonowanie repo.png">
</p>

Nastsępnie doinstalowałem wymagane zależności
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

Najpierw pobrałem obraz dla Node'a
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/4. pobranie obrazu node'a.png">
</p>

Następnie wszedłem z nim w tryb interaktywny
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/5. przejscie w tryb interaktywny.png">
</p>

oraz będąc w tym trybie sklonowałem do niego repozytorium
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/6. klonowanie repozytorium do kontenera w trybie interaktywny.png">

 Później przeprowadziłem build oraz testy jednostkowe
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

oraz sklonowałem do niego repozytorium 
 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/10. pobranie gita i pobranie zaleznosci.png">
</p>

Jendakże zanim mogłem przeprowadzić build musiałem doinstalować następujące zależności
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

oraz uruchomić unit testy
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/17. unit testy.png">
</p>

### Automatyzacja procesu - stworzenie plików dockerfile

W katalogu, w którym zamieszczone jest to sprawozdanie, stworzyłem folder "Dockerfiles" oraz dla wymienionych na początku repozytoriów utworzyłem katalog "node" oraz "irssi" i w kazdym z nich stworzyłem katalog "build" oraz "test", aby móc w nich utworzyć odpowiednie dla realizacji zajęć pliki dockerfile.

W katalogu "(..)/Sprawozdanie2/Dockerfiles/node/build" zamieściłem następującą treść w pliku dockerfile
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

oraz uruchomiłem testy jednostkowe przy pomocy kontenera
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

następnie zbudowałem dzięki temu plikowi obraz
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab3/22. Zbudowanie obraz.png">
</p>

Później stworzyłem plik Dockerfile w folderze do testowania i zamieściłem w nim następującą treść
```
FROM fedora-build-image

WORKDIR /irssi/build

CMD ninja test
```

oraz zbudowałem ten obraz
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

oraz podłączyłem je do bazowego, z którego rozpoczynałem poprzednio pracę 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie2/Lab4/2. podłącz je do kontenera bazowego, z którego rozpoczynano poprzednio pracę.png">
</p>

Następnie należało sklonować repozytorium na wolumin wejściowy

zacząłem od
