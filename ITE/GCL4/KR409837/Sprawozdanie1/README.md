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

### Zainstaluj klienta Git i obsługę kluczy SSH
Korzystając z następującego polecenia:
```
sudo apt install git
```
pobrałem klienta Git, który umożliwia zdalne klonowanie repozytoriów. Jednakże przed przystąpieniem do tego należy utworzyć `Personal access token`, który można pozyskać na platformie GitHub przechodząc do następujących zakładek: Settings > Developer settings > Personal access tokens > Tokens (classic). Podczas tworzenia tokenu należało określić jego termin ważności oraz jego dozwolone akcje.

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/Personal Access Token.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/pamiec.png">
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

Następnie 

