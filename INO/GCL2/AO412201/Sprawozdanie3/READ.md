## Sprawozdanie 1
Zajęcia 005
# Uruchomienie
1) Konfiguracja wstępna i pierwsze uruchomienie
   - Utworzenie pierwszego prostego projektu, który wyświetla uname
![ ](./images/1.png)
  - utowrzenie projektu, który zwraca błąd, gdy godzina jest nieparzysta
```bash
    #!/bin/bash
hour=$(date +%H)
if [ $((hour % 2)) -ne 0 ]; then
    echo "Hour is odd"
    exit 1
else
    echo "Hour is even"
fi
```
a) uruchomienie o godzinie 19
![ ](./images/2.png)

uruchomienie o godzinie 20
![ ](./images/nieparzysta_godzina.png)

2) Utworzenie prawdziwego projektu, który:
a) klonuje repozytorium
- wygenerowanie tokenu, jeżeli nie istnieje:
  Github -> Settings -> Developer settings -> Personal access tokens -> Generate new token -> skopiowanie tokenu
![ ](./images/token_password.png)
- skonfigurowanie sekretów przechowujących mój token dostępu do GitHuba
  Tablica -> Zarządzaj Jenkinsem -> Credentials -> System -> Global Credentials -> +Add Credential
![ ](./images/global_credentias.png)
- skonfigurowanie dostępu projektu Jenkinsowego do repozytorium:
W zakładce 'Repozytorium kodu' należy zazaczyć zakładkę 'Git' i uzupełnić ją następującymi informacjami:
   - Repository URL: link do repozytorium, z którego Jenkins będzie pobierał kod.
   - Credentials: dane, których Jenkins będzie używać do autoryzacji dostępu do repozytorium Git.
   - Branches to build: dla jakich branch'y Jenkins ma budować zadania i uruchamiać
  ![ ](./images/klonowanie.png)
- ustawienie zmiennej środowiskowej przechowującej GitHub token, korzystając z sekretu
![ ](./images/środowisko_do_uruchomienia.png)
b) buduje obrazy z dockerfiles i/lub komponuje via docker-compose
```bash
docker build --build-arg TOKEN=$GITHUB_TOKEN -t my_docker_build -f MDO2024/INO/GCL2/AO412201/Sprawozdanie2/Dockerfile .
cd MDO2024/INO/GCL2/AO412201/Sprawozdanie3/
docker compose build
```
- uruchomienie build'a
![ ](./images/docker_compose_build.png)
- uruchomienie projektu w Jenkinsie oraz zakończenie się sukcesem
![ ](./images/real_project.png)

3) 
