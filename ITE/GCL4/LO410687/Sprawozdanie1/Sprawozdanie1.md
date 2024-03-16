# Sprawozdanie 1
## Łukasz Oprych nr albumu 410687

## Lab1
Celem pierwszych zajęć było zapoznanie się z system kontroli wersji `Git` oraz platformą `Github`.

Ćwiczenie wykonano na maszynie wirtualnej Fedora wersja 39 przy użyciu Hyper-V, komunikowano się z nią przy użyciu SSH oraz Visual Studio Code z zainstalowaną wtyczką Remote-SSH. 

### 1. Zainstaluj klienta Git oraz obsługę kluczy ssh
Pierwszym krokiem, który należy wykonać jest zainstalowanie klienta git

Aktualizacja menadżera pakietów
```
sudo dnf update
```
Instalacja git-a przy użyciu komendy `sudo dnf install git`
następnie w  celu weryfikacji instalacji gita można sprawdzić następującą komendą 
```
git --version
```
Następnie instalujemy obsługę kluczy ssh używając `sudo dnf install openssh-server`
Następnie uruchomiamy usługę ssh komendami
`sudo systemctl enable sshd` i `sudo systemctl start sshd`
### 2. Sklonuj repozytorium przedmiotowe za pomocą HTTPS i personal access token
Po wykonaniu powyższych instrukcji należy utworzyć klucz ssh przy użyciu 
```
ssh-keygen -t ed25519 -C "email"
```
gdzie -t oznacza rodzaj wygenerowanego klucza, w naszym przypadku klucz typu ed25519 oraz -C komentarz służący identyfikacji klucza

Następnie wygenerowaniu klucz publiczny zamieszczamy na githubie w ustawieniach w sekcji `SSH and GPG keys`



## Lab2 
Celem drugich zajęć było zapoznanie się z narzędziem `Docker` oraz tworzeniem `Dockerfile`.