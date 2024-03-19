# Sprawozdanie 1 
## Benjamin Pacuta [BP413049]
---
### 1. Instalacja klienta Git i obługi kluczy SSH

- Instalacja git na maszynie wirtualnej Ubuntu.
```
$ sudo apt-get update
$ sudo apt-get install git
```
-  Instalacja SSH
```
$ sudo apt install openssh-client
$ sudo apt install openssh-server
```
-  Zrzut ekranu przedstawiający zainstalowane wersje

![ss1](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20013221.png)

---
### 2. Sklonowanie repozytorium za pomocą klucza SSH

- Wygenerowanie par kluczy SSH

```
$ ssh-keygen -t ed25519 -C "email"
```

![ss2](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20014941.png)

- Konfiguracja klucza jako metody dostępu do GitHuba

Do wyciągnięcia klucza publicznego wykorzystano komendę `cat ~/.ssh/id_ed25519.pub`

![ss3](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20015340.png)

- Sklonowanie repozytorium z wykorzystaniem protokołu SSH

```
$ git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```

![ss4](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20015450.png)

---
### 3. Visual Studio Code do pracy nad projektem

- Instalacja wtyczki Remote SSH w Visual Studio Code

![ss5](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-12%20002353.png)

- Na maszynie wirtualnej odszukanie adresu ip (inet)
```
$ ifconfig
```

![ss6](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20021334.png)

---
### 4. Przełączenie na gałąź main, następnie na gałąź swojej grupy

- Wyświetlenie listy gałęzi w repozytorium
```
$ git branch
```
- Utworzenie nowej gałęzi
```
$ git checkout
```
- Utworzenie nowej gałęzi i jednoczesne przełączenie się na nią
```
$ git checkout -b 
```

- Zrzut ekranu przedstawiający utworzenie nowej gałęzi o nazwie "inicjały & nr indeksu" oraz folderu i pliku ze sprawozdaniem Sprawozdanie1.md

![ss7](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20031012.png)

- Utworzenie nowego folderu "Sprawozdanie1"
```
$ mkdir -p
```
Opcja -p tworzy wszystkie katalogi nadrzędne, które nie istnieją.

---
### 5. Utworzenie git hooka - skryptu weryfikującego

- Przejście do katalogu z hookami Git

```
$ cd ./.git/hooks/
```
- Stworzenie pliku hooka

```
$ nano commit-msg
```

- Napisanie skryptu weryfikującego wiadomości commitów

![ss10](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20234028.png)

- Upewnienie, że plik hooka jest wykonywalny
```
$ chmod +x commit-msg
```
---
### 6. Wysyłanie zmian do zdalnego źródła

- Wyświetlanie informacji o aktualnym stanie repozytorium

```
$ git status
```

- Dodanie wszystkich zmienionych plików wewnątrz katalogu `ITE` do indeksu w repozytorium 

```
$ git add ITE/*
```

![ss8](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20031133.png)

- Zatwierdzenie zmian w repozytorium Git wraz z wiadomością

```
$ git commit -m "wiadomosc"
```

- Wysłanie zatwierdzonych zmian (commitów) z lokalnego repozytorium Git do zdalnego

```
$ git push
```

![ss9](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-11%20031517.png)

- Przetestowanie działania hooka

![ss11](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-12%20004023.png)

### 7. Instalacja docker na ubuntu

- Wykonanie kolejno poleceń

```
$ sudo apt update
```
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
```
```
$ sudo apt install docker-ce docker-ce-cli containerd.io -y
```
```
$ sudo usermod -aG docker $USER
```
```
$ newgrp docker
```
```
$ sudo systemctl status docker
```
![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20154235.png)

### 8. Pobranie obrazów

- Pobranie obrazów hello-world, busybox, ubuntu, mysql

```
$ sudo docker pull hello-world
```
```
$ sudo docker pull busybox
```
```
$ sudo docker pull ubuntu
```
```
$ sudo docker pull mysql
```

- Zrzut ekranu prezentujący wszystkie pobrane obrazy

![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20155021.png)

### 9. Uruchomienie kontenera z obrazu busybox

```
$ sudo docker run --tty busybox
```
- Opcja  `-tty` podpięcie obecnego terminala do kontenera
```
$ sudo docker run -d  --name nazwa busybox tail -f /dev/null
```
- `-d` kontener będzie działał w tle
- `-- name` przypisuje określoną nazwę do kontenera
- `tail -f /dev/null/` popularny sposób aby utrzymać kontener uruchomiony w nieskończoność, nie wykonując żadnych faktycznych operacji

### 10. Podłączenie interaktywnie do kontenera
```
$ docker exec -it my_busybox sh
```
- `-it` opcja trybu interaktywnego, umożliwia interaltywną seesję z kontenerem
- `sh` określa, które polecenie zostanie uruchomione w kontenerze

Przy próbie sprawdzenia numeru wersji otrzymuję `applet not found`
może to oznaczać, że polecenie busybox w mojej konfiguracji nie zawiera wbudowanego polecenia do wyświetlania wersji.

![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20162020.png)

- Uruchomione kontenery
![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20162411.png)

- Zakończenie pracy kontenera
```
$ docker stop nazwa_kontenera
```
### 11. "System w kontenerze"

- Uruchomienie kontenera z obrazu ubuntu

```
$ docker run -it --name system-container ubuntu /bin/bash
```

- Wyświetlenie PID1 oraz pracesów dockera na hoście

```
# PID1 w kontenerze
$ ps -p 1

# Procesy Dockera na hoście
$ ps aux | grep docker
```

- Aktualizacja pakietów w kontenerze Ubuntu

```
$ apt update
$ apt upgrade
```
- Wyjście z kontenera

```
$ exit
```

![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20162827.png)


### 12. Plik Dockerfile

- Utworzenie pliku
- Zbudowanie obrazu
```
$ docker build -t moj_obraz .
```
![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20164420.png)

- Sprawdzenie obrazów

![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20164559.png)

- Uruchomienie kontenera z utworzonego obrazu `moj_obraz`

```
$ docker run moj_obraz
```
![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20164810.png)

Pomyślnie udało się sklonować repozytorium.


- Aktywne kontenery

```
$ docker ps -a
```
![](../Sprawozdanie%201ss/Zrzut%20ekranu%202024-03-19%20164920.png)

- Usuwanie kontenerów
```
$ docker rm nazwa_kontenera
```

```
$ docker rm id_kontenera
```




