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