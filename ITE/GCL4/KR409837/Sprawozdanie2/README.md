# Sprawozdanie 2 - Konrad Rezler
## Zajęcia 03
## Dockerfiles, kontener jako definicja etapu

Aby wykonać automatyzację procesu tworzenia kontenera, wykorzystując Dockerfile, skorzystałem z następujących repozytoriów:
- irssi: https://github.com/irssi/irssi
- node-js-dummy-test: https://github.com/devenes/node-js-dummy-test
Warto zaznaczyć, że powyższe repozytoria zostały wybrane, ponieważ posiadały możliwość buildowania oraz przeprowadzania testów.

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

