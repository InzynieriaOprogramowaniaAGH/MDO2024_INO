# Sprawozdanie 3 - Konrad Rezler
## Pipeline, Jenkins, izolacja etapów
### Opracowanie diagramów

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
