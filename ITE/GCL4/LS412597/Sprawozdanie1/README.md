# Zajęcia 01 - Wprowadzenie, Git, Gałęzie, SSH

---

## Sawina Łukasz - LS412597

### Wstęp

Zajęcia zostały wykonane przy wykorzystaniu Hyper-V do utworzenia wirtualnego systemu oraz systemu Fedora w wersji 39. Do komunikacji z maszyna wykorzystywane jest połączenie przy pomocy SSH oraz Visual Studio Code (VSC) jako edytor plików z rozszerzeniem `Remote Explorer`.

### 1. Zainstaluj klienta Git i obsługę kluczy SSH

Do zainstalowania git-a na maszynie wirtualnej musimy wykorzystać polecenie:

```bash
dnf install git
```

### 2. Sklonuj repozytorium przedmiotowe za pomocą HTTPS i personal access token

Aby utworzyć persona access token musimy przejść na GitHub do Setting > Developer settings > Personal access token > Tokens (classic).

Na tej stronie wypełniamy wszystkie opcje jakie ma posiadać nasz access token oraz jego okres ważności.

![Generowanie klucza ssh](Images/Zdj0.png)

Nastepnie po utwozreniu personal access token zostaje on nam zaprezentowany na stronie. Ważne, aby go zapisać ponieważ nie będzie możliwości ponownego wglądu na niego.

![Generowanie klucza ssh](Images/Zdj0.1.png)

Po utworzeniu personal access token oraz zapisaniu go możemy sklonować repozytorium przedmiotowe przy pomocy polecenia:

```bash
git clone https://<username>:<token>@github.com/<ścieżka-repozytorium> <ścieżka-docelowa-repozytorium>
```

W miejsce `username` wstawiamy nazwę naszego użytkownika, a `token` skopiowany personal acces token.

![Generowanie klucza ssh](Images/Zdj0.2.png)
Jak widać powyżej repozytorium zostało sklonowane bez problemów.

### 3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH

Aby umożliwić klonowanie korzystanie z repozytorium przy pomocy GitHub potrzebujemy skonfigurować nasze klucze SSH, w tym celu najpierw musimy wygenerować parę kluczy (prywatny oraz publiczny). W tym celu wykorzystujemy polecenie:

```bash
ssh-keygen
```

> Aby wygenerowac klucze inne niż RSA możemy wykorzystać dodatkowe opcje polecenia ssh-keygen możemy dodać flagę `-t`, która określa algorytm do generowania klucza (przykładowo ed25519) oraz `-n`, która określa zabezpieczenie hasłem klucza prywatnego. Przykładowe wygenerowanie klucza z algorytmem ed25519 oraz zabezpieczone hasłem:
>
> ```bash
> ssh-keygen -t ed25519 -N 'haslo'
> ```

Po wykonaniu polecenia zostaniemy zapytani o miejsce w którym zapisać parę naszych kluczy, w tym przypadku zostawiamy domyślną, czyli `/home/user/.ssh`

> Jak widać na poniższym zdjęciu pojawia się informacja, że klucz już istnieje oraz czy go nadpisać, jest to spodowane tym, że wcześniej zostały już przeze mine wygenerowane. Przy pierwszym uruchomieniu ten komunikat się nie pojawi.

Następnie zostaniemy zapytani dwukrotnie o passphrase, które pozostawiamy puste.

![Generowanie klucza ssh](Images/Zdj1.png)

Po wszystkim klucz zostanie wygenerowany i będziemy mogli go znaleźć w ścieżce wspomnianej wyżej `/home/user/.ssh`

![Lokalizacja klcuza ssh](Images/Zdj2.png)

> Jak można zauważyć pojawiają się tam dwa ważne dla nas pliki id_rsa oraz id_rsa.pub. Bardzo ważne, aby zawartości pliku id_rsa oraz samego pliku nigdy nikomu nie udostępniać. Dla nas będzie ważny plik id_rsa.pub, ponieważ to w nim znajduje się klucz publiczny.

W następnej kolejności odczytujemy nasz PUBLICZNY klucz ssh, który znajduje się w pliku `id_rsa.pub`. Do odczytania jego zawartości możemy wykorzystać polecenie `cat`

```bash
cat /home/user/.ssh/id_rsa.pub
```

![Publiczny klucz ssh](Images/Zdj3.png)

Jego zawartość kopiujemy i przechodzimy do naszego konta na github. W lokalizacji Settings > SSH and GPG keys wybieramy przycisk `New ssh key`, podajemy nazwę dla naszego klucza oraz skopiowany wcześniej klucz.

![Publiczny klucz ssh](Images/Zdj4.png)

Po czym wciskamy przycisk `Add ssh key` i potwierdzamy tą operację podając hasło. Nasz klucz powinien się teraz znaleźć w liście wszystkich dodanych kluczy SSH do github.

W tym momencie dzięki dodaniu klucza SSH możemy sklonować repozyrotium przy pomocy SSH, wykonując polecenie:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git <ścieżka-docelowa-repozytorium>
```

### 4. Przełącz się na gałąź main, a potem na gałąź swojej grupy

Przy pomocy polecenia przechodzimy na gałąź grupy ćwiczeniowej:

```bash
git checkout GCL4
```

### 5. Utwórz gałąź o nazwie "inicjały & nr indeksu"

Następnie chcemy utworzyć nową gałąź "inicjały & nr indeksu", aby utworzyć nową gałąź do powyższego polecenia musimy dodać opcję `-b`. Polecenie będzie wyglądało następującą:

```bash
git checkout -b LS412597
```

> Ponieważ gałąź została przezemnie utworzona wcześniej, dlatego pokażę, że wszystkie gałęzie znajdują się na lokalnym repozytorium przy pomocy
>
> ```bash
> git branch
> ```
>
> ![Gałęzie lokalnie](Images/Zdj5.png)

### 6. Rozpocznij pracę na nowej gałęzi

> Przed rozpoczęciem pracy na gałęzi wykorzystujemy program VisualStudio Code (VSC) z rozszerzeniem Remote Explorer do połączenia się z wirtaulną maszyną oraz pracy z plikami.

- W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu"

Przez wykorzystanie programu VSC czynnośc ta jest prosta, wystarczy utworzyć katalog z poziomu eksploratora plików.

![Katalogi](Images/Zdj6.1.png)

- Napisz Git hooka - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu".

Bazująć na przykładowych Git hookach znajdujących się w ścieżce `commit-msg.sample` .git/hooks/ tworzymy nowy plik. Do sprawdzania zawartości commit message wykorzystuję własny regex, który wymaga, aby wiadomość zaczynała się od `LS412597`.

```bash
#!/bin/bash

# Regex
regex="^LS412597.*"

# Pobieranie commit message
commit_msg=$(cat "$1")

# Sprawdzenie commit message
if [[ ! $commit_msg =~ $regex ]]; then
    echo "Błąd: Commit message nie zaczyna się od LS412597!"
    exit 1
fi
```

Jak widać na poniższym zdjęciu hook działa prawidłowo.

![test git hooka](Images/Zdj6.2.png)

Teraz możemy nasz utwrzony plik przenieść do lokalizacji `.git/hooks/` przy pomocy polecenia:

```bash
cp commit-msg ~/MDO2024_INO/.git/hooks
```

> Ścieżka docelowa może się różnić, w zależności od tego gdzie zapisane jest repozytorium.

- Spróbuj wciągnąć swoją gałąź do gałęzi grupowej

Po przeniesieniu się na gałąź roboczą grupy przy pomocy polecenia:

```bash
git checkout GCL4
```

Możemy spróbować przenieść swoje zmiany na gałęzi do gałęzi roboczej przy pomocy polecenia:

```bash
git merge LS412597 -m "LS412597 merge"
```

> Do polecenia dodaję automatycznie message, ponieważ przy zrobieniu merga tworzony jest automatycznie commit, który wymaga podania commit messega

![test git hooka](Images/Zdj6.3.png)

- Zaktualizuj sprawozdanie i wyślij aktualizację do zdalnego źródła

Przy pomocy polecenia:

```bash
git push
```

możemy wszystkie nasze zacommitowane zmiany przesłać do zdalnego źródła.

> Przed zrobieniem push'a warto sprawdzić czy wszystkie zmiany zostały zacommitowane, dokonać tego możemy przez polecenie:
>
> ```bash
> git status
> ```
>
> Jeśli jakieś zmiany nie zostały zcommitowane, musimy je dodać, a następnie zrobić commita:
>
> ```bash
> git add .
> git commit -m "<commit message>"
> ```
>
> Powyżesze kroki są wykonywane zawsze przed zrobieniem `git push`
>
> > Przy `git add` musimy podać jakie rzeczy powinno nam dodać, znajdując się w głównym katalogu repozytorium można użyc po prostu ., która doda wszystkie wprowadzone zmiany, można również określać konkretne pliki, które chcemy dodać przez wypisanie ich po spacji.

# Zajęcia 02 - Git, Docker

---

### 1. Zainstaluj Docker w systemie linuksowym

Aby pobrać Docker na systemie Fedora musimy tylko wykorzystać polecenie:

```bash
sudo dnf install docker
```

Po pobraniu możemy sprawdzić czy Docker został na pewno pobrany przez polecenie:

```bash
docker --version
```

![Sprwadzenie pobrania dockera](Images/Zdj7.png)

Dla wygodniejszej pracy warto dodać użytkownika do grupy `docker` przez co nie będziemy musieli za każdym razem używać sudo przed komendami dockera. Dokonać tego możemy przy poomocy poleceń:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

> Przed rozpoczęciem pracy z dockerem warto sprawdzić czy jest on uruchomiony i jeśli nie to uruchomić go.
> Sprawdzenie statusu dockera:
>
> ```bash
> sudo systemctl status docker
> ```
>
> Uruchomienie dockera w przypadku, gdy jest nieaktywny:
>
> ```bash
> sudo systemctl start docker
> ```
>
> Automatyczne uruchamianie dockera przy starcie systemu:
>
> ```bash
> sudo systemctl enable docker
> ```

### 2. Zarejestruj się w Docker Hub i zapoznaj z sugerowanymi obrazami

Teraz, gdy mamy pobranego dockera możemy zarejestrować się na stronie Docker Hub, aby móc przeglądać różne dostępne obrazy.

![Rejestracja na docker hub](Images/Zdj8.png)

> Przy rejestracji możemy wybrać różne metody, ja wybrałem rejestrację przez konto GitHub.

### 3. Pobierz obrazy hello-world, busybox, ubuntu lub fedora, mysql

Gdy nasz docker już jest aktywny możemy pobrać obrazy, które będziemy później wykorzystywać, do pobrania obrazu wykorzystujemy polecenie:

```bash
docker pull <nazwa_obrazu>
```

Gdy już pobierzemy wszystkie obrazy jakie potrzebujemy, możemy sprawdzić listę wszystkich obrazów przy pomocy polecenia:

```bash
docker images
```

![Obrazy](Images/Zdj9.png)

### 4. Uruchom kontener z obrazu busybox

- Pokaż efekt uruchomienia kontenera

Do uruchomienia kontenera wykorzystujemy polecenie:

```bash
docker run <nazwa_obrazu>
```

W przypadku busybox nie zobaczymy żadnego efektu w konsoli, ponieważ nie podaliśmy żadnej komendy do wykonania wewnątrz kontenera. Jednak, aby przekonać się, że konterer został uruchomiony możemy wykorzystać polecenie:

```bash
docker ps -a
```

> `-a` wyświetli pełną listę koneretów, nawet tych, które zostały zamknięte niedawno.

![Uruchomienie kontenera](Images/Zdj10.png)

Jak widać 4 minuty temu został utworzony oraz zamknięty kontener z obrazu BusyBox, co świadczy o tym, że kontener został uruchomiony.

- Podłącz się do kontenera interaktywnie i wywołaj numer wersji

Przy uruchomieniu obrazu możemy dodatkowo dodać opcję `-it`, która uruchomi konterer w trybie interaktywnym.

```bash
docker run -it <nazwa_obrazu>
```

![Uruchomienie kontenera w trybie interaktywnym](Images/Zdj11.png)

Jak widać zmienił się znak zachęty, co świadczy o tym, że teraz nasz terminal jest terminalem wewnątrz kontenera.

Dodatkowo dzięki poleceniu `busybox --help` możemy odczytać jaka jest to wersja obrazu, w tym przypadku posiadamy wersję 1.36.1.

> Po zakończeniu pracy w trybie interaktywnym możemy wyjść z kontenera przy pomocy polecenia `exit`

### 5. Uruchom "system w kontenerze"

Jak widać we wcześniejszym zrzucie ekranu jednym z obrazów, które pobrałem jest `Fedora`.

W celu zaprezentowania systemu w kontenerze oraz pracy na nim uruchamiamy go w trybie interaktywnym.

- Zaprezentuj PID1 w kontenerze i procesy dockera na hoście

Jak można zobaczyć poniżej uruchomiłem obraz oraz chciałem sprawdzić listę procesów, jednak okazało się, że narzędzie ps nie zostało dodane do obrazu, co trzeba zrobić ręcznie.

![Uruchomienie kontenera](Images/Zdj12.png)

W tym celu używamy polecenia:

```bash
dnf install procps -y
```

Po zainstalowaniu możemy sprawdzić wszystkie procesy, a w tym przypadku sprawdzamy proces od ID 1

![Procesy na kontenerze](Images/Zdj13.png)

Aby wyświetlić procesy docker na hoście możemy wykorzystać polecenie:

```bash
docker top <container_ID>
```

W tym przypadku w miejsce container_ID wstawiamy ID kontenera, którego procesy chcemy wyświetlić.
![Procesy dockera na hoście](Images/Zdj14.png)

- Zaktualizuj pakiety

Do zaktualizowania pakietów w systemie fedora wykorzystujemy polecenie:

```bash
sudo dnf update
```

![Update pakietów](Images/Zdj15.png)

Następnie zostaniemy zapytani czy chcemy kontynuować wybierając odpowiednią opcję [Y/N].
Po potwierdzeniu wszystkie pakiety zostaną zaktualizowane.

### 6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo

Tworzymy plik Dockerfile (może być to wykonane w terminalu przy pomocy polecenia `touch` lub z poziomu VSC).

Jako zawartość pliku wpisujemy:

```Dockerfile
FROM fedora:latest
WORKDIR /app
RUN dnf -y update && \
    dnf -y install git
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
ENTRYPOINT ["/bin/bash"]
```

`FROM` definiuje bazowy obraz, na którym będziemy budować nasz obraz Docker. Przez dodanie `:latest` będziemy zawsze pobierali najnowszą wersję obrazu.

`WORKDIR` ustawia katalog roboczy dla wszystkich kolejnych instrukcji z Dockerfile

`RUN` wykonuje dane polecenie, w tym przypadku najpierw robimy aktualizację pakietów, a następnie pobieramy git'a na nasz obraz. W dalszej części klonujemy repozytorium przedmiotu.

`ENTRYPOINT` określa polecenie, któe zostanie uruchomione jako punkt wejścia dla kontenera, w tym przypadku będzie to uruchomienie w trybie interaktwynym.

Po napisaniu naszego Dockerfila musimy zbudować obraz na jego podstawie, wykonujemy to przy pomocy polecenia:

```bash
docker build -t <nazwa_obrazu> .
```

![Budowa dockerfila](Images/Zdj16.1.png)
![Budowa dockerfila](Images/Zdj16.2.png)

Jak widać wszystkie kroki wpisane w Dockerfila wykonywane są kolejno po sobie. Teraz możemy sprawdzić czy nasz obraz istnieje oraz zweryfikować czy jego zawartość jest prawidłowa.

![Lista obrazów](Images/Zdj17.png)

Nasz obraz pojawił się w spisie wszystkich obrazów, teraz uruchimimy go i sprawdzymy jego zawartość.

![Lista obrazów](Images/Zdj18.png)

Jak widać w obrazie został pobrany git oraz sklonowane zostało repozytorium przedmiotu.

### 7. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.

Aby sprawdzić jakie kontenery zostały uruchomione, ale nie działające obecnie, możemy wykorzystać polecenie:

```bash
docker ps -a -f status=exited
```

Do wyczyszczeenia kontenerów możemy użyć polecenia:

```bash
docker rm
```

Jednak ważne jest określenie, które kontenery mają zostać usunięte, możemy to zrobić dodająć argument:

```bash
docker rm $(docker ps -a -f status=exited -q)
```

![Lista obrazów](Images/Zdj19.1.png)
![Lista obrazów](Images/Zdj19.2.png)

Jak widać lista uruchomionych kontenerów jest spora, a po wykonaniu powyższego polecenia jest już pusta, czyli wszystkie kontenery, które zostały uruchomione zostały usunięte.

![Lista obrazów](Images/Zdj19.3.png)

Co ważne, cały czas działający kontener z obrazem_testowym nie został usunięty.

### 8. Wyczyść obrazy

Aby wyświetlić wszystkie obrazy dockera możemy wykonać polecenie:

```bash
docker images -a
```

Teraz, aby wyczyścić je użyjemy polecenia:

```bash
docker rmi $(docker images -a -q)
```

![Lista obrazów](Images/Zdj20.png)
![Lista obrazów](Images/Zdj20.1.png)

Jak widać wszystkie obrazy zostały usunięte z naszego dockera.
