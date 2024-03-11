Kinga Kubajewska
# Sprawozdanie nr 1 Wprowadzenie, Git, Gałęzie, SSH
## Cel zajęć

Wprowadzenie do platformy GitHub oraz zrozumienie, jak działa system zarządzania repozytoriami. Poznanie różnic między repozytorium lokalnym a zdalnym. Nauka podstawowych poleceń do obsługi GitHuba, umożliwiających modyfikowacje plików na własnych gałęziach.

W laboratorium korzystano z maszyny wirtualnej stworzonej przy użyciu OpenSUSE oraz oprogramowania do wirtualizacji VMware. Wykonywano zadania za pomocą połączenia SSH w programie Visual Studio Code.

## Przebieg ćwiczenia
### 1. Instalacja klienta Git i obsługi kluczy SSH
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
SCREEN NUMER 1

### 2. Klonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token

Na początku w serwisie Github wygenerowano Personal Access Token, który jest wykorzystywany głównie do autoryzacji dostępu do zasobów na platformie GitHub:

SCREEN 2

Dzięki tokenowi możliwe jest sklonowanie repozytorium za pomocą komendy:
```bash
git clone https://username:personal_access_token@github.com/user/repo.git
```
Sklonowania repozytorium za pomocą HTTPS dokonano komendą:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
### 3. Sklonowanie repozytorium za pomocą protokołu SSH.
* pracę rozpoczęto od zapoznania się z dokumentacją,
* następnie utworzono dwa klucze SSH (ecdsa oraz ED25519), w tym co najmniej jeden zabezpieczony hasłem:
  klucz zabezpieczony hasłem wygenerowano za pomoca komendy:
  
```bash
ssh-keygen -t ecdsa -C "kubajewska@student.agh.edu.pl"
```
SCREEN3

  drugi klucz wygenerowano za pomocą komendy:
  
```bash
ssh-keygen ed25519 -C "kubajewska@student.agh.edu.pl"
```
W katalogu .ssh znajdują się wygenerowane klucze w dwóch wersjach: publicznej i prywatnej.

SCREEN4

Zawartości poszczególnych kluczy wyświetlono za pomocą komendy:
```bash
cat id_ecdsa.pub
cat id_ed25519.pub
```
SCREEN5

Następnie owe zawartosci umieszczono na koncie GitHub: Settings -> SSH and GPG keys -> New SSH key

SCREEN 6

Dzięki temu możliwe jest sklonowanie repozytorium za pomocą komendy:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
### 4. Przełączenie się na gałąź main, a potem na gałąź swojej grupy.
Na poczatku sprawdzono w jakim miejscu gałęzi obecnie znajduje sie poprzez komendę:
```bash
git brach
```
Aby zobaczyć wszystkie gałęzie dostępne w repozytorium, używa się polecenia:
```bash
git branch --all
```
SCREEN 7

SCREEN został zrobiony po wykonaniu całej instrukcji, dlatego pokazuje już utworzony branch KK406795 co zostanie opisane poniżej.

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
* następnie napisano Git hooka - skrypt weryfikujący, że każdy "commit message" zaczyna się od "twoje inicjały & nr indexu"
Zmodyfikowano plik o nazwie "commit-msg.sample" znajdujący się w folderze ".git/hooks". Umieszczono w nim skrypt i zmieniono jego nazwę na "commit-msg". Dzięki tej zmianie skrypt będzie automatycznie wykonywany za każdym razem, gdy dokonywane jest commitowanie.
* po zmodyfikowaniu pliku "commit-msg.sample" i zmianie jego nazwy na "commit-msg", skopiowano ten plik do katalogu o nazwie "KK406795".
* poprzez polecenie chmod +x zmieniono prawa dostępu do pliku. Plik może być wykonywalny.
  
SCREEN 8

* treść githooka można odczytać poprzez komendę
```bash
nano .git/hooks/commit-msg
```
SCREEN 9

Poniżej komunikaty otrzymane po komendzie:
```bash
git commit -m "Test"
git commit -m "KK406795 commit"
```
SCREEN 10

* W katalogu dodano plik ze sprawozdaniem
  
SCREEN 11

* Utworzono katalog o nazwie screen, gdzie znajdują się zrzuty ekranu wpisywanych poleceń.
* Dodano zrzuty ekranu (jako inline) poprzez polecenie:
  







