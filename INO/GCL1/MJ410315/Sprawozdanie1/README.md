# Sprawozdanie 1

## Wprowadzenie, Git, Gałęzie, SSH

Git to jeden z najbardziej popularnych systemów kontroli wersji, dlatego oswojenie się z nim jest koniecznością w dzisiejszych realiach.

SSH natomiast, Secure Shell, to protokół do bezpiecznego przesyłania komand przez niezabezpieczoną sieć. Wykorzystuje kryptografię do uwierzytelniania i szyfrowania połączeń między urządzeniami.
Wykorzystuje TCP/IP, oraz dwa klucze - publiczny i prywatny. Za pomocą klucza publicznego drugie urządzenie ustanawia połączenie bazując na komplementarnym kluczu prywatnym. Ostatecznie jest konieczna autoryzacja przez login i hasło.

Założeniem laboratoriów było rozpocząć pracę na skolonowanym repozytorium zajęć poprzez utworzenie gałęzi, stworzenie git hooka i zaktualizowanie obecnej gałęzi.
### Wykonanie
Mając gotową maszynę wirtualną, system `ubuntu` od początku posiadał klienta `git` i obsługę kluczy SSH, dlatego krok 1 został wykonany.

### 1. Sklonowanie repozytorium przedmiotowego za pomocą HTTPS  
Konieczne było pobranie repozytorium za pomocą protokołu HTTPS, które jest obecnie preferowane przez githuba. Zazwyczaj wymaga podania loginu oraz hasła, natomiast w moim przypadku autoryzacja przebiegała poprzez *personal access token*. Musimy go odpowiednio wygnerować w ustawieniach naszego konta na githubie (`Settings/Developer Settings/Token`). 

Aby poprawnie móc zweryfikować tożsamość należało podać odpowiednie dane poprzez:

```
git config --global user.email "m.jurzak18@gmail.com"
git config --global user.name "michaljurzak1"
```

Samo kolonowanie przebiega już tak:
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
<img src="images/Zrzut ekranu 2024-03-04 212235.png">
    
### 2. Sklonowanie repozytorium poprzez SSH
Na początku należało utworzyć dwa klucze SSH różne od RSA.
Jednym z typu szyfrowania który użyłem jest ecdsa bez hasła.  

```
ssh-keygen -t ecdsa -b 521
```
<img src="images/Zrzut ekranu 2024-03-04 220510.png">  

Drugim typem szyfrowania innym od RSA jest ed25519 do którego użyłem już hasło. Konfiguracja tego klucza na githubie polegała na skopiowaniu klucza poublicznego o rozszerzeniu `.pub` i wklejenie ustawieniach w odpowiednie miejsce:  
`Settings > SSH and GPG keys > New SSH key`  
A następnie ostatecznie dodanie tego klucza. Poniżej potwierdzenie utworzenia:  

```
ssh-keygen -t ed25519
```
<img src="images/Zrzut ekranu 2024-03-04 221723.png"> 

Ostatecznie, należało sklonować repozytorium metodą SSH:  

```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```


<img src="images/Zrzut ekranu 2024-03-04 215502.png">
    
### 3. Mając sklonowane repozytorium przełączenie na gałąź `main`  

```
git branch --all
```
<img src="images/Zrzut ekranu 2024-03-11 141525.png">  

Oraz należało dodać swoją gałąź o swoich inicjałach i numerze albumu.  

```
git checkout -b MJ410315
```
W przypadku zwykłego przełączania na głąź należy wpisać:  
```
git checkout 
```
Podczas rozpoczęcia pracy na nowej gałęzi należało stworzyć folder o takiej samej nazwie jak nazwa gałęzi. Będą w nim wszystkie pliki do zajęc oraz foldery ze sprawozdaniam w formacie typu `markdown` (`.md`).

Folder stworzyłem z terminala poprzez
```
mkdir MJ410315
```

<img src="images/Zrzut ekranu 2024-03-04 223648.png">
    
### 4. Dodanie git hooka  
Należało dodać git hooka który sprawdza czy wiadomość commita zaczyna się od inicjałów i numeru albumu. Poniżej treść `commit-msg` hooke'a, który po poprawnym przejściu tworzy commita, natomiast jeśli wiadomość nie zawiera odpowiedniej treści - commit nie przechodzi.  
Treść:  
```python
#!/usr/bin/env python

import sys
import os
import re
from subprocess import check_output

commit_msg_filepath = sys.argv[1]

branch = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip()

start_string = 'MJ410315'

if not branch.startswith(start_string):
    print(f"commit-msg: ERROR! The commit message must start with {start_string}")
    sys.exit(1)
```
Na początku skryptu w hooke'u jest linia *shebang* która definiuje gdzie znajduje się interpreter języka poniżej.

Żeby prawidłowo git hook się wykonywał, należy przede wszystkim umieścić go w folderze `./.git/hooks` a następnie dodać do pliku uprawnienia wykonywania się:  
```
chmod +x .git/hooks/commit-msg
```  
Wynik podczas próby utworzenia commita:  

<img src="images/Zrzut ekranu 2024-03-04 233230.png">

### 5. Dodanie sprawozdania

Sprawozdanie będzie w formacie `markdown` w pliku o nazwie `README.md`.

<img src="images/Zrzut ekranu 2024-03-11 143047.png">

Dodawanie zdjęć można przykładowo na dwa sposoby dodawać:
```md
!["Opis"]("Ścieżka/zdjęcia")
```
lub też
```xml
<img src="Ścieżka/zdjęcia">
```
Ja wykorzystałem tę ostatnią wersję w obecnym sprawozdaniu.

Aby zmodyfikować w zdalnym źródle zmiany, należy najpierw dodać pliki do `staging`, potem można wykonać `commit` i następnie wypchnąć `push`.
```
git add
git commit
git push
```  

Zaaplikowany proces aktualizacji:  
<img src="images/Zrzut ekranu 2024-03-11 143938.png">

<img src="images/Zrzut ekranu 2024-03-11 144058.png">

### 6. Spróbuj wciągnąć swoją gałąź do gałęzi grupowej

Najpierw zaktualizowałem zdalne repozytorium z lokalnym:
<img src="images/Zrzut ekranu 2024-03-11 144333.png">

Następnie należało przejść na gałąź grupową  
```
git checkout GCL1
```
Oraz wykonać jakieś zmiany. Możliwe jest także utworzenie merge ze swoją gałęzią co jest wykonalne poprzez komendę:  
```
git merge MJ410315
```
Następnie robimy commit i push poprzez komendy:
```
git add .
git commit -m "MJ410315 - Trying to push to GCL1"
git push origin GCL1
```
<img src="images/Zrzut ekranu 2024-03-11 151217.png">

Gałąź została zmergowana natomiast zabezpieczenia nie pozwoliły na bezpośrednie wypchnięcie na gałąź GCL1. Należy takie zmiany wykonywać poprzez *pull request* który ze strony githuba jest możliwy do wykonania wraz z możliwością weryfikacji, a następnie ostatecznego połączenia.

### 7. Zaktualizowanie sprawozdania

Należało zaktualizować i wysłać wszystkie zmiany na zdalne repozytorium na swoją gałąź:

```
git add .
git commit -m "MJ410315 - update"
git push
```
## Git, Docker

Docker to narzędzie pozwalające na dostarczanie platformy lub środowiska jako produkt w zwirtualizowanej postaci. Pozwala na automatyczne wdrażanie aplikacji w postaci kontenerów, co pozwala na wydajną pracę w różnych środowiskach w izolacji.

### Wykonanie

### 1. Zainstaluj Docker w systemie linuxowym
Pobranie dockera na maszynie wyrtualnej jest zależne od systemu. W moim przypadku jest to ubuntu. Ubuntu podczas instalacji pozwala opcjonalnie pobrać wybrane narzędzia. Ja wybrałem tą opcję instalacji, jednakże jeśli chciałbym pobrać to poprzez konsolę, odbywałoby się to poprzez wykonanie [instrukcji na oficjalnej stronie dockera](https://docs.docker.com/engine/install/ubuntu/).

### 2. Zarejestruj się w Docker Hub i zapoznaj z sugerowanymi obrazami

Rejestracja nie jest konieczna aby przeglądać obrazy.

### 3. Pobierz obrazy `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`

Obrazy można zarówno pobierać komendą:
```sh
docker pull <obraz>
```
<img src="images/Zrzut ekranu 2024-03-11 175850.png">


Jak i je po prostu uruchomić komendą:
```sh
docker run <obraz>
```
<img src="images/Zrzut ekranu 2024-03-11 175625.png">

Pozostałe pobrane obrazy:

<img src="images/Zrzut ekranu 2024-03-14 204238.png">

### 4. Uruchom kontener z obrazu busybox

Jak zostało wcześniej wspomniane, jeśli obraz nie istnieje, można go pobrać automatycznie poprzez uruchomienie:

```sh
docker run busybox
```
Busybox to kombinacja minimalnych wersji wielu popularnych usług używanych przez systemy UNIX. Można to nazwać niezwykle uproszczonymi funkcjonalnościami systemu UNIXowego.

<img src="images/Zrzut ekranu 2024-03-11 175918.png">

Sam uruchomiony kontener Busybox wyłączy się natychmiast, ze względu na to że działa jak system operacyjny - czeka na operacje. Jeśli ich nie będzie, samoistnie się wyłączy.

Przydatne okazuje się w takiej sytuacji interaktywne uruchomienie:
```
docker run -i busybox
```
<img src="images/Zrzut ekranu 2024-03-13 113044.png">

Poprzez komendę

```sh
cat --help
```
można zauważyć w jakiej wersji busyboxa jesteśmy, natomiast komendą
```sh
uname -a
```
uzyskujemy informacje o systemie operacyjnym.

### 5. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)

Pobrałem fedorę, ponieważ system ubuntu mam już zainstalowany na systemie operacyjnym. Na pierwszy rzut oka dystrybucje nie różnią się znacznie, natomiast istotnym jest na pewno `package manager`. W ubuntu takowym jest `APT - Advanced Packaging Tool`, natomiast fedora ma `DNF - Dandified YUM`.

Uruchomienie odbywa się tak samo - w trybie interaktywnym - ponieważ system natychmiast się wyłączy:
```sh
docker run -ti fedora
```
Opcja `-t` pozwala dodatkowo utworzyć pseudo-TTY, czyli TeleTypewriter - nazwa przed wpisywaną komendą.

Poniższą komendą jesteśmy w stanie wyświetlić aktualne procesy jakie się odbywają wewnątrz kontenera (niezbędne było zainstalowanie biblioteki `procps`).
```sh
ps
```

<img src="images/Zrzut ekranu 2024-03-13 114702.png">

Na hoście procesy przedstawiają się następująco:

<img src="images/Zrzut ekranu 2024-03-13 114820.png">

Widać, że uruchomione są `bash` w jednym terminalu, oraz `ps`. Widać także, że `docker ps` ma uruchomiony kontener z obrazem `fedory`.

Komenda
```sh
dnf upgrade
```
Pozwala na aktualizacje obecnych zależności, programów i usług.

<img src="images/Zrzut ekranu 2024-03-13 115000.png">

Poniżej widać, że zostały zaktualizowane poprawnie:
<img src="images/Zrzut ekranu 2024-03-13 115025.png">

Ostatecznie wyjście wykonuje się komendą
```sh
exit
```

<img src="images/Zrzut ekranu 2024-03-13 115052.png">

### 6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik `Dockerfile` bazujący na wybranym systemie i sklonyj nasze repo.

Pierwszym zadaniem było stworzenie samego pliku Dockerfile:
```sh
touch Dockerfile
code Dockerfile # wybrany edytor
```

<img src="images/Zrzut ekranu 2024-03-13 115246.png">

Plik zawiera następujący kod:

<img src="images/Zrzut ekranu 2024-03-13 120420.png">

```dockerfile
FROM fedora

RUN dnf -y update && \
    dnf -y install git

WORKDIR /repo

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

ENTRYPOINT ["/bin/bash"]
```

Ponownie, systemem który wybrałem jest fedora ze względu na to, że na wirtualnej maszynie pracuję na ubuntu. Kod ten bierze jako bazę obraz fedory, następnie każe wykonać komendy: aktualizacja zależności, zapewnienie zainstalowania `git`. opcja `-y` sprawia że nie trzeba potwierdzać instalacji. Ostatecznie odbywa się klonowanie a następnie ustalamy komendę jaka ma być wykonana podczas uruchomienia, w tym przypadku `bash`.

Następnie, należało zbudować obraz na podstawie pliku Dockerfile komendą:
```sh
docker build -t custom-build .
```

<img src="images/Zrzut ekranu 2024-03-13 120515.png">

Jak można zauważyć poniżej, obraz został zbudowany pomyślnie:

<img src="images/Zrzut ekranu 2024-03-13 120553.png">

#### Weryfikacja

Aby można było zweryfikować czy repozytorium zostało sklonowane (a tym samym sprawdzając czy git został zainstalowany) użyłem komendy:
```sh
docker run -i custom-build
```

<img src="images/Zrzut ekranu 2024-03-13 120835.png">

Jak widać, `README.md` repozytorium jest poprawnie skopiowane.

### 7. Pokaż uruchomione (!= "działające") kontenery, wyczyść je.

Działające kontenery można wypisać komendą
```sh
docker ps
```

<img src="images/Zrzut ekranu 2024-03-13 121203.png">

W przypadku chęci zatrzymania wszystkich działających kontenerów można to zrobić tak jak poniżej:

```sh
docker stop $(docker ps -a -q)
```
Komenda ta zatrzymuje wszystkie uruchomione kontenery
<img src="images/Zrzut ekranu 2024-03-13 121826.png">

W przypadku wylistowania wszystkich działających kontenerów można użyć komendy:
```sh
docker ps -a
```

Następnie usunięcie wszystkich kontenerów wykonuje się komendą podobną jak do zatrzymania wszystkich:
```sh
docker rm $(docker ps -a -q)
```

<img src="images/Zrzut ekranu 2024-03-13 122219.png">

Jak widać, nie ma już żadnych kontenerów.

### 8. Wyczyść obrazy

Czyszczenie obrazów wykorzystuję sub-komendę `rmi`, a do czyszczenia wszystkich wykorzystam podobną konwencję jak wcześniej:
```sh
docker rmi $(docker images -a -q)
```

<img src="images/Zrzut ekranu 2024-03-13 122344.png">

### 9. Dodaj stworzone pliki `Dockerfile` do folderu swojego `Sprawozdanie1` w repozytorium

<img src="images/Zrzut ekranu 2024-03-13 122437.png">

Ostatecznie stworzyłem `Dockerfile` ale w niewłaściwym miejscu dlatego należało go przenieść.

Obecnie struktura mojego folderu wygląda następująco:

```sh
/GCL1/MJ410315
├── Sprawozdanie1 # folder sprawozdania nr 1
|  ├── images
|  |  ├── Zrzut ekranu ... .png # zrzuty ekranu do sprawozdania
|  |  └── ...
|  ├── Dockerfile # utworzony Dockerfile
|  └── README.md # Treść sprawozdania
└── commit-msg # git hook

``` 
