# Sprawozdanie nr 1
---
## Cel ćwiczenia: Wprowadzenie do środowiska Git. Połączenie z serwerem na wirtualnej maszynie Ubuntu, umiejętność posługiwania się podstawowymi poleceniami Git: branch, commit, add, checkout, itp., poprawne rozumienie struktury gałęzi i posługiwanie się nimi w trakcie laboratorium. Należy zrozumieć ideę kluczy SSH i potrafić je generować.
---

## Przygotowanie środowiska pracy
Utworzyłem serwer na systemie operacyjnym Ubuntu (Linux) w wersji konsolowej, aby móc się z nim łączyć za pomocą protokołu ssh na przykład w Visual Studio Code na mojej lokalnej maszynie. 
## Obsługa kluczy SSH
## Klient Git
![](zrzuty_ekranu/git1.png)
## Klonowanie repozytorium na 2 sposoby
  - za pomocą HTTPS
  - za pomocą klucza SSH
    - utworzenie dwóch kluczy innych niż RSA
![](zrzuty_ekranu/keygen1.png)
![](zrzuty_ekranu/keys_dir1.png)
![](zrzuty_ekranu/clone_ssh1.png)
    - Skonfigurowanie klucza SSH pod GitHub
![](zrzuty_ekranu/push_newbranch1.png)
## Przełączanie się pomiędzy gałęziami
![](zrzuty_ekranu/change_to_groupbranch.png)
## Utworzenie gałęzi własnej pod gałęzią grupową 
![](zrzuty_ekranu/new_branch1.png)
![](zrzuty_ekranu/push_newbranch1.png)
## Własny katalog roboczy
## Własny Git Hooke
![](zrzuty_ekranu/.git_dirs.png)
![](zrzuty_ekranu/commit_msg1.png)
![](zrzuty_ekranu/precommit_zle.png)
![](zrzuty_ekranu/exec_file.png)
![](zrzuty_ekranu/chmod_cp_commit_correct.png)
![](zrzuty_ekranu/commit_bez_inicjalow.png)
## Plik ze sprawozdaniem
## Zrzuty ekranu
## Wysyłanie zmian do źródła
![](zrzuty_ekranu/blad_email.png)
![](zrzuty_ekranu/email.png)
![](zrzuty_ekranu/commit_po_email.png)
## Wciągnięcie do gałęzi grupowej