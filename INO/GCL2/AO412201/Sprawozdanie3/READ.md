## Sprawozdanie 1
Zajęcia 005
# Uruchomienie
1) Konfiguracja wstępna i pierwsze uruchomienie
   - Utworzenie pierwszego prostego projektu, który wyświetla uname
![ ](./img/1.png)
  - utowrzenie projektu, który zwraca błąd, gdy godzina jest nieparzysta
    #!/bin/bash
hour=$(date +%H)
if [ $((hour % 2)) -ne 0 ]; then
    echo "Hour is odd"
    exit 1
else
    echo "Hour is even"
fi
a) uruchomienie o godzinie 19
![ ](./img/2.png)
uruchomienie o godzinie 20
![ ](./img/nieparzysta.png)
2) Utworzenie prawdziwego projektu, który
a) klonuje repozytorium
- wygenerowanie tokenu, jeżeli nie istnieje:
  Github -> Settings -> Developer settings -> Personal access tokens -> Generate new token -> skopiowanie tokenu
- skonfigurowanie sekretów przechowujących mój token dostępu do GitHuba
  Tablica -> Zarządzaj Jenkinsem -> Credentials -> System -> Global Credentials -> +Add Credential
![ ](./img/global_credentias.png)
