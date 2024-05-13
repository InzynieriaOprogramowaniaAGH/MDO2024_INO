# Sprawozdanie 3
Kinga Kubajewska, Inżynieria Obliczeniowa, GCL2
## Pipeline, Jenkins, izolacja etapów
### Cel ćwiczenia:
Zajęcia miały na celu wykorzystanie Dockera i Jenkinsa do usprawnienia procesu tworzenia oprogramowania poprzez automatyzację. Naszym zadaniem było ułożenie "pipelina" - zestawu kroków, które wykonują się automatycznie, prowadząc nas przez etapy budowania, testowania i wdrażania aplikacji. Składa się on z różnych etapów, takich jak pobieranie kodu źródłowego, kompilacja, testowanie oraz przenoszenie aplikacji do różnych środowisk. To wszystko po to, by zapewnić szybkie iteracje i bezpieczne wdrożenia, zawsze z raportowaniem wyników na końcu trasy.
### Przebieg ćwiczenia 005:
Proces instalacji Jenkinsa przebiegał zgodnie z zamieszczoną na stronie instrukcją, opisany został w poprzednim sprawozdaniu.
### Proste projekty w Jenkins:
* Konfiguracja wstępna i pierwsze uruchomienie:
  * Utworzyłam projekt, który wyświetla nazwę systemu operacyjnego i nazwę użytkownika:
W tym celu kliknęłam w nowy projekt na stronie Jenkins. W konfiguracji wybrałam opcję **kroki budowania**, oraz wybrałam uruchom powłokę. Wpisałam komendę **whoami** oraz **uname -a**, aby wypisać wyżej wymienione informację.
Po wykonanniu otrzymałam następujące logi:

///![](./screeny/spr3scr1.png)

  * Utworzyłam projek, który zwraca błąd, gdy godzina jest nieparzysta:
W krokach budowania powłokę uzupełniłam kodem:

///scr2

Po uruchomieniu otrzymałam logi konsoli:

///scr3

* Sugerując się wskazówkami podanymi na labolatorium, nie tworzyłam kolejnego projektu tylko odrazu zaczełam od pierwszego pipelinu, który:
  * sklonował nasze repozytorium,
  * przeszedł na moją osobistą gałąź,
  * zbudował obrazy z dockerfiles.
Po wykonaniu otrzymałam następujące logi:

///scr5, scr5a

### Wstęp
Na wstępie chciałam zaznaczyć, że byłam zmuszona przenieść się na inne urzadzęnie, gdyż stan pamięci i procesora poprzedniego komputera ZNACZNIE wydłużał pracę.
Na nowym urządzeniu postanowiłam przenieść się na Fedore, kierując się zapewnieniami, że pracuje się na niej lepiej niż na Ubuntu. Po ponownym zainstalowaniu Jenkinsa, wybrałam repozytorium do dalczej pracy.
Oto link do repozytorium:

```
https://github.com/irssi/irssi.git
```

Wymagania wstępne środowiska:
Repozytorium to zawiera kod źródłowy aplikacji o nazwie Irssi.
Jest to otwarte oprogramowanie, które korzysta z licencji GNU General Public License v2.0 (GPL-2.0), która potwierdza możliwość swobodnego korzystania z kodu, w tym jego modyfikowania, dystrybuowania i wykorzystywania w różnych celach, zgodnie z warunkami tej licencji. 

  * Utworzyłam diagram aktywności:
    
///scr_diagram

  * Następnie utworzyłam diagram wdrożeniowy:
    
///SCR_diagram_wdr

### Pipeline
Pierwszy krok, który nazwałam "Prepare" ma na celu przygotowanie środowiska pracy do dalszych działań, w skład czego wchodzą następujące kroki, usunięcie starego katalogu, clone repozytorium przedmiotu i checkout na moja gałąź.

///scr6

Wykonało się poprawnie:

///scr7

Następnie postanowiłam utworzyć pliki, w których przechowywane będą logi z etapów build i test.

///scr8

Uruchomiłam:

///scr9




  
