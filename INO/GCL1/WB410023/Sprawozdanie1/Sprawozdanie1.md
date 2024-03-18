# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

### Opis celu i streszczenie projektu:

Celem zajęć było zapoznanie się z Git'em i jego podstawowymi funkcjami oraz wykorzystanie SSH poprzez wykonanie następujących czynności: 
- sklonowanie repozytorium przy użyciu nowo utworzonych kluczy SSH,
- utworzenie własnej gałęzi,
- przesłanie nowych plików do repozytorium źródłowego.

Podczas zajęć korzystałam z systemu Ubuntu na Wirtualnej Maszynie.

## Zrealizowane kroki:
### 1. W terminalu zainstalowałam klienta Git. Obsługa kluczy SSH również odbywa się przez terminal.

Zrzut ekranu przedstawiający zainstalowaną wersję Git:

![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image1.png)

### 2. Utworzyłam personal access token.

Wybranie w ustawieniach GitHuba po kolei: 'Developer settings' -> 'Personal access token' -> 'Tokens (classic)' -> 'Generate new token (classic).

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image1d.png)

### 3. Sklonowałam repozytorium https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO za pomocą HTTPS.

Wykorzystane polecenie git wraz ze skopiowanym linkiem do repozytorium:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image2a.png)

### 4. Utworzyłam dwa klucze SSH (inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem).
- Klucz SSH typu ed25519 - klucz szyfrowany zabezpieczony hasłem:

Wykorzystane polecenie git:
```bash
ssh-keygen -t ed25519 -C "weronikaabednarz@gmail.com"
```
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image2b.png)

- Klucz SSH typu ecdsa - klucz szyfrowany algorytmem:

Wykorzystane polecenie git:
```bash
ssh-keygen -t ecdsa -b 521 -C "weronikaabednarz@gmail.com"
```

Wygenerowane klucze zapisałam w katalogu '/home/weronikaabednarz/.ssh/', a następnie dodałam do swojego konta na GitHubie kolejno: 'Settings' -> 'SSH and GPG keys'.

![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image3.png)

### 5. Skonfigurowałam klucz SSH jako metodę dostępu do GitHuba.

Wykorzystane polecenia git:

- Kopiowanie kluczy SSH:
```bash
clip < ~/.ssh/id_ed25519.pub
```
```bash
clip < ~/.ssh/id_ecdsa.pub
```
- Uruchomienie agenta SSH:
```bash
eval $(ssh-agent -s)
```
- Dodanie klucza typu ed25519 do agenta (należy podać hasło wprowadzone przy jego tworzeniu):
```bash
ssh-add ~/.ssh/id_ed25519
```
Zrzut ekranu przedstawiający powyższe kroki:

![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image4.png)

Zrzut ekranu przedstawiający utworzone klucze SSH:

![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image6.png)

### 6. Sklonowałam repozytorium wykorzystujac protokoł SSH.

Wykorzystane polecenie git:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image5.png)

### 7. Przełączyłam się na gałąź ```main```, a następnie na gałąź ```GCL1```.

Wykorzystane polecenia git (git checkout - przełączanie między gałęziami):
```bash
git checkout main

git checkout GCL1
```

### 8. Utworzyłam nową gałąź o nazwie ```WB410023``` oraz odgałęzilam się od brancha grupy.

Wykorzystane polecenia git:
- Utworzenie nowej gałęzi
```bash
git branch WB410023
```
- Odgałęzienie się od aktualnego brancha
```bash
git checkout WB410023
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image7.png)

### 9. W katalogu właściwym dla grupy utworzyłam nowy katalog o nazwie ```WB410023```.

Katalog właściwy dla grupy: /home/weronikaabednarz/Pulpit/MDO2024_INO/INO/GCL1/

Wykorzystane polecenie:
```bash
mkdir WB410023
```
![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image8.png)

### 10. Napisałam Git hook - skrypt weryfikujący, czy każdy mój "commit message" zaczyna się od ```WB410023```. Przykładowe githook'i znajdują się w folderze .git/hooks
### w repozytorium na dysku.

Wykorzystane polecenie:
```bash
nano commit-msg
```
Zrzut ekranu przedstaiwający napisany skrypt:

![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image9.png)

### 11. Następnie dodałam skrypt do utworzonego wcześniej katalogu, a potem skopiowiałam go we właściwe miejsce, tak by uruchamiał się z każdym commit'em.

Wykorzystane polecenia:
```bash
mv commit-msg .git/hooks
```
Dodanie użytkownikowi uprawnień aby plik mogł zostać uruchomiony:
```bash
chmod +x .git/hooks/commit-msg
```
![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image10.png)

### 12. Przetestowałam działanie git hook'a.

Obecna lokalizacja: /home/weronikaabednarz/Pulpit/MDO2024_INO/INO/GCL1/WB410023

Wykorzystane polecenia:
- Stworzenie pliku 'Sprawozdanie1' - plik Markdown
```bash
touch sprawozdanie_lab1.md
```
- Stworzenie folderu 'images'
```bash
mkdir images
```
![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image11.png)

- Przenoszenie nowych i zmodyfikowanych plików, z wyłączeniem plików usuniętych do obszaru roboczego (do commita) w celu zatwierdzenia
```bash
git add .
```
- Commitowanie zmian (błędny sposób wraz z wywołaniem błędu)
```bash
git commit -m "Test"
```
- Commitowanie zmian (poprawny sposób)
```bash
git commit -m "WB410023: first commit"
```
![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image12.png)

### 13. W katalogu dodałam pliki ze sprawozdaniem wraz z zrzutami ekranu (jako inline).

Wykorzystana składnia:
```bash
![teskt alternatwny](ścieżka do pliku)
```

### 14. Wysłałam zmiany do zdalnego źródła.

Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 zmiana struktury katalogow"
```
- Wysłanie zmian do źródła:
```bash
git push origin WB410023
```
![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image14.png)


### 15. Podjęłam próbę wciągnięcia swojej gałąź do gałęzi grupowej.

Wykorzystane polecenia:
- Przełączenie się na gałąź grupy
```bash
git checkout GCL1
```
- Wywołanie merge z własną gałęzią
```bash
git merge WB410023
```
![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image13.png)


### 16. Dodałam zedytowane sprawozdanie oraz zrzuty ekranu.

Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 sprawozdanie"

git push origin WB410023
```

### 17. Wystawiłam Pull Request do gałęzi grupowej.

## Laboratorium 2 - Git, Docker

## Zrealizowane kroki:
### 1. Zainstalowałam Docker w systemie Ubuntu.

Instalacja Docker:
```bash
sudo apt install docker.io
```
![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/instalacja.png)

Sprawdzenie zainstalowanej wersji Docker:
```bash
docker --version
```
![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/1.jpg)

### 2. Zarejestrowałam się w DockerHub oraz zapoznałam  z sugerowanymi obrazami.

Zrzut ekranu przedstawiający zarejestrowane konto w DockerHub:
![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/dockerhub.jpg)

Zalogowanie się do Docker przez terminal:
```bash
docker login
```
![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/2png)

### 3. Pobrałam  obrazy: hello-world, busybox, fedora oraz mysql.

Pobranie obrazów:
```bash
docker pull busybox
docker pull hello-world
docker pull fedora
docker pull mysql
```
![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/3.png)

Wyświetlenie pobranych obrazów:
```bash
docker images
```
![22](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/4.png)

### 4. Uruchomiłam  busybox.

Uruchomienie pobranego obrazu busybox oraz pokazanie efektu uruchomionego kontenera:
```bash
docker run busybox
docker ps
```
Polecenie **docker run busybox** uruchamia kontener BusyBox, aczkolwiek nie zdefiniowano żadnej dodatkowej komendy, więc kontener zostanie uruchomiony i od razu zamknięty -
kończąc swoje działanie. Z tego powodu próba wyświetlenia uruchomionego kontenera poleceniem **docker ps** kończy się niepowodzeniem. 
Do wyświetlenia kontenera zastosowano polecenie **docker ps -a**.

![23](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/5.png)

Podłączenie się do kontenera interaktywnie:
```bash
docker run -it busybox
```
Wywołanie numeru wersji wewnątrz kontenera BusyBox:
```bash
busybox | head -1
```
Opuszczenie kontenera BusyBox:
```bash
exit
```
![24](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/6.png)

Wyświetlenie listy wszystkich uruchomionych kontenerów (-a oznacza zarówno zatrzymane, jak i uruchomione kontenery).
```bash
docker ps -a
```
![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/7.png)

### 5. Uruchomiłam  "system w kontenerze".

Interaktywne uruchomienie systemu fedora:
```bash
docker run -it fedora
```
Opcja **-it** pozwala wysyłać dane do kontenera, np. wprowadzać komendy, które będą wykonywane w środowisku kontenera.

![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/8.jpg)

Zainstalowanie pniezbędnych zależności:

![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/9.jpg)

Prezentacja PID1 wewnątrz kontenera.
```bash
ps
```
Opuszczenie kontenera fedora:
```bash
exit
```
Wyświetlenie listy wszystkich uruchomionych kontenerów (procesów dockera na hoście):
```bash
docker ps -a
```
![27](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/10.jpg)

![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/11.jpg)

Ponowne interaktywne uruchomienie kontenera fedora:
```bash
docker exec -it <CONTAINER_ID> bash
```
Aktualizacja pakietów wewnątrz kontenera:
```bash
dnf update -y
```
Wyjście z kontenera fedora:
```bash
exit
```
![29](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/12.jpg)

### 6. Własnoręcznie utworzyłam, zbudowałam oraz uruchomiłam plik Dockerfile bazujący na wybranym systemie i sklonowałam repozytorium.

Dobre praktyki ze strony: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

Interaktywne uruchomienie kontenera fedora:
```bash
docker exec -it <CONTAINER_ID> bash
```

Sprawdzenie aktualnej wersji git:
```bash
git --version
```
![30](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/13.jpg)

Ponieważ obraz nie miał zainstalowangeo git'a, instalacja git'a w kontenerze i klonowanie repozytorium.

Napisany Dockerfile:
```bash
FROM fedora:latest

RUN dnf update -y && dnf install -y git

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

RUN git clone https://$GITHUB_TOKEN@github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![31](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/14.jpg)

Tworzenie obrazu o nazwie **repocloner** w trybie interaktywnym: wykorzystanie wcześniej utworzonego personal access token - skopiowanie klucza ze schowka:
```bash
docker build --build-arg TOKEN="<TOKEN>" -t repocloner .
```
![32](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/15.jpg)

![33](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/16.jpg)

Wyświetlenie obrazów (w tym nowoutworzony obraz gitcloner):
```bash
docker images
```
![34](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/17.jpg)

Uruchomienie obrazu **gitcloner** w trybie interaktywnym:
```bash
docker run -it gitcloner
```
Weryfikacja i sprawdzenie czy jest tam ściągnięte nasze repozytorium:
```bash
ls
```
Opuszczenie kontenera:
```bash
exit
```
![35](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/18.jpg)

### 7. Wyświetliłam  uruchomione kontenery i wyczyściłam je.

Wyświetlenie listy wszystkich uruchomionych kontenerów:
```bash
docker ps -a
```
Wyczyszczenie uruchomionych kontenerów:
```bash
docker container prune
```
Ponowne wyświetlenie listy wszystkich uruchomionych kontenerów:
```bash
docker ps -a
```
Zatrzymanie nieusuniętego kontenera fedora, i usunięcie go; Ponowne wyświetlenie listy wszystkich uruchomionych kontenerów:
```bash
docker stop cb9

docker rm cb9

docker ps -a
```
![36](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/19.jpg)

### 8. Wyczyściłam pobrane oraz utworzone obrazy.

Wyświetlenie istniejących obrazów:
```bash
docker images
```
Wyczyszczenie obrazów:
```bash
docker image prune -a
```
![37](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/20.jpg)


### 9. Skopiowałam utworzony plik Dockefile do swojego folderu Sprawozdanie1 w repozytorium.

Kopiowanie pliku Dockerfile:
```bash
cp Dockerfile <ścieżka>
```
![38](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie1/images/21.jpg)


### 10. Dodałam zedytowane sprawozdanie oraz zrzuty ekranu.

Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 sprawozdanie, screenshoty i Dockerfile"

git push origin WB410023
```

### 11. Wystawiłam Pull Request do gałęzi grupowej.

