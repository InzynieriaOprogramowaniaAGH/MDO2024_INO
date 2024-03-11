Kinga Kubajewska
# Sprawozdanie nr 1 Wprowadzenie, Git, Gałęzie, SSH
## Cel zajęć:

Wprowadzenie do platformy GitHub oraz zrozumienie, jak działa system zarządzania repozytoriami. Poznanie różnic między repozytorium lokalnym, a zdalnym. Nauka podstawowych poleceń do obsługi GitHuba, umożliwiających modyfikowacje plików na własnych gałęziach.

W laboratorium korzystano z maszyny wirtualnej stworzonej przy użyciu OpenSUSE oraz oprogramowania do wirtualizacji VMware. Wykonywano zadania za pomocą połączenia SSH w programie Visual Studio Code.

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
![Screen1](./screen/screen1.png)
### 2. Klonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token.

Na początku w serwisie Github wygenerowano Personal Access Token, który jest wykorzystywany głównie do autoryzacji dostępu do zasobów:

![Screen2](./screen/screen2.png)
Dzięki tokenowi możliwe jest sklonowanie repozytorium za pomocą komendy:
```bash
git clone https://username:personal_access_token@github.com/user/repo.git
```
Sklonowania repozytorium za pomocą HTTPS dokonano komendą:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
### 3. Klonowanie repozytorium za pomocą protokołu SSH.
* pracę rozpoczęto od zapoznania się z dokumentacją,
* następnie utworzono dwa klucze SSH (ecdsa oraz ED25519), w tym co najmniej jeden zabezpieczony hasłem:
  klucz zabezpieczony hasłem wygenerowano za pomoca komendy:
  
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

* treść githooka można odczytać poprzez komendę
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

* Utworzono katalog o nazwie screen, gdzie zdodano zrzuty ekranu wpisywanych poleceń.
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

  







