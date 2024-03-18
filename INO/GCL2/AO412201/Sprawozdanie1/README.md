# Sprawozdanie 1

## Opis celu i streszczenie projektu:

Celem zajęć było zapoznanie się z Git'em i jego podstawowymi funkcjami oraz wykorzystanie SSH poprzez wykonanie następujących czynności:

- sklonowanie repozytorium przy użyciu nowo utworzonych kluczy SSH,
- utworzenie własnej gałęzi,
- przesłanie nowych plików do repozytorium źródłowego.
## Wykonane kroki
Do wykonania zadania potrzebne jest użycie systemu operacyjnego opartego na Linux pracujący na maszynie wirtualnej Oracle VirtualBox oraz systemu Ubuntu 22.04.4.LTS. Link do pobrania maszyny: https://www.virtualbox.org/wiki/Downloads oraz Ubuntu: https://ubuntu.com/download/server. Poradnik krok po kroku instalacji znajduje się pod lnkiem: https://www.youtube.com/watch?v=wqm_DXh0PlQ. 
Ważne informacje:
- podczas instalacji zalecane jest zwiększenie ilości CPU do 2,
- przydzielenie 4GB pamięci RAM
- 36GB miejsca na dysku

Nałożenie środowiska Visual Studio Code (https://code.visualstudio.com/download) za pomocą wtyczki SSH można zrealizować w następujących krokach:
- instalacja openssh-client:
```bash
sudo apt install openssh-client
```
- instalacja net-tools i uzyskanie adresu IP:
```bash
sudo apt install net-tools
ifconfig
```

## 1. Instalacja klienta Git i obsługi kluczy ssh:
- instalacja kluenta Git za pomocą komendy:
```bash
apt-get install git
```
- sprawdzenie czy Git został poprawnie zainstalowany komendą:
```bash
git --version
```
- wygenerowanie kluczy ssh komentą:
```bash
ssh-keygen
```


## 2. Sklonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token
- skopiowanie linku do repozytorium GitHub
- użycie komendy: git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

## 3. Dostęp do repozytorium jako uczestnik i skonowanie za pomocą utworzonego klucza SSH:
- zapoznanie się z dokumentacją, gdzie są pokazane kroki: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- użycie komendy:
```bash
  ssh-keygen ed25519 -C "your_email@example.com"
```
- podanie pliku, w którym ma być zapisany klucz, ENTER gdy miejsce zapisu ma być domyślne
- w przypadku wcześniejszego utworzenia klucza pojawi się pytanie o nadpisaniu klucza
![ ](./img/2.png)
- wyświetlenie klucza komendą:
```bash
  cat miejsce_gdzie_został_zapisany_klucz
```
- umieszczenie wygenerowanego klucza na swoim koncie GitHub: Access -> SSH and GPG keys -> New SSH key
 ![ ](./img/1.png)
- analogicznie utworzyć klucz zabezpieczony hasłem:
```bash
  ssh-keygen ecdsa -C "twój_email@example.com"
```
- pobranie repozytorium z wykorzystaniem protokołu SSH: git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git

## 4. Przełączenie na gałąź main, a następnie na gałąź grupy
- użycie komendy: git branch, która wyświetla listy gałęzi w repozytorium
 ![ ](./img/3.png)

## 5. utworzenie własnej gałęzi komendą: git branch nazwa_gałęzi (inicjały&nr indeksu)
- przełączanie się na wybraną gałęź:
 ```bash git switch -c nowa_gałąź (w przypadku tylko dwóch gałęzi wystarczy samo 
polecenie git_switch)
```

## 6. Praca na nowej gałęzi
- utworzenie pustego pustego pliku: touch INO/GCL2/AO412201/Sprawozdanie1/README.md
- napisanie Git hooka, który weryfikuje czy "commit message" zaczyna się od "twoje inicjały & nr indexu", można wzorować się z przykładowych githook'ów używając polecenia .git/hooks
 ![ ](./img/4.png)
- nadanie uprawnień poprzez komendę:
```bash
  chmod +x .git/hooks/commit-msg
```
- plik można edytować za pomocą komendy nano:
```bash
 nano .git/hooks/commit-msg
```
- dodanie skrytpu do stworzonego wcześniej katalogu: cp .git/hooks/commit-msg INO/GCL2/AO412201/Sprawozdanie1/
- zrzuty ekranu są umieszczane jako inline:

  a) stworzenie folderu img w katalogu GCL2 za pomocą komendy:
```bash
mkdir img
```
 - dołączenie do folderu zdjęć, które są wykorzystywane w sprawozdaniu przy wykorzystaniu składni
```bash 
   ![teskt alternatwny](ścieżka do pliku)
```
- wysłane do zdalnego źródła
```bash
git add .
git commit 
git push
```
  ![ ](./img/5.png)
  
- podjęcie próby wciągnięcia swojej gałęzi do gałęzi grupowej:
  - użycie komendy
  ```bash
   git push origin AO412201:GCL2
   ```
- otrzymanie następującego błędu
  
   ![ ](./img/7.png)

  # GIT DOCKER
  ## 1. Zainstalowanie dockera w środowisku Linux'owym
  
```bash
  sudo snap install docker
```
 ![ ](./img/8.png)

  - sprawdzenie zainstalowanej wersji
```bash
  docker -- version
```
 ![ ](./img/9.png)

## 2. Zarejestrowanie się na stronie Docker Hub 
``` bash
  https://hub.docker.com/
```
   ![ ](./img/10.png)

 - zalogowanie się do dockera również w terminalu
``` bash
  docker login
```
- uruchomienie kontenera z obrazem Fedora
   ![ ](./img/11.png)
- wyświetlenie listy działających kontenerów
``` bash
 docker ps
```
   ![ ](./img/12.png)
## 3. Pobranie obrazów hello-world, busybox, ubuntu, fedora, mysql  
  - pobranie obrazów
``` bash
  docker pull busybox
  docker pull hello-world
  docker pull ubuntu
  docker pull mysql
```
   ![ ](./img/13.png)

   - wyświetlenie pobranych obrazów
  ``` bash
   docker image ls
  ```
  ![ ](./img/14.png)

## 4. Uruchomienie konteneru z obrazu busybox
- uruchomienie kontenera na podstawie obrazu BusyBox oraz wyświetlenie listy działających kontenerów
   ``` bash
   docker run busybox
   docker ps
  ```
 ![ ](./img/15.png)

 - wyświelenie wszytkich kontenerów
   ``` bash
   docker ps -a
  ```
 ![ ](./img/16.png)

- uruchomienie kontenera z obrazu ubuntu
    ![ ](./img/17.png)
  "-it" powoduje, że kontener jest uruchamiany w trybie interaktywnym.
  - wywołanie numeru wersji wewnątrz kontenera BusyBox
  ``` bash
    busybox | head -1
  ```
  - opuszczenie kontenera BusyBox
  ``` bash
  exit
  ```
  - wyświetlenie wszytskich kontenerów
  ``` bash
    docker ps -a
  ```
  ![ ](./img/18.png)

 
  ## 5. Uruchomienie systemu w kontenerze

  - podłączenie się do kontenera interaktywnie i wywołanie numeru wersji
  ``` bash
  docker exec -it <CONTAINER_ID> bin/bash
  ```
gdzie: 
    aktualizacja pakietów
    ``` bash
    apt update && apt upgrade -y
    ``` 
    wyjście z kontenera
    ``` bash
    exit
    ``` 

Napotkane błędy
 ![ ](./img/19.png)

 Rozwiązaniem było uruchomienie zatrzymanego kontenera
 
  ![ ](./img/20.png)

Poprawnie działająca komenda
  ![ ](./img/21.png)
  
  ## 6. Stworzenie oraz uruchomienie prostego pliku Dockerfile
  - Podczas tworzenia pliku wzorowano się na wzorze: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
  - stworzony Dockerfile
  ![ ](./img/22.png)
  - stworzenie obrazu w trybie imperatywnym o nazwie dockerfile
  ``` bash
  docker build -t dockerfile .
   ```
  ![ ](./img/23.png)

  - po wyświetleniu wszytskich obrazów, można zauważyć, że znajduje się w nich utworzony wcześniej nasz obraz
  ![ ](./img/24.png)

## 7. Ukazanie uruchomionych kontenerów oraz ich wyczyszczenie
  ![ ](./img/25.png)

  - wyczyszczenie uruchomionych kontenerów, gdzie CONTAINER_ID wpisywałam pierwsze 3 symbole CONTAINER ID
  ``` bash
  docker rm <CONTAINER_ID>
  ``` 
## 8. Wyczyszczenie obrazów
  - wyczyszczenie obrazów
  ``` bash
  docker rmi <CONTAINER_ID>
  ```
gdzie w CONTAINER_ID wpisywałam pierwsze 3 symbole od których zaczyna się IMAGE ID

- napotkanie błędu przy usunięciu jednego obrazu, który mówi, że istnieje kontener który jest na nim oparty
   ![ ](./img/26.png)
- w tym celu należy użyć poniższej komendy, która wymusza usnięcie kontenera
  ``` bash
  docker rmi -f ca2
  ```
  ![ ](./img/27.png)

## 9. Dodanie stworzonych plików Dockerfile do folderu Sprawozdanie1
  ![ ](./img/28.png)

## 10. Wystawienie pull request do gałęzi grupowej

- pushowanie zmian
  ``` bash
  git add .
  git commit -m 
  git push
  ```

  ![ ](./img/30.png)

- napotkane błędy
  ![ ](./img/29.png)


