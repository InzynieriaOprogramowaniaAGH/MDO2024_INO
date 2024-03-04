# Zajęcia 01
### 04-03-2024
---
# Wprowadzenie, Git, Gałęzie, SSH
Celem zadania było zapoznanie się z Gitem oraz SSH poprzez zklonowanie repozytorium za pomocą nowo utworzonych kluczy SSH, stworzenie własnej gałęzi i wysłanie nowych plików do źródła.

Zadanie wykonałem na systemie Ubuntu Server (ze wzlędu na znajomość dystrybucji) wirtualizowanym w Hyper-V.
# Zadania do wykonania
## 1. Zainstaluj klienta Git i obsługę kluczy SSH
Do instalacji klienta Git użyłem polecenia: `sudo apt-get install git`

Instalacja SSH odbywa się poprzez polecenia `apt-get install openssh-client/openssh-server`. 

SSH było u mnie domyślnie zainstalowe.
## 2. Sklonuj [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO) za pomocą HTTPS i [*personal access token*]((https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens))
Repozytorium sklonowałem poleceniem:
```
git clone <link do repozytorium> [<folder docelowy>]
```
![Wykonanie polecenia](https://puu.sh/K2cK1/4fbf844ae1.png)

Personal access token wygenerowałem w ustawieniach GitHuba w zakładce Developer settings.

![Wygenerowany token](https://puu.sh/K2cLC/223f6ee763.png)

Git nie poprosił mnie o access token prawdopodobnie ze względu na zcachowane dane. Spodziewałem się poniższego prompta:
```
$ git clone https://github.com/USERNAME/REPO.git
Username: YOUR_USERNAME
Password: YOUR_PERSONAL_ACCESS_TOKEN
```
## 3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
- Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem
    - Skonfiguruj klucz SSH jako metodę dostępu do GitHuba
   - Sklonuj repozytorium z wykorzystaniem protokołu SSH

Do utworzenia kluczy SSH użyłem polecenia ssh-keygen. Stworzyłem klucz szyfrowany algorytmem **ecdsa** oraz zabezpieczony hasłem klucz szyfrowany **ed25519**. Wygenerowane klucze zapisałem w folderze *.ssh* w katalogu domowym.

![Generowanie klucza](https://puu.sh/K2cMV/c7b45367e5.png)

Składnia polecenia zgodnie z [dokumentacją GitHuba](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):
```
ssh-keygen -t <algorytm> -C <adres email>
```
Wygenerowany klucz publiczny (rozszerzenie .pub) dodałem do swojego konta na GitHubie w zakładce ustawień *SSH and GPG keys*.

![Dodany klucz](https://puu.sh/K2cQ7/7d4435a4bf.png)

Następnie uruchomiłem ssh-agenta i dodałem klucz prywatny za pomocą poleceń:
```
eval "$(ssh-agent -s)"
ssh-add <ścieżka do klucza>
```
Dodanie klucza wiązało się z podaniem hasła ustalonego przy jego tworzeniu.

Na koniec sklonowałem repozytorium używając protokołu SSH poprzez wywołanie polecenia:
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
## 4. Przełącz się na gałąź ```main```, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)
Po wejściu do katalogu zawierającego sklonowane repozytorium, można sprawdzić gałąź, na której obecnie pracujemy, za pomocą polecenia `git branch`. Pozostałe gałęzie można ujawnić używająć `git branch --remotes`

Do przełączania między gałęziami stosuje się polecenie: `git checkout <nazwa gałęzi>`

W przypadku grupy 1 należało wykonać ciąg poleceń:
```
git checkout main
git checkout GCL1
```
Poniżej można zauważyć dostępne gałęzie, w tym gałęzie grup GCL1 oraz GCL2

![Przełączanie między gałęziami](https://puu.sh/K2cRU/bc0817d694.png)
## 5. Utwórz gałąź o nazwie "inicjały & nr indeksu" np. ```KD232144```. Miej na uwadze, że odgałęziasz się od brancha grupy!
Tworzenie gałęzi również odbywa się poprzez polecenie `git checkout` tylko tym razem z parametrem `-b`. Tworzy ono na nową gałąź i przełącza na nią użytkownika.
```
git checkout -b TD412544
```
Alternatywnie można wykonać sekwencję poleceń:
```
git branch TD412544
git checkout TD412544
```
## 6. Rozpocznij pracę na nowej gałęzi
### 1. W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```
W katalogu `<sklonowane repozytorium>/INO/GCL1/` utworzyłem katalog `TD412544`.
```
mkdir TD412544
```
### 2. Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
Git hooka napisałem w bashu bazując na pliku `commit-msg.sample`. Wykorzystałem polecenie cut żeby wyciągnąć pierwsze słowo wiadomości i sprawdzić czy spełnia założenia.

![Zawartość Git hooka](https://puu.sh/K2cVZ/58ba74b548.png)

W przypadku w którym hook `commit-msg` zwróci wartość różną od 0, commit nie zostanie przepuszczony, a wyświetlana wiadomość poinformuje użytkownika co powinien zmienić. 

Skrypt przyjmuje ścieżkę do tymczasowego pliku z wiadomością jako parametr, co pozwala na sprawne odczytanie wiadomości i zwrócenie błędu gdy jest nieodpowiednia.
### 3. Dodaj ten skrypt do stworzonego wcześniej katalogu.
Skrypt należało umieścić w katalogu podpisanym numerem indeksu - w tym przypadku `TD412544`.

Skopiowałem go z folderu `.git/hooks`, dlatego że tam umieściłem gotowy skrypt za pomocą SFTP.

![Kopiowanie hooka](https://puu.sh/K2cY3/c9875b0f39.png)

### 4. Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
Skrypt powinien znajować się w katalogu `<sklonowane repozytorium>/.git/hooks`. Ja wrzuciłem go tam wyjściowo poprzez SFTP za pomocą oprogramowania FileZilla.

Plik nosi nazwę `commit-msg`, a nazwa jest narzucona z góry. Jeśli taki plik istnieje to git spróbuje uruchomić skrypt przed wykonaniem faktycznego commita. 

Żeby skrypt mogł zostać uruchomiony koniecznym jest dodanie użytkownikowi uprawnień do uruchamiania tego pliku za pomocą polecenia:
```
chmod u+x <ścieżka do pliku>
```
### 5. Umieść treść githooka w sprawozdaniu.
Treść githooka jest zawarta w zrzucie ekranu powyżej, ale zamieszczę go ponownie w formie tekstowej:
```
#!/bin/bash

test=$(cut -d " " -f1 $1)
if [ $test != "[TD412544]" ]; then
        echo "Message should start with [TD412544]"
        exit 1
fi
```
### 6. W katalogu dodaj plik ze sprawozdaniem
Sprawozdanie umieściłem w następującej ścieżce `<kierunek>/<grupa>/<inicjały><numerIndeksu>/Sprawozdanie1/README.md`

![Plik w katalogu](https://puu.sh/K2d10/f03543665c.png)

Pracę nad plikiem wykonuję na bierząco w Visual Studio Code za pomocą SSH, ze względu na wygodne wsparcie dla plików markdown.

### 7. Dodaj zrzuty ekranu (jako inline)
W plikach markdown można w łatwy sposób dodać zrzuty ekranu za pomocą składni:
```
![teskt alternatwny](ścieżka do pliku)
```
Tekst alternatwny jest wyświetlany gdy nie można zlokalizować obrazu.

Przykłady zrzutów ekranu można zaobserwować powyżej.

### 8. Wyślij zmiany do zdalnego źródła
Na początku należy dodać zmieniane pliki do commita za pomocą:
```
git add <ścieżka>
```
Następnie wykonać commit zmian poleceniem:
```
git commit -m <message>
```
Na koniec wystarczy wysłać wszystkie zmiany do źródła stosująć polecenie:
```
git push
```

![wynik polecenia git push](https://puu.sh/K2d57/a12568b638.png)

Po wykonaniu `git push` można znaleźć wprowadzone zmiany na GitHubie w swojej gałęzi. Zrzut ekranu prezentuje również działąnie napisanego githooka.

### 9. Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
Złączenie gałęzi odbywa się poprzez wykonanie polecenia `git merge` w gałęzi docelowej. Należy przełączyć się na gałąź grupy GCL1 i wywołać merge z własną gałęzią.
```
git checkout GCL1
git merge TD412544
```
![Wynik polecenia git merge, jest (hehe) git](https://puu.sh/K2d98/846c61e8c5.png)

Na zrzucie ekranu można zauważyć, że merge przeszedł bez żadnych konfliktów. Pozostaje przepchnąć gałąź do repozytorium za pomocą:
```
git push
```
![Wynik polecenia git push - błąd, branch protection](https://puu.sh/K2d9a/71f02b1391.png)

Na zrzucie widać błąd spowodowany ochroną gałęzi - ograniczeniami przed nieporządanym złączeniem gałęzi. Należy złożyć pull request do akceptacji.

### 10. Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)
Aktualizację wykonuję sekwencją poleceń
```
git commit
git push
```
### 11. ~~Wystaw Pull Request do gałęzi grupowej~~
### 12. ~~Zgłoś zadanie (Teams assignment - jeżeli dostępne)~~