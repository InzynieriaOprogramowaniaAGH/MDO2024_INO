# Sprawozdanie 1
Krystian Gliwa, IO.

## Cel projektu
Celem tego ćwiczenia jest...

## Streszczenie projektu

## Zajęcia 1

### Instalacja klienta Git i obsługe kluczy SSH

Klienta Git oraz OpenSSH służące do obsługi kluczy SSH pobrałem juz podczas instalacji Ubuntu na wirtualnej maszynie (zaznaczając odpowiednie dodatki przy instalacji). Jednak aby się upewnić że takowe są i działają na moim serwerze użyłem poleceń do sprawdzania wersji zainstalonych programów:
```
git --version
ssh -V
```
![wersja Gita i OpenSSH](./zrzuty_ekranu/1.jpg)

### Klonowanie za pomocą HTTPS i personal access token

Do kolonowania za pomocą HTTPS i personal access token konieczne było utworzenie nowego tokenu na Githubie wybierając: **Settings/Developer Settings** i tam Personal access tokens (classic), po czym wpisać notatke do tokenu oraz zdefiniować jego dostęp: 

![Tworzenie personal access token](./zrzuty_ekranu/2.jpg)

Po utworzeniu tokenu użyłem go do sklonowania repozytorium za pomocą HTTPS poleceniem: 
```
git clone https://username:personal_access_token@github.com/owner/nazwa_repozytorium.git
``` 
W moim przypadku było to: 

![klonowanie za pomoca HTTPS](./zrzuty_ekranu/3.jpg)

### Klonowanie za pomocą utworzonego klucza SSH

Aby sklonować repozytorium za pomocą klucza SSH najpierw musiałem go utworzyć. Utworzyłem dwa, pierwszy zabezpieczony hasłem utworzyłem poleceniem: 
```
ssh-keygen -t ed25519 -C "ja.krystian3243@gmail.com"
```
natomiast drugi:
```
ssh-keygen -t ecdsa -C "ja.krystian3243@gmail.com"
```
![pierwszy klucz ed25519](./zrzuty_ekranu/4.jpg)
![drugi klucz ecdsa](./zrzuty_ekranu/5.jpg)