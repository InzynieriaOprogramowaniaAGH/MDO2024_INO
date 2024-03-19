# Sprawozdanie 1 - Konrad Rezler
## Zajęcia 01
## Wprowadzenie, Git, Gałęzie, SSH
### Instalacja środowiska
W moim przypadku wybór padł na narzędzie `Virtual Box`, z którym wcześniej podczas studiowania miałem do czynienia. Zainstalowany system operacyjny to obsługiwany wariant dystrybucji `Ubuntu` w wersji 22.04.4 LTS, który został wskazany przed prowadzącego. Wspomnianemu systemowi zostały przydzielone:
- 4GB pamięci RAM
- 25GB miejsca na dysku

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/VirtualBox.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/pamiec.png">
</p>

### Zainstaluj klienta Git i obsługę kluczy SSH
Korzystając z następującego polecenia:
```
sudo apt install git
```
pobrałem klienta Git, który umożliwia zdalne klonowanie repozytoriów. Jednakże przed przystąpieniem do tego należy utworzyć `Personal access token`, który można pozyskać na platformie GitHub przechodząc do następujących zakładek: Settings > Developer settings > Personal access tokens > Tokens (classic). Podczas tworzenia tokenu należało określić jego termin ważności oraz jego dozwolone akcje.

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/Personal Access Token.png">
</p>


Mając już utworzony token mogłem sklonować repozytorium przedmiotu wykorzystując następującą komendę:
```
git clone https://krezler21:<utworzony_token>@github.com/<ścieżka-repozytorium>
```

Następnie wygenerowałem klucze SSH wykorzystując polecenie:
```
ssh-keygen
```
które zamieściłem w katalogu `~/.ssh`. Po użyciu komendy w katalogu pojawiły się 2 nowe pliki: klucz prywatny (sshkey) oraz klucz publiczny (sshkey.pub).
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/sshkey ls.png">
</p>

Otrzymane klucze wykorzystałem do powiązania ich z moim kontem na platformie GitHub. Wystarczyło przejść do następujących zakładek: Settings > SSH and GPG keys > New SSH Key oraz użyć wcześniej wygenerowany klucz publiczny "sshkey.pub" do utworzenia klucza typu `Authentication key`.
Klucze SSH umożliwiły powiązanie mojego konta GitHub ze zdalnym serwerem/usługą tak, aby móc z nich korzystać bez każdorazowego podawania swojej nazwy i korzystania z wcześniej wygenerowanego tokena.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/sshkey.png">
</p>

### Utworzenie własnej gałęzi
Wykorzystując komendę:
```
git checkout <branch-name>
```
przeskoczyłem na gałąź `main`, a następnie na gałąź `GCL4`. Bedąc na tej gałęzi utworzyłem własną gałąź używając komendy
```
git checkout -b KR409837
```
i przełączając się na nią wykonałem dalszem polecenia. Komenda:
```
git branch
```
umożliwiła sprawdzić mi, na jakiej gałęzi aktualnie się znajduję.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/gitbranch.png">
</p>

### Praca na nowej galęzi
Wykorzystując komendę `mkdir` w katalogu właściwym dla grupy umiesciłem katalog o nazwe `KR409837`, w nim utworzyłem katalog `Sprawozdanie 1` oraz przełączając się do niego stworzyłem w nim plik służacy do pisania tego sprawozdania następującą komendą:
```
touch README.md
```

Następnie w lokalizacji `MDO2024_INO/.git/hooks` utworzyłem plik `commit-msg` oraz nadałem mu odpowiednia prawa. W pliku zamieściłem następującą treść:
```
#!/bin/bash 
commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

if ! echo "$commit_msg" | grep -q "^KR409837"; then
    echo >&2 "Błąd: Commit musi zaczynać się od: KR409837"
    exit 1
fi

exit 0
```
W taki sposób stworzyłem githooka sprawdzającego, czy każdy mój commit message zaczyna się od następującej treści: `KR409837`.
####
Wprowadzone zmiany wypchałem na zdalną gałąź przy pomocy komendy:
```
git push origin KR409837
```
Następnie w repozytorium wykonałem pull request do gałęzi grupowej.

####
## Zajęcia 02
## Git, Docker
### Przygotowywanie środowiska
W swojej maszynie wirtualnej zainstalowałem dockera wykorzystując następującą komendę:
```
sudo snap install Docker
```
zarejestrowałem się w Docker Hub oraz pobrałem następujące obrazy:
- hello-world
- busybox
- mysql
- ubuntu
#### 
Następnie uruchomiłem kontener z obrazu `busybox`, a nastepnie podłaczyłem się do kontenera interaktywnie wywołując jego numer wersji przy pomocy widocznym na zrzucie ekranu komend
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/busybox.png">
</p>
####
Następnie uruchomiłem "system w kontenerze", czyli kontener z obrazu ubuntu. Komenda `docker run -it ubuntu`, a następnie komenda `ps` umożliwiła mi zaprezentowanie `PID1` w kontenerze i procesy dockera na hoście
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/obrazubuntu.png">
</p>
potem zaktualizowałem pakiety przy pomocy komendy `apt upgrade`.

### Tworzenie pliku `Dockerfile`
Stworzyłem prosty plik Dockerfile w osobnym katalogu `workspace1`, który zawierał skrypt odpowiedzialny za stworzenie nowego brazu bazującego na ubuntu oraz instalację Gita i sklonowanie repozytorium przedmiotu za pomocą protokołu HTTPS. Wspomniany plik posiadał następującą treść:
```
# syntax=docker/dockerfile:1
FROM ubuntu 
RUN apt update && apt install -y git ssh 
WORKDIR /github 
RUN git clone https://github.com/InzynieriaoprogramowaniaAGH/MDO2024_INO.git 
```
następnie utowrzyłem przykładowy obraz korzystając z polecenia `docker buildx build -t obraz .`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/dockerbuild.png">
</p>
i upewniłem się, że obraz będzie miał gita i sciągnięte jest tam nasze repozytorium
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/obraz potwierdzenie.png">
</p>





