Kinga Kubajewska
# Sprawozdanie 1, Zajęcia 1: Wprowadzenie, Git, Gałęzie, SSH
## Cel zajęć:

Wprowadzenie do platformy GitHub oraz zrozumienie, jak działa system zarządzania repozytoriami. Poznanie różnic między repozytorium lokalnym, a zdalnym. Nauka podstawowych poleceń do obsługi GitHuba, umożliwiających modyfikowacje plików na własnych gałęziach.

Podczas laboratorium korzystano z maszyny wirtualnej stworzonej przy użyciu OpenSUSE oraz oprogramowania do wirtualizacji VMware. Wykonywano zadania za pomocą połączenia SSH w programie Visual Studio Code.

## Przebieg ćwiczenia:
### 1. Instalacja klienta Git i obsługi kluczy SSH.
Zainstalowano klienta Git za pomocą komendy:
```bash
apt-get install git
```
Dzięki wcześniej zainstalowanemu pakietowi openssh-client możliwa jest obsługa kluczy, co umożliwi ich późniejszą generację.
W celu sprawdzenia wersji i poprawności instalacji użyto poleceń:
```bash
git --version 
ssh -V
```
![Screen1](./screen/screen1a.png)
### 2. Klonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token.

Na początku w serwisie Github wygenerowano Personal Access Token, który jest wykorzystywany głównie do autoryzacji dostępu do zasobów:

![Screen2](./screen/screen2.png)
Dzięki tokenowi możliwe jest sklonowanie repozytorium za pomocą komendy:
```bash
git clone https://username:personal_access_token@github.com/user/repo.git
```
Natomiast do sklonowania repozytorium za pomocą HTTPS służy polecenie:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
### 3. Klonowanie repozytorium za pomocą protokołu SSH.
* pracę rozpoczęto od zapoznania się z dokumentacją,
* następnie utworzono dwa klucze SSH (ecdsa oraz ED25519), w tym co najmniej jeden zabezpieczony hasłem:
  
 klucz zabezpieczony hasłem wygenerowano za pomocą komendy:
  
```bash
ssh-keygen -t ecdsa -C "kubajewska@student.agh.edu.pl"
```
![Screen3](./screen/screen%203.png)

  drugi klucz wygenerowano za pomocą komendy:
  
```bash
ssh-keygen ed25519 -C "kubajewska@student.agh.edu.pl"
```
W katalogu .ssh znajdują się wygenerowane klucze w dwóch wersjach: publicznej i prywatnej.

![Screen4](./screen/screen%204.png)

Zawartości poszczególnych kluczy wyświetlono za pomocą komendy:
```bash
cat id_ecdsa.pub
cat id_ed25519.pub
```
![Screen5](./screen/screen%205.png)

Następnie owe zawartosci umieszczono na koncie GitHub: Settings -> SSH and GPG keys -> New SSH key

![Screen6](./screen/screen%206.png)

Dzięki temu możliwe jest sklonowanie repozytorium za pomocą komendy:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
### 4. Przełączenie się na gałąź main, a potem na gałąź swojej grupy.
Na początku sprawdzono w jakim miejscu gałęzi obecnie znajdujemy się poprzez komendę:
```bash
git branch
```
Aby zobaczyć wszystkie gałęzie dostępne w repozytorium, używa się polecenia:
```bash
git branch --all
```
![Screen7](./screen/screen%207.png)

Zrzut ekranu został zrobiony po wykonaniu całej instrukcji, dlatego pokazuje już utworzony branch KK406795 co zostanie opisane poniżej.
Gałąź, na której aktualnie się znajdujemy jest oznaczona gwiazdką (*).
Do przełączenia się na utworzoną już wcześniej gałąź grupy wykonano polecenie:
```bash
git checkout GCL2
```
### 5. Utworzenie gałęzi o nazwie "inicjały & nr indeksu".
Będąc w odpowiednim miejscu na gałęzi zastosowano komendę:
```bash
git checkout -b KK406795
```
### 6. Rozpoczęto pracę na nowej gałęzi.
* utworzono katalog także o nazwie "inicjały & nr indeksu", za pomocą:
```bash
mkdir -p INO/GLC2/KK406795/Sprawozdanie1
```
* następnie napisano Git hooka - skrypt weryfikujący, że każdy "commit message" zaczyna się od "inicjały & nr indexu"
Zmodyfikowano plik o nazwie "commit-msg.sample" znajdujący się w folderze ".git/hooks". Umieszczono w nim skrypt i zmieniono jego nazwę na "commit-msg". Dzięki tej zmianie skrypt będzie automatycznie wykonywany za każdym razem, gdy dokonywane jest commitowanie.
* następnie skopiowano ten plik do katalogu o nazwie "KK406795".
* poprzez polecenie chmod +x zmieniono prawa dostępu do pliku.
  
![Screen8](./screen/screen%208.png)

* treść githooka można odczytać poprzez komendę:
```bash
nano .git/hooks/commit-msg
```
![Screen9](./screen/screen%209.png)

Poniżej znajdują się komunikaty otrzymane po komendzie:
```bash
git commit -m "Test"
git commit -m "KK406795 commit"
```
![Screen10](./screen/screen%2010.png)

* Całe drzewo katalogów wygląda następująco:
  
![Screen11](./screen/screen%2011.png)

* Utworzono katalog o nazwie screen, gdzie dodano zrzuty ekranu wpisywanych poleceń.
* Zrzuty ekranu dodano (jako inline) poprzez polecenie:
```bash
![Nazwa](./screen/nazwa_pliku.png)
```
W nawiasie okrągłym znajduje się ścieżka do folderu ze zrzutami ekranu.
* Następnie wysłano zmiany do zdalnego źródła poprzez użycie komend w następującej kolejności:
```bash
git add .
```
Komenda git add służy do dodawania zmian w plikach roboczych do indeksu, co oznacza, że są one przygotowane do zatwierdzenia w następnym commicie.
```bash
git status
```
Komenda git status wyświetla bieżący stan repozytorium Git, informując o zmianach w plikach roboczych, które zostały dodane do indeksu, zmianach, które nie zostały dodane do indeksu, oraz o bieżącej gałęzi, na której znajdujemy się w repozytorium.
```bash
git commit
```
Komenda git commit zatwierdza wszystkie zmiany dodane do indeksu, tworząc nowy commit z opisem zmiany, który staje się częścią historii repozytorium.
```bash
git push
```
Komenda git push przesyła lokalne commity do zdalnego repozytorium Git, aktualizując zdalną gałąź o najnowsze zmiany z lokalnego repozytorium.

![Screen12](./screen/screen%20push.png)

* Następnie podjęto próbę wciągnięcia swojej gałęzi do gałęzi grupowej:

Za pomocą git checkout przełączono się na gałąź GCL2.

Do wciągnięcia zastosowano komendę:
```bash
git push origin KK406795:GCL2
```
Otrzymano komunikat błędu.

![Screen13](./screen/screen13.png)

* Zaktualizowano sprawozdanie i zrzuty o ten krok i wysłano aktualizację do zdalnego źródła (na swojej gałęzi) za pomocą już wyżej opisanych komend.
  
# Sprawozdanie 1, Zajęcia 2: Git, Docker
## Cel zajęć:
Zestawienie środowiska do wykorzystania Dockera jako narzędzia umożliwiającego tworzenie, uruchamianie i skalowanie aplikacji w izolowanych kontenerach, co ułatwia zarządzanie infrastrukturą i zapewnia spójne środowisko od tworzenia po wdrożenie.
Zapoznanie z podstawowymi poleceniami i pojęciami związanymi z tematem Dockera.

Podczas wykonowania labolatorium po zainstalowaniu Dockera na maszynę OpenSUSE napotakono problemy z jego działaniem, natomiast próba instalacji i poprawonosci działania powiodła się na Ubuntu zatem do wykonania poleceń z labolatorium numer dwa skorzystano z nowej maszyny wirtualnej stworzonej przy użyciu Ubuntu oraz oprogramowania do wirtualizacji Oracle VM VirtualBox.

## Przebieg ćwiczenia:
### 1. Zainstalowano Docker w systemie linuksowym.
Do zainstalowania Dockera na Ubuntu użyto polecenia:
```bash
sudo apt install docker.io
```
Następnie do włączenia usługi Docker'a przy uruchomieniu systemu, użyto poniższej komedy:
```bash
sudo systemctl enable docker
```
Do sprawdzenia poprawności działania Dockera wykorzystano polecenie:
```bash
sudo systemctl status docker
```
![Screen1](./screen/screen1b.png)
### 2. Zarejestrowano się w Docker Hub i zapoznano z sugerowanymi obrazami.
Utworzono konto o nazwie kinga01:

![Screen2](./screen/screen2b.png)

### 3. Pobrano obrazy hello-world, busybox, fedora, mysql.
Do pobrania hello-world zastosowano polecenie:
```bash
docker run hello-world
```
![Screen3](./screen/screen3b.png)

kolejne 3 obrazy pobrano za pomocą:
```bash
docker pull <nazwa_obrazu>
```
Do wyświetlenia listy wszystkich obrazów Docker dostępnych w repozytorium użyto polecenia:

```bash
docker images
```
![Screen4](./screen/screen4b.png)

### 4. Uruchomiono kontener z obrazu busybox.
Uruchomienie nastąpiło poprzez komendę 
```bash
docker run:
```
![Screen5](./screen/screen5b.png)

lecz jak widać na powyższym zrzucie ekranu kontener wyłaczył sie natychmiast.
Dodatkowo poprzez komendę:
```bash
docker container list --all
```
możliwe jest wyświetlenie listy wszystkich kontenerów, zarówno uruchomionych, jak i zatrzymanych, znajdujących się w systemie.

![Screen6](./screen/screen6b.png)

Jest to dowód na uruchomienie kontenera.
Następnie podłączono się do kontenera interaktywnie za pomocą:
```bash
docker run -it busybox
```
flaga -i oznacza tryb interaktywny,
a flaga -t oznacza alokację pseudo-terminala.
 
potem wywołano numer wersji poprzez komendę:

```bash
cat --help
``` 
![Screen7](./screen/screen7b.png)

### 5. Uruchomiono "system w kontenerze" (czyli kontener z obrazu fedora)
Zastosowano komendę:
```bash
docker run -it fedora
```
![Screen8](./screen/screen8b.png)

Aby zaprezentować PID1 w kontenerze i procesy dockera na hoście, należy wykonać nastepujace kroki:

a) Zainstalować pakiet "procps", który zawiera narzędzia i programy służące do monitorowania procesów w systemie, takie jak ps, top, kill itp. Te narzędzia umożliwiają użytkownikowi wyświetlanie, zarządzanie i analizowanie procesów działających w systemie operacyjnym. Komenda:
```bash
dnf install procps -y
```
![Screen9](./screen/screen9b.png)

b) Po poprawnej instalacji użyć komedny ps, która służy do wyświetlania informacji o aktualnie działających procesach na komputerze.
Zdecydowano sie dodać konkretne flagi, aby uzyskać bardziej szczegółowe informacje:
```bash
ps -aux
```
Flaga:

-a: Wyświetla wszystkie procesy na wszystkich terminalach, niezależnie od właściciela.

-u: Wyświetla więcej szczegółowych informacji o procesach, takie jak użytkownik, który uruchomił proces, zużycie zasobów, czas działania itp.

-x: Wyświetla także procesy, które nie są bezpośrednio związane z terminalem.

![Screen10](./screen/screen10b.png)

Pakiety zaaktualizowano korzystając z menedżera pakietów DNF oraz komendy:
```bash
dnf update
```
![Screen11](./screen/screen11b.png)

Na końcu w celu wyjścia z kontenera użyto komendy:
```bash
exit
```
Dowodem zakończenia pracy kontenera jest zmiana statusu na 'Excited'.

![Screen12](./screen/screen12b.png)

### 6. Stworzenie, zbudowanie i uruchomienie prostego pliku Dockerfile bazującego na wybranym systemie i sklonowanie repo.
Na początku utworzono plik o nazwie Dockerfile.
Zmodyfikowano go kierując się dobrymi praktykami, jego treść wygląda następująco:

![Screen13](./screen/screen13b.png)

Opis pliku:

FROM fedora:latest -> Bazowy obraz, który zostanie użyty do zbudowania obrazu kontenera to fedora w najnowszej wersji.

RUN dnf -y update && dnf -y install git -> Wykonano dwie operacje w jednej instrukcji RUN. Aktualizacja listy pakietów, następnie instalacja pakietu git.

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git -> wykonano klonowanie repozytorium Git znajdującego się pod podanym adresem URL.

WORKDIR /repo ->  ustawiono katalog roboczy na /repos wewnątrz kontenera. Wszystkie kolejne operacje będą wykonywane w tym katalogu.

ENTRYPOINT ["/bin/bash"] -> domyślna komenda, która zostanie uruchomiona w kontenerze podczas jego startu. Kontener będzie uruchamiał powłokę /bin/bash, co pozwoli użytkownikowi na interaktywną pracę w kontenerze.

Zbudowano plik poprzez komendę:
```bash
docker build -t <nazwa_pliku> .
```
![Screen14](./screen/screen14b.png)

Plik zbudował sie prawidłowo:

![Screen15](./screen/screen15b.png)

Powyższy zrzut ekranu zawiera także komendę uruchamiającą interaktywnie kontener i weryfikacje, czy poprawnie sklonowano repozytorium.

### 7. Wyświetlenie uruchomionych ( != "działających" ) kontenerów, wyczyszczenie ich.
Wyświetlenie listy wszystkich kontenerów Docker, zarówno uruchomionych, jak i zatrzymanych, obecnych w systemie poprzez komendę:
```bash
docker ps -a
```
Opcja -a oznacza "all" i powoduje wyświetlenie wszystkich kontenerów, niezależnie od ich stanu.

![Screen16](./screen/screen16b.png)

Zatrzymania kontenerów dokonano komendą:
```bash
docker stop $(docker ps -a -q)
```
![Screen17](./screen/screen17b.png)

Wyczyszczenie ich następuje poprzez komendę:
```bash
docker rm $(docker ps -a -q)
```
Komenda docker rm usuwa kontenery Docker. *$()* jest konstrukcją używaną w Bashu do wywoływania poleceń wewnątrz innych poleceń. W tym przypadku, $(docker ps -a -q) jest zastępowane przez listę ID wszystkich kontenerów.

Efekt końcowy:

![Screen18](./screen/screen18b.png)

### 8. Czyszczenie obrazów.
Odbywa się poprzez komendę:
```bash
docker rmi $(docker images -a -q)
```

![Screen19](./screen/screen19b.png)

### 9. Dodano stworzone pliki Dockefile do folderu Sprawozdanie1 w repozytorium.

![Screen20](./screen/screen20b.png)

Zaaktualizowano sprawozdanie i wykonano pull requesta.
























