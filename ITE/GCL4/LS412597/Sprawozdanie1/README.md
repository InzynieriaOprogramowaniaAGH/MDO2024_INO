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

![git hook](Images/Zdj6.2.png)

Jak widać na poniższym zdjęciu hook działa prawidłowo.

![test git hooka](Images/Zdj6.3.png)
