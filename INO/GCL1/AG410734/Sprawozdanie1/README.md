# Sprawozdanie 1
## Część 1 - Git
Do zrealizowania zadania wykorzystałam VirtualBox, który już wcześniej miałam zainstalowany na moim urządzeniu. Wystąpił mały problem z połączeniem się przez ssh ale po zmianie NAT na mostkowaną kartę sieciową połączyłam się. 

Sprawdzenie wersji git i openSSH:

![](screeny/1.png)

### Klonowanie repozytorium
W pierwszym kroku sklonowałam repozytorium z Githuba za pomocą personal access token.
W tym celu weszłam w zakładkę `Settings/Developer settings/Personal access tokens` i klinęłam "Generate new token"

Fragment wygenerowanego tokenu:

![](screeny/2.png)

Następnie sklonowałam repozytorium przy użyciu polecenia:
```
git remote set-url origin https://username:token@github.com/username/repository.git
```
gdzie:
**username** to  nazwa użytkownika na GitHubie.
**token** to personal access token (PAT).
**repository.git** to nazwa repozytorium.

![](screeny/3.png)

W drugim kroku wygenerowałam trzy klucze ssh - jeden typu RSA i dwa typu ECDSA o różnej długości klucza, w tym jeden zabezpieczony hasłem.

Do wygenerowania jednego z kluczy użyłam polecenia:
```
ssh-keygen -t ecdsa -b 384 -f ścieżka/gdzie/ma/być/umieszczony/klucz prywatny -N "hasło"
```
W powyższym poleceniu -t ecdsa oznacza wybór algorytmu ECDSA, a -b 384 określa długość klucza (w bitach). Parametr -f określa nazwę i lokalizację pliku, do którego zostanie zapisany klucz prywatny. Parametr -N określa hasło dla klucza prywatnego.

![](screeny/4.png)

Używanie parametru -N nie jest najbezpiczniejszą opcją, ponieważ polecenie jest przechowywane w historii. Lepszym rozwiązaniem jest wprowadzanie go podczas interaktywnego procesu generowania klucza.

Po wygenerowaniu klucza, skopiowałam jego publiczną wersję i dodałam na githuba w zakładce `Settings/SSH and GPG keys`:

![](screeny/6.png)

Sklonowałam repozytorium za pomocą klucza ssh poleceniem:
``` 
git clone
 ```

![](screeny/7.png)

### Tworzenie gałęzi

Upewniłam się że jestem na gałęzi grupy za pomocą polecenia:
```
git status
```

Będąc na gałęzi grupy, stworzyłam własną gałąź za pomocą polecenia:
``` 
git checkout -b "AG410734"
```
Wypchałam ją na zdalne repozytorium przy użyciu:
```
git push --set-upstream origin AG410734
```

--set-upstream origin AG410734 - dzięki tej części polecenia ustawiłam gałąź zdalną "AG410734" jako gałąź śledzoną (upstream) dla gałęzi lokalnej.

### Git hook
Git Hooks to skrypty wykonywane automatycznie przez system Git w odpowiedzi na określone zdarzenia, takie jak wykonanie commita, przeprowadzenie pusha, czy otrzymanie nowych zmian z zdalnego repozytorium. Skrypty te można dostosowywać do własnych potrzeb i są przechowywane w katalogu .git/hooks wewnątrz lokalnego repozytorium Git.

W naszym przypadku chcieliśmy dodać git hooka, który umożliwiałby sprawdzenie poprawności nazwy commita. 
W tym celu przeszłam do folderu MDO2024_INO, poleceniem:
```
ls -a
``` 
wyświetliłam wszystkie katalogi i odnalazalam folder /.git, w którym to znajduje się poszukiwany folder /.hooks z przykładowymi hookami. 
Zdecydowałam się zedytować hook commit-msg. Następnie usunęłam z nazwy pliku ".sample", co umożliwiło wykonanie hooka w momencie commitowania. Zawartość hooka:
```
#!/bin/bash

# Pobierz nazwę commita
commit_msg=$(cat "$1")

# Sprawdź, czy nazwa commita zaczyna się od "AG410734"
if [[ ! "$commit_msg" =~ ^AG410734.* ]]; then
    echo "Błąd: Nazwa commita musi zaczynać się od 'AG410734'!"
    exit 1
fi

# Wyjście z kodem 0 oznacza, że nazwa commita jest poprawna
exit 0
```

Działanie hooka po wprowadzeniu błędnej nazwy commita:

![](screeny/8.png)

Działanie hooka po poprawnym wprowadzeniu nazwy:

![](screeny/9.png)

Wypchałam plik zawierający treść hooka na zdalne repozytorium za pomocą polecenia:
```
git push
```
### Inne często używane komendy git

`git add <nazwa_pliku>` - dodaje zmiany w plikach do indeksu (staging area) w celu przygotowania ich do zatwierdzenia.

`git init ` - inicjuje nowe repozytorium Git w bieżącym katalogu.

`git branch`- wyświetla listę dostępnych gałęzi (branchy) oraz aktualną gałąź.

`git merge <nazwa_gałęzi>` - łączy aktualną gałąź z inną gałęzią.

`git pull ` pobiera najnowsze zmiany z repozytorium zdalnego i scal je z bieżącą gałęzią.

`git diff` - wyświetla różnice między bieżącym stanem a ostatnim zatwierdzeniem.

`git reset <plik>` - resetuje zmiany w określonym pliku, przywracając go do stanu w ostatnim zatwierdzeniu.

## Część 2 - Docker
Docker to platforma oprogramowania umożliwiająca pakowanie, wysyłanie i uruchamianie aplikacji w przenośnych kontenerach, co ułatwia zarządzanie środowiskami deweloperskimi oraz wdrażanie aplikacji.
Kontenery w Dockerze wykorzystują technologię izolacji na poziomie systemu operacyjnego, co oznacza, że dzielą zasoby systemowe z hostem, ale działają w odizolowanym środowisku. Kontenery zawierają tylko niezbędne elementy aplikacji i zależności, co pozwala na ich lekkie i szybkie uruchamianie. Dodatkowo, Docker umożliwia zarządzanie kontenerami za pomocą obrazów, które zawierają wszystkie niezbędne składniki aplikacji oraz konfiguracje.

### Instalacja Dockera

Zainstalowałam niezbędne pakiety, aby móc korzystać z repozytorium HTTPS, następnie dodałam oficjalny klucz GPG Dockera, kolejnym poleceniem dodałam  repozytorium Dockera do systemu Ubuntu. W ostatnim kroku zaktualizowałam listę pakietów i zainstalowałam Dockera:

![](screeny/10.png)

Sprawdziłam czy Docker został prawidłowo zainstalowany:

![](screeny/11.png)

### Obrazy 

W Dockerze obraz jest szablonem do tworzenia kontenerów. Można myśleć o nim jako o pakiecie zawierającym wszystko, co jest potrzebne do uruchomienia aplikacji - kod źródłowy, środowisko uruchomieniowe, biblioteki, narzędzia itp. Obraz Dockerowy jest niezmienny i tylko do odczytu, co oznacza, że ​​nie można go zmieniać po jego utworzeniu. Wszystkie zmiany muszą być wprowadzane poprzez tworzenie nowego obrazu lub w czasie działania kontenera opartego na danym obrazie.

Obrazy Dockerowe są tworzone na podstawie plików konfiguracyjnych zwanych Dockerfile, które określają kroki niezbędne do skonfigurowania i zbudowania obrazu. Dockerfile zawiera instrukcje, które Docker używa do budowania obrazu, takie jak dodawanie plików, instalowanie pakietów, ustawianie zmiennych środowiskowych itp.
Na początek mieliśmy pobrać przykładowe obrazy: `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`

Aby pobrać obraz należy użyć polecenia:
```
docker pull <nazwa_obrazu>
```

Ściągnięcie niektórych obrazów wymaga uwierzytelniania, można to zrobić logując się do DockerHub'a za pomocą polecenia:
```
docker login
```
Przykładowy wydruk terminala po ściągnięciu obrazów:

![](screeny/12.png)

Uruchomienie kontenera z obrazu następuje po użyciu polecenia:
```
docker run <nazwa_obrazu>
```
Aby wyświetlić wszystkie obrazy, używamy polecenia:
```
docker images
```
Zrzut ekranu moich obrazów:

![](screeny/15.png)

Uruchomienie kontenera z obrazu `busybox`:

![](screeny/13.png)

Wykorzystanie parametru `-it` umożliwia połączenie się do kontenera interaktywnie.

Odczytałam numer wersji jądra Linux za pomocą polecenia:
```
uname -a
```
Aby wyjść z interaktywnego kontenera należy wpisać 
``` 
exit
```
### Uruchomienie "systemu w kontenerze"
Ze względu na pracę na ubuntu, pobrałam obraz fedora i uruchomiłam kontener interaktywnie poleceniem:
``` 
docker run -it fedora
```
Następnie chcąc uzyskać informację o procesach, musiałam zainstalować bibliotekę `procps-ng` 

![](screeny/16.png)

Aby wyświetlić inforamcję o procesie PID 1, który jest zwykle pierwszym procesem uruchamianym w systemie i jest to proces inicjalizacyjny, należy wpisać w interaktywnym termianlu polecenie:
```
ps
```
![](screeny/17.png)

Aby móc zobaczyć wszystkie procesy na hoście, wyszłam z kontenera i użyłam polecenia:
```
ps auxft
```
To bardziej szczegółowe polecenie ps, które wyświetla listę wszystkich procesów uruchomionych na systemie.
Flagi **auxft** oznaczają:

**a:** Wyświetla procesy wszystkich użytkowników.

**u:** Wyświetla rozszerzone informacje o procesach, takie jak nazwa użytkownika właściciela procesu, identyfikator 
użytkownika (UID), identyfikator grupy (GID), zużycie CPU, zużycie pamięci, czas działania procesu itp.

**x:** Wyświetla również procesy, które nie są związane z terminalem.

**f:** Tworzy strukturę drzewa, która pokazuje hierarchię procesów (czyli procesy potomne i ich relacje do procesów nadrzędnych).

**t:** Wyświetla strukturę drzewa, ale w bardziej graficzny sposób, korzystając z drzewa znaków ASCII.

![](screeny/28.png)

Można dostrzec, że jest uruchomiony bash przez visul studio code, następnie widać wpisane polecenie w jedym z terminalów, które uruchamia kontener na obrazie fedora. W kontenerze Dockerowym, użytkownik root ma pełne uprawnienia w obrębie kontenera, ale jest ograniczony w dostępie do zasobów na poziomie hosta. To oznacza, że choć może wykonywać działania jako administrator w kontenerze, nie ma bezpośredniego dostępu do zasobów systemowych na poziomie hosta ani innych kontenerów. Izolacja kontenerów zapewnia, że ​​w przypadku ataku lub błędu w kontenerze, potencjalne szkody są ograniczone tylko do kontenera, bez wpływu na hosta lub inne kontenery.

Następnie zaktualizowałam pakiety poleceniem:
```
dnf update
```
Zaktualizowane pakiety:

![](screeny/18.png)

### Dockerfile 
Kolejnym naszym zadaniem było stworzenie własnego obrazu na podstawie innego obrazu. Jako obraz bazowy wybrałam fedorę. W tym celu w nowym katalogu stworzyłam Dockerfile, który zawiera "przepis" na mój obraz:
```
FROM fedora:latest

RUN dnf -y update
RUN dnf -y install git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

WORKDIR /app

CMD ["bash"]
```
Opis pliku:
FROM fedora:latest: W tej linii określamy, że będziemy używać obrazu bazowego Fedora w najnowszej dostępnej wersji.

RUN dnf -y update: Ta linia wykonuje aktualizację pakietów w obrazie Fedora. Flagi -y automatycznie akceptują wszystkie potwierdzenia, dzięki czemu nie jest wymagana interakcja z użytkownikiem.

RUN dnf -y install git: Ta linia instaluje pakiet git w obrazie Fedora. Dzięki temu będziemy mieli możliwość korzystania z systemu kontroli wersji Git wewnątrz kontenera.

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git: Ta linia wykonuje klonowanie repozytorium z GitHuba do kontenera.

WORKDIR /app: Ta linia ustawia katalog roboczy w kontenerze na /app. Oznacza to, że wszystkie kolejne polecenia zostaną wykonywane wewnątrz tego katalogu.

CMD ["bash"]: Ta linia definiuje domyślną komendę, która zostanie uruchomiona, gdy kontener zostanie wystartowany. W tym przypadku uruchamiana jest powłoka Bash.

Następnie zbudowałam obraz, za pomocą polecenia 
```
sudo docker build .
```

![](screeny/20.png)

Sprawdziłam czy obraz się zbudował:

![](screeny/21.png)

Jak widać obraz poprawnie się zbudował. Zmieniłam jego nazwę za pomocą polecenia:

![](screeny/22.png)

Sprawdziłam czy nazwa poprawnie się zmieniła i uruchomiłam kontener w trybie interaktywnym używając:
```
sudo docker run -it <nazwa_obrazu>
```
Następnie sprawdziłam czy repozytorium poprawnie się sklonowało.

![](screeny/23.png)

Sprawdziłam uruchomione kontenery poleceniem
```
sudo docker ps 
```
tylko jeden kontener był uruchomiony, zbudowany na obrazie `my-dockerfile`.

Sprawdziłam też wszystkie dostępne kontenery, zarówno aktywne jak i nieaktywne poleceniem: 
```
sudo docker ps -a
```

![](screeny/25.png)

Ponieważ miałam tylko jeden uruchomiony kontener zatrzymałam go poleceniem:
```
sudo docker stop <nazwa_kontenera>
```
![](screeny/26.png)

Następnie usunęłam kontener poleceniem:
```
sudo docker rm <nazwa_kontenera>
```
![](screeny/27.png)

Aby usunąć obrazy należy wpisać polecenie:
```
docker rmi -f $(docker images -q)
```
**docker rmi -f** : Usuwa wszystkie obrazy Docker, które zostały zwrócone przez polecenie **docker images -q**, nawet jeśli są one używane przez działające kontenery (jest to możliwe dzięki fladze -f).
