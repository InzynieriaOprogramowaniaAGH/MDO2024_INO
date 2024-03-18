# Sprawozdanie 1
Krystian Gliwa, IO.

## Cel projektu
Celem tego ćwiczenia jest...

## Streszczenie projektu

## Zajęcia 1

### Instalacja klienta Git i obsługe kluczy SSH

Klienta Git oraz OpenSSH służące do obsługi kluczy SSH pobrałem juz podczas instalacji Ubuntu na wirtualnej maszynie (zaznaczając odpowiednie dodatki przy instalacji). Jednak aby się upewnić że takowe są i działają na moim serwerze użyłem poleceń do sprawdzania wersji zainstalonych programów:
```
git --version
ssh -V
```
![wersja Gita i OpenSSH](./zrzuty_ekranu/1.jpg)

### Klonowanie za pomocą HTTPS i personal access token

Do kolonowania za pomocą HTTPS i personal access token konieczne było utworzenie nowego tokenu na Githubie wybierając: **Settings/Developer Settings** i tam Personal access tokens (classic), po czym wpisać notatke do tokenu oraz zdefiniować jego dostęp: 

![Tworzenie personal access token](./zrzuty_ekranu/2.jpg)

Po utworzeniu tokenu użyłem go do sklonowania repozytorium za pomocą HTTPS poleceniem: 
```
git clone https://username:personal_access_token@github.com/owner/nazwa_repozytorium.git
``` 
W moim przypadku było to: 

![klonowanie za pomoca HTTPS](./zrzuty_ekranu/3.jpg)

### Klonowanie za pomocą utworzonego klucza SSH

Aby sklonować repozytorium za pomocą klucza SSH najpierw musiałem go utworzyć. Utworzyłem dwa, pierwszy zabezpieczony hasłem utworzyłem poleceniem: 
```
ssh-keygen -t ed25519 -C "ja.krystian3243@gmail.com"
```
natomiast drugi:
```
ssh-keygen -t ecdsa -C "ja.krystian3243@gmail.com"
```
![pierwszy klucz ed25519](./zrzuty_ekranu/4.jpg)
![drugi klucz ecdsa](./zrzuty_ekranu/5.jpg)

Następnie uruchomiłem agenta uwierzytelniania SSH za pomocą polecenia: 
```
eval $(ssh-agent)
```
 oraz dodałem do niego wygenerowane klucze za pomocą polecenia:
```
ssh-add ścieżka/do/klucza
```
![dodawanie kluczy do agenta](./zrzuty_ekranu/6.jpg)

Następnie skopiowałem zawartość kluczy publicznych do schowka:

![kopiowanie zawartosci kluczy](./zrzuty_ekranu/7.jpg)

i dodałem je do ustawień konta na Githubie wchodząc w: **Settings/SSH and GPG keys** tam klikając w przycisk **New SSH key** i wklejając zawartość kluczy:

![dodawanie kluczy na Githubie](./zrzuty_ekranu/8.jpg)

Po wykonaniu tych kroków mogłem już sklonować repozytorium za pomocą klucza SSH, używając polecenia:
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![klonowanie za pomoca klucza SSH](./zrzuty_ekranu/9.jpg)

### Poruszanie się po gałęziach

Gałęzie w systemie kontoli wersji Git umożliwiają tworzenie niezależnych ścieżek rozwoju w projekcie, przez co wiele osób może pracować nad różnymi funkcjonalnościami równocześnie, bez wpływania na główną linię rozwoju. Oto kilka podstawowych operacji na gałęziach:
aby sprawdzić na jakiej gałęzi aktualnie się znajdujemy możemy użyć polecenia:
```
git branch
```
aby przełączyć się na istniejącą gałąź należy użyć polecenia:
```
git checkout nazwa_gałęzi
```
aby utworzyć i przełączyć się na nową gałąź należy użyć polecenia: 
```
git checkout -b nazwa_nowej_gałęzi
```
korzystając z tych poleceń przełączyłem się na gałąź **main** a potem na gałąź mojej grupy czyli **GCL1** i  tam utworzyłem swoją gałąź o nazwie **KG411149**:

![operacje na gałęziach](./zrzuty_ekranu/10.jpg)

### Rozpoczęcie pracy na swojej gałęzi

#### Utworzenie nowego katalogu **KG411149** w folderze swojej grupy
Będąc w lokalizacji: 
```
/home/krygliw/MDO2024_INO/INO/GCL1
```
za pomocą polecenia: 
```
mkdir KG411149
```
utworzyłem nowy katalog w swojej gałęzi o takiej samej nazwie:

![folder KG411149](./zrzuty_ekranu/11.jpg)

#### Napisanie Git hoooka
Kolejnym krokiem było napisanie własnego Git hooka. czyli skryptu werfikującego czy każdy mój "commit message" zaczyna się od **KG411149** czyli od moich inicjałów i numeru indeksu. Utworzyłem skrypt o nazwie **commit-msg** w utworzonym poprzednio katalogu. Najpierw określone jest że skrypt pisany jest w powłoce **sh**, później przypisany zostaje pierwszy argument przekazany do skryptu do zmiennej **COMMIT_MSG_FILE**, następnie w pętli **if** sprawdzane jest za pomocą funkcji **grep -q** która służy do wyszukiwania, czy komunikat commita rozpoczyna się od ciągu znaków **KG411149**, jeśli nie zwracany jest komunikat błędu który informuje że komunikat commita nie rozpoczyna się od **KG411149**, po czym **exit** kończy działanie skryptu z kodem błędu 1, co uniemożliwia wykonanie commita.

![Git hook](./zrzuty_ekranu/12.jpg)

Nastepnie skopiowałem mój skrypt **commit-msg** do katalogu: 
```
/home/krygliw/MDO2024_INO/.git/hooks
```
aby uruchamiał się za każdym razem kiedy robię commita. Testy działania **commit-msg**:

![testy commit-msg](./zrzuty_ekranu/13.jpg)

#### Dodawanie pliku ze sprawozdaniem
W utworzonym wczesniej katalogu **KG411149** utworzyłem katalog **sprawozdanie_1** podobnie jak tworzyłem katalogi wcześniej, w tym katalogu utworzyłem plik **Sprawozdanie1.md** (w tym pliku znajduje się cała treść sprawozdania) za pomocą polecenia :
```
touch Sprawozdanie1.md
```

![folder sprawozdanie_1](./zrzuty_ekranu/14.jpg)

#### Dodawanie zrzutów ekranu
 Następnie w tym samym katalogu utworzyłem kolejny o nazwie **zrzuty_ekranu** w którym umieszczałem zrzuty ekrany umieszczane tez w sprawozdaniu jako dowód wykonania wszystkich kroków z instrukcji.
 W piliku **Sprawozdanie1.md** umieszczałem je jako inline czyli w ten sposób: 
```
![wersja Gita i OpenSSH](./zrzuty_ekranu/1.jpg)
```

#### Wysyłanie zmian do zdalnego hosta
Każdą zmianę którą przeprowadziłem na mojej gałęzi i chcę aby wbyła widoczna na zdalnym hoscie muszę tam wysłać. Aby to zrobić korzystałem z trzech komend:
```
git add
```
**add** odpowiada za dodanie nowych zmian, wszytkich nowych plików czy tez modyfikacje starych.

```
git commit
```
**commit** jest komunikatem towarzyszącym zmianą w którego treści umieszczamy co zostało przez nas zmienione od ostatniego wysłania zmian do zdalnego hosta.

```
git push
```
**push** krótko mówiąc wypycha zmiany z lokalnego hosta do zdalnego (potwierdza je).

![wysyłanie zmian do zdalnego hosta](./zrzuty_ekranu/15.jpg)

Przydatnym narzędziem przy pracy z gitem jest również:
```
git status 
```
który wyświetla bierzący stan repozytorium Git i w tym liste nowych zmian:

![git status](./zrzuty_ekranu/16.jpg)

#### Próba wyciągania swojej gałęzi do gałęzi grupowej
Najepierw aby spróbować wyciągnąć swoją gałąź do gałęzi grupowej zmieniłem  aktulaną gałąź na gałąź grupową czyli **GCL1**. Następnie aby wyciągnąć zmiany z mojej gałęzi do gałęzi grupy używam komendy
```
git merge
```
![git merge](./zrzuty_ekranu/17.jpg)

Ten krok udaje się wykonać, jednak gdy próboje za pomocą **push** wypchnąć zmiany do zdalnego hosta nie udaje mi się to ponieważ nie mam odpowiednich od tego uprawnień: 

![push](./zrzuty_ekranu/18.jpg)

## Zajęcia 2

### Instalacja Dockera w systemie linuksowym
Na początek zajęć 2 sprawdziłem czy na swoim serwerze posiadam juz dockera polceniem:
```
docker --version
```
Dockera miałem juz na serwerze dlatego nie potrzebowałem go instalować :

![docker](./zrzuty_ekranu/19.jpg)

Aby się upewnić czy wszystko działa poprawnie uruchomiłem oraz pobrałem obraz hello-world polceniem: 
```
sudo docker run hello-world
```
![docker test](./zrzuty_ekranu/20.jpg)

#### Rejestracja w dokerze
Na głownej stronie dockera zarejstrowałem się na tego samego maila którego używam do Gita: 

![docker rejstracja](./zrzuty_ekranu/21.jpg)

#### Pobieranie obrazów 
Kolejnym krokiem było pobranie obrazów hello-world, busybox, fedora, mysql, do pobrania używałem polecenia:
```
sudo docker pull nazwa_obrazu
```
Do przeglądania pobranych obrazów użyłem polecenia: 
```
sudo docker images
```
![docker obrazy](./zrzuty_ekranu/22.jpg)

#### Uruchomienie kontenera z obrazu busybox
Aby to wykonać użyłem polecenia
```
sudo docker run busybox
```
Aby sprawdzić efekt uruchomienia polecenia użyłem polecenia
```
sudo docker container list
```
jednak wtedy nie zobaczymy busyboxa wśród działających kontenerów: 

![efekt uruchomienia busybox](./zrzuty_ekranu/24.jpg)

Ale jednak wiemy że uruchamialiśmy go więc należy zobaczyc czy jest w histori uruchomionych kontenerów za pomocą polecenia: 
```
sudo docker container list -all
```
![efekt uruchomienia busybox_1](./zrzuty_ekranu/23.jpg)

Tutaj widać ze dany kontener pracował jakąś chwile temu, lecz juz zakończył swoje działanie.


Kolejnym krokiem było podłączenie się do kontenera interaktywnie i wywołanie numeru wersji. Połączenie interaktywne pozwala na interakcję z aplikacją uruchomioną wewnątrz kontenera poprzez terminal. Aby uruchomić terminal interaktywnie użyłem polecenia: 
```
sudo docker run -it busybox  
```
Aby wyświetlić informacje o wersji busyboxa nalezy uzyc polecenia: 
```
busybox --help
```
Żeby wyjść z konternera należy użyć polecenia: 
```
exit
```
![busybox interaktywnie](./zrzuty_ekranu/25.jpg)

#### Uruchomienie systemu w kontenerze (kontener z obrazu fedora)
Na początek uruchomiłem w nowym terminalu ten system poleceniem: 
```
sudo docker run -it fedora
```
Następnie aby sprawdzić proces PID1 użyłem polecenia 
```
ps -aux
```
jedank w systemie nie było zainsalowanego **ps** więc instalacji dokonałem poleceniem: 
```
dnf install procps -y
```
teraz juz mogłem sprawdzić PID1 za pomocą ps:

![PID1](./zrzuty_ekranu/26.jpg)

Następnie aby zaprezentowac procesy dockera na hoscie wyświetliłem liste działających kontenerów poleceniem: 
``` 
sudo docker container list
```
A potem po ID kontenera znajdujemy jego proces root, poleceniem: 
```
sudo docker top e4b8865f218a
```
![procesy dockera na hoscie](./zrzuty_ekranu/27.jpg)

Następnie przystąpiłem do aktualizacji pakietów poleceniem:
```
sudo dnf update
```
po czym aby potwierdzić tą aktualizacje wpisałem **y**:

![aktualizacja pakietów](./zrzuty_ekranu/28.jpg)

W ten sposób pobrieramy wszytkie zmiany. Na koniec wychodzimy tak jak wczesniej czyli **exit**.

#### Stworzenie  własnoręcznie, zbudowanie i uruchomienie prostego pliku Dockerfile bazującego na wybranym systemie i sklonowanie repozytorium

Utworzyłem plik **Dockerfile** w nim ustawiłem obraz bazowy czyli Ubuntu: 
```
FROM ubuntu:latest
```
Ustawiłem katalog roboczy:
```
WORKDIR /app
```
Następnie zainstalowałem w nim Gita
```
RUN apt-get update && apt-get install -y git
```
Następnie sklonowałem reporzytorium:
```
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
Na koniec zdefiniowałem główny program który ma zostać uruchomiony w Dockerze jako pierwszy proces:
```
ENTRYPOINT ["/bin/bash"]
```
Plik Dockerfile: 

![Dockerfile](./zrzuty_ekranu/29.jpg)

Po utworzeniu pliku Dockerfile na jego podstawie tworze swój własny obraz poleceniem: 
```
docker build -t my_image .
```
![budowanie mojego obrazu](./zrzuty_ekranu/30.jpg)

Następnie sprawdziłem czy mój obraz się utworzył: 
![sprawdzanie mojego obrazu](./zrzuty_ekranu/31.jpg)

A następnie uruchomiłem kontener w trybie interaktywnym zeby sprawdzić czy repozytorium poprawnie się sklonowało:
![sprawdzanie czy repozytorium sie sklonowało](./zrzuty_ekranu/32.jpg)

#### Pokazanie uruchomionych ( != "działające" ) kontenerów, wyczyszczenie ich.

Aby pokazać uruchomione ale niedziałające konternery użyłem polecenia: 
```
sudo docker ps -a -f status=exited
```
Oto one: 

![ uruchomione ale niedziałające konternery](./zrzuty_ekranu/33.jpg)

Aby usunąć niedziałające konternery użyłem polecenia:
```
sudo docker rm $(docker ps -a -f status=exited -q)
```
asdasd
