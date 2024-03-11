# Sprawozdanie 1

## Wprowadzenie, Git, Gałęzie, SSH

Git to jeden z najbardziej popularnych systemów kontroli wersji, dlatego oswojenie się z nim jest koniecznością w dzisiejszych realiach.

SSH natomiast, Secure Shell, to protokół do bezpiecznego przesyłania komand przez niezabezpieczoną sieć. Wykorzystuje kryptografię do uwierzytelniania i szyfrowania połączeń między urządzeniami.
Wykorzystuje TCP/IP, oraz dwa klucze - publiczny i prywatny. Za pomocą klucza publicznego drugie urządzenie ustanawia połączenie bazując na komplementarnym kluczu prywatnym. Ostatecznie jest konieczna autoryzacja przez login i hasło.

Założeniem laboratoriów było rozpocząć pracę na skolonowanym repozytorium zajęć poprzez utworzenie gałęzi, stworzenie git hooka i zaktualizowanie obecnej gałęzi.
## Wykonanie
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
