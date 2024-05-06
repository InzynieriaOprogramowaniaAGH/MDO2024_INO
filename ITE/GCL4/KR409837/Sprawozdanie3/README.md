# Sprawozdanie 3 - Konrad Rezler
## Pipeline, Jenkins, izolacja etapów
### Wstęp i  opracowanie diagramów

Pipeline to zautomatyzowany proces dostarczania oprogramowania, który obejmuje etapy od tworzenia kodu przez testowanie i budowanie aż po wdrażanie i monitorowanie aplikacji, zapewniając szybkie i powtarzalne wdrożenia przy minimalnym ryzyku błędów. Dzięki pipeline deweloperzy mogą efektywnie integrować, testować i wdrażać zmiany, co przyspiesza cykle dostarczania oprogramowania i poprawia jakość produktu

Jenkins to popularne otwartoźródłowe narzędzie do automatyzacji procesów CI/CD (continuous integration and continuous delivery), umożliwiające tworzenie i zarządzanie pipeline'ami dostarczania oprogramowania poprzez integrację z różnymi narzędziami deweloperskimi i środowiskami chmurowymi, co pomaga zautomatyzować budowanie, testowanie i wdrażanie aplikacji. Dzięki swojej elastyczności i ogromnej społeczności użytkowników Jenkins jest powszechnie wykorzystywany do ułatwienia iteracyjnego procesu dostarczania oprogramowania i przyspieszenia cykli wdrożeń.

Wybór repozytorium dla którego nastąpiła izolacja procesów padł na wykorzystywane we wcześniejszych zajęciach Irssi. Wspomniana aplikacja zawiera licencję "GNU GENERAL PUBLIC LICENSE Version 2, June 1991" potwierdzającą możliwość swobodnego obrotu kodem.

Na potrzeby wizualizacji wykonanych przeze mnie działań wykonałem następujące diagramy:
- Diagram wdrożenia:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/Diagram wdrożenia.png">
</p>

- Diagram komunikacji:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/Diagram komunikacji.png">
</p>

### Przygotowanie
Korzystając z dockerfiles stworzonych na poprzednich zajęciach upewniłem się, że na pewno działają kontenery budujące i testujące:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/0.1. Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach.png">
</p>

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/0.2. Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach.png">
</p>

Następnie korzystając z instrukcji zamieszczonej w dokumentacji Jenkinsa uruchomiłem obraz dockera eksponujący środowisko zagnieżdzone:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/1. Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone.png">
</p>

Korzystając z kontenera wykonanego w ramach poprzedniego sprawozdania uruchomiłem `Blueocean`, czyli zestaw wtyczek dla Jenkinsa, które oferują nowoczesny interfejs użytkownika zorientowany na zadania, wizualizację pipeline'ów oraz dodatkowe narzędzia do zarządzania procesem CI/CD. Jest to bardziej intuicyjne i przyjazne dla użytkownika narzędzie w porównaniu z podstawowym interfejsem Jenkinsa. Obraz Jenkinsa to natomiast podstawowa instalacja Jenkinsa dostępna w formie gotowego do użycia obrazu, który można uruchomić na kontenerze Docker lub serwerze.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/3. Uruchom Blueocean.png">
</p>

### Uruchomienie
W celu realizacji zajęć utworzyłem moje dwa pierwsze proste projekty:
- Pierwszy projekt wyświetla uname
  - polecenie projektu:
    ```
     uname -a
    ```
  - wyświetlany rezultat:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/5. uruchomienie projektu.png">
</p>

- Drugi projekt w zależności od tego czy godzina jest parzysta lub nieparzysta zwraca odpowiedni wynik
  - polecenie projektu:
    ```
    #!/bin/bash
    godzina=$(date +%H)
    echo $godzina
    if ((godzina % 2 != 0)); then
	    echo "Błąd, niepatrzysta godzina"
     exit 1
    else 
	   echo "parzysta godzina"
     exit 0
    fi
    ```
  - wyświetlane rezultaty dla godziny parzystej i nieparzystej:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/7.1. Zwrócenie sukcesu bo godzina parzysta.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/7.2. Zwrócenie niesukcesu bo godzina nieparzysta.png">
</p>

Następnie przeszedłem do tworzenia "prawdziwego projektu", który: 
- klonuje nasze repozytorium
- przechodzi na osobistą gałąź
- buduje obrazy z dockerfiles.

Aby móc korzystać z wybranego przeze mnie repozytorium dodałęm do projektu odpowiedni credential, w którym zamieściłem jako hasło github token, by móc swobodnie łączyć się z repozytorium
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/8. Dodawanie credentiali do prawdziwego projektu.png">
</p>
Następnie zamieściłem link do repozytorium i określiłem branch:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/9. Ustawienie brancha na projekcie.png">
</p>
Realizowane polecenie prezentuje się następująco:

```
cd ITE/GCL4/KR409837/Sprawozdanie2/Dockerfiles/irssi
docker build -t fedora-build-image -f ./build/Dockerfile .
```

Dzięki powyższym krokom uzyskałem następujący rezultat:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/10. Buduje obrazy z dockefiles.png">
</p>

