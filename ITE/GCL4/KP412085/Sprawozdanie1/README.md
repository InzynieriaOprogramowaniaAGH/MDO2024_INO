# Sprawozdanie 1

Pierwsze sprawozdanie dotyczy konfiguracji środowiska, które składa się z wybranego wirtualizatora oraz zainstalowanego na nim systemu. Omówione zostaną również narzędzia takie jak `Git` i `Docker`, które umożliwią pracę ze zdalnym repozytorium oraz konteneryzację wybranych programów.

# Przygotowanie środowiska 

Pierwszym krokiem w przygotowaniu środowiska było wybranie wirtualizatora. Ze względu na wcześniejsze doświadczenia i umiejętność posługiwania się `VirtualBox`, wybór padł na to narzędzie. Dodatkowym argumentem przemawiającym za tym wyborem (w porównaniu do `WSL`) jest możliwość tworzenia migawek, które umożliwiają "zabezpieczanie" wykonanych do tej pory kroków realizacji ćwiczeń. Wybrany system operacyjny to najnowsza wersja dystrybucji Fedora Linux - `Fedora 39`. Dzięki swojej popularności, system ten posiada obszerną bazę informacji na temat rozwiązywania problemów oraz jest stale wspierany przez autorów. Dane mojej maszyny przedstawiam na poniższym zrzucie ekranu:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/86422cae-aac5-4c75-a5e5-5fc21f8e2ae0" />
</p>
<p align="center"><i>Dodatkowo 32 GB pamięci oraz mostkowana karta sieciowa</i></p>

***Jak widać na załączonym zdjęciu, typ wirtualizacji ustawiony jest na parawirtualizację KVM. Jest to związane z systemem gospodarza `Windows 11`, który uruchamia swoje jądro w trybie wirtualizacji. Może to ograniczać wydajność utworzonej maszyny. Rozwiązaniem tego problemu może być wyłączenie hypervisor'a Windows, ale z powodu braku zauważalnego spowolnienia, ten krok nie został wykonany.***

Aby połączyć się z maszyną wirtualną poprzez usługę `Remote-SSH` w `VS Code`, pobieramy odpowiednie rozszerzenie i modyfikujemy plik `.ssh/config` dodając nowego hosta:
```
Host <host IP>
  HostName <host IP>
  User <username>
```

# Instalacja git i klonowanie repozytorium

W celu sklonowania repozytorium musimy zainstalować na swojej maszynie system kontroli wersji `git`. W tym celu wykonujemy następujące kroki:
- aktualizujemy menager'a pakietów `dnf` za pomocą polecenia `sudo dnf update`
- pobieramy system kontroli wersji: `sudo dnf install git`

Teraz możemy sklonować zdalne repozytorium. Zanim to zrobimy generujemy swój [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens), którego użyjemy do autentykacji swojego konta na GitHubie zamiast podawania hasła. Następnie udajemy się na stronę repozytorium i wybieramy odpowiedni `url` do klonowania za pomocą `HTTPS`. W oknie terminala maszyny wirtualnej wykonujemy polecenie `git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git` oraz zamiast hasła do konta podajemy wygenerowany token.

**Klonowanie za pomocą klusza SSH-RSA oraz klucza SSH-ED25519 zabezpieczonego hasłem**
Klucze generujemy za pomocą narzędzia `ssh-keygen`. Po wygenerowaniu, publiczny klucz umieszczamy w zakładce `SSH keys` w ustawieniach naszego konta na github'ie.

- Klucze `SSH-RSA` generujemy za pomocą polecenia przy jego domyślnych ustawieniach: `ssh-keygen`. Jako pojawiające się opcje wybieramy domyślne ustawienia (zatwierdzamy wszystko enterem). Dzięki temu generujemy parę kluczy, które zapiszą się w katalogu `.ssh`, co automatycznie nada im wymagane uprawienia. Po wygenerowaniu tych kluczy z domyślną nazwą, w katalogu tym pojawiają się 2 pliki: `id_rsa` oraz `id_rsa.pub`. Klucz oznaczony rozszerzeniem `.pub` kopiujemy do wspomnianej zakładki `SSH keys` na GitHub'ie. Teraz możemy sklonować repozytorium przy wykorzystaniu tego klucza za pomocą polecenia: `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git`.
- Druga opcja klucza innego niż RSA zabezpieczonego hasłem, może zostać zrealizowana w następujący sposób:
  ```bash
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N 'TwojeHaslo'
  ```
  gdzie `-t` to wybór typu klucza, `-f` ścieżka (analogiczna do poprzeniej tylko jawnie podana), `-N` hasło do zabezpieczenia kluczy. Pozostałe kroki wykonujemy analogicznie do poprzedniego punktu.

  **UWAGA, jeśli dodaliśym klucz SSH-RSA i sklonowaliśmy repozytorium, klucz ten jest automatycznie wykorzystywany przy każdej kolejnej próbie klonowania, aby to zmienić należy dodać plik `~/.ssh/config`:**

   ```
   Host github.com
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
   ```
   Plik ten umożliwi wykorzystanie jako domyślnego klucza, naszego nowego klucza SSH-ED25519 zabezpieczonego hasłem. Teraz przy próbie klonowania repozytorium zostaniemu poproszeni o podanie hasła, czyli osiągniemy docelowy efekt.


# Praca na nowej gałęzi

Po sklonowaniu repozytorium przełączamy się na odpowiednią gałąź, która będzie naszym miejscem pracy. To z niej następnie będziemy dokonywać `Pull Request` aby dodać nasze zmiany do głównego brancha grupy.
Aby przełączyć się pomiędzy gałęziami używamy polecenia `git checkout <branch_name>`, natomiast dla sprawdzenia na jakiej gałęzi obecnie jesteśmy: `git branch`. Te dwie proste komeny pozwalają nam nawigować po repozytorium.
Po przełączeniu się na odpowienią gałąź, tworzymy własną: `git checkout -b <branch_name>`, oraz dodajemy tam zgodnie z opisem intrukcji własne katalogi i plik ze sprawozdaniem:
```
git checkout -b KP412085
mkdir -p KP412085/Sprawozdanie1
cd KP412085/Sprawozdanie1/
echo "# Sprawozdanie 1" >> ./README.md
 ```

# Git hooks
Zanim zatwierdzimy nasze zmiany w repozytorium - `commit`, dodajemy `git hook'a`, który przez wykonaniem tej operacji będzie sprawdzał czy zawraliśmy na początku wiadomści commita odpowiedni identyfikator ( w moim przypadku `[KP412085]`). Aby to zrobić modyfikujemy plik `~/.git/hooks/commit-msg.sample` w następujący sposób:

```bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat $COMMIT_MSG_FILE)

if [ "$(echo "$COMMIT_MSG" | cut -c 1-10)" != "[KP412085]" ]; then
  echo "[KP412085] $COMMIT_MSG" > $COMMIT_MSG_FILE
fi
```
Skrypt ten realizuje wcześniej opisane zadanie. Aby umożliwić jego działanie zmieniamy jego nazwę, usuwając z niej `.sample`. Teraz podczas każdego commita, skrytp ten zostanie automatycznie uruchomiony.

# Pull Request

Dodajemy nasze wprowadzone zmiany do `staging area` za pomocą `git add -A`, a następnie zatwierdzamy `git commit -m "Initial commit"`. Weryfikujemy działanie hook'a za pomocą `git log`:
<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/186f312a-8be7-4f78-ac61-d5ec075c5299" />
</p>

Na koniec na `GitHub'ie` dodajemy w repozytorium `Pull Request`, który jest zapytaniem o dołączenie naszej gałęzi ze zmianami do gałęzi `main`.

# Instalacja Docker'a w Fedorze i podstawowe operacje docker'a

Instalacja `Docker'a` odbywa się poprzez wbudowany menedżer pakietów dla naszego systemu, czyli `dnf`, za pomocą polecenia 
```
sudo dnf install docker
```
Po jego instalacji należy uruchomić go poprzez narzędnie `systemctl`
```
sudo systemctl start docker
```
Aby sprawdzić czy został uruchomiony możemy skorzystać z opcji `systemctl status docker`

*Jeśli docker nie działa bez uprawnień sudo, a chcemy z niego korzystać na koncie użytkownika możemy dodać nową grupę `docker`, oraz dodać do niej wybranego użytkownika, zgodnie z [instrukcją](https://docs.docker.com/engine/install/linux-postinstall/)*

Jeśli docker działa poprawnie możemy pobrać obrazy z [DockerHub](https://hub.docker.com/), za pomocą polecenia:
```
docker pull node:lts-bullseye-slim
```
Po `:` możemy podać konkretą wersję, czyli `tag` danego obrazu, jeśli jej nie podamy pobierze nam się obraz domyślny. Taki obraz pobierze się nam również w momencie próby uruchomienia kontenera na jego podstawie, nawet jeśli go lokalnie nie posiadamy (zostanie on wtedy automatycznie pobrany, jeśli istnieje, z DockerHub'a). Poniżej screen pokazujący jak sprawdzić pobrane obrazy:

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/1f2883d9-a1e3-4387-82a5-8958edae1572" />
</p>


Aby uruchomić kontener na podstawie obrazu korzystamy z polecenia:
```
docker run --interactive --tty --rm <image_name>
```
Analogiczną opcją do `--interactive --tty` jest `-it`, pierwsza część tej komendy przekierowywuje wyjście terminala z kontera na nasz terminal, druga część natomiast otwiera proces terminala z kontera na naszym systemie, co umożliwia wykonywanie poleceń w kontenerze. Opcja `--rm` usuwa kontener po jego zatrzymaniu.

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/b3256107-45d8-41e3-a7b1-5bcaac46b636" />
</p>

Aby sprawdzić działające kontenery uzywamy polecenia:
```
docker container ps
```
lub jeśli chcemy zobaczyć wszystkie kontenery, łącznie z tymi zatrzymanymi, wykonujemy analogiczne polecenie z flagą `-a`, które w skróconej formie wygląda tak:
```
docker ps -a
```

Kolejnym etapem jest sprawdzenie procesu o `PID 1` wewnątrz kontenera z systemem `Fedora`, oraz procesy dockera na maszynie hosta. W tym celu wykonujemy poniższe kroki:

- uruchamiamy kontener z fedorą za pomocą: `docker run -it fedora`
- aby użyć polecenia `ps` musimy je pobrać (nie ma go domyślnie w tym obrazie): `dnf install procps -y`
- sprawdzamy procesy w kontenerze za pomocą: `ps`
- sprawdzamy procesy hosta za pomocą: `ps auxft`

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/485637bf-34d5-4c1d-8901-ce3e9ee4e6b9" />
</p>
<p align="center"><i><b>Proces /bin/bash w kontenerze o PID 1, to proces /bin/bash utworzony przez dockerd z uprawnieniami root'a jako 12419</b></i></p>

# Dockerfile

Aby zbudować kontener z niestandardowych obrazów tworzymy dockerfile'a. Podstawą do jego utworzenia będzie obraz `Ubuntu:22.04`. Do niego będziemy dodawać w kolejnych warstwach (docker buduje kontenery w oparciu o Linux-owy Union File System, który umożliwia nakładanie wartw systemów plików, tworząc jeden końcowy jako wynikowy wszystkich warstw) aktualizację apt-get oraz w tej samej warstwie (dobrą praktyką jest utrzymywanie jak najmniejszej ilości warstw np. poprzez łączenie komend) pobieramy git'a i openssh-client (jeśli chcemy pobrać repozytorium na githubie poprzez ssh). Dodajemy również nowego użytkownika oraz zmieniamy uprawnienia katalogu w którym wywołujemy CMD. Umożliwia to częściowe zabezpiecznie, przed wykonywaniem poleceń jako root. Na końcu klonujemy repozytorium i ustawiamy komendę która będzie uruchomiona wraz z utworzeniem obrazu (jako PID 1 w kontenerze) na `/bin/bash`. Poniżej przykład takiego dockerfile:
```dockerfile
FROM ubuntu:22.04

WORKDIR usr/src/app

RUN apt-get update && apt-get install -y git \
    && useradd -ms /bin/bash my_ubuntu && chown -R my_ubuntu:my_ubuntu /usr/src/app

USER my_ubuntu

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

CMD ["/bin/bash"]
```

Obraz ten budujemy za pomocą polecenia:
```
docker build -t <image_name> /path/to/dockerfile
```
Po uruchomieniu w trybie interaktywnym kontenera na podstawie stworzonego obrazu sprawdzamy za pomocą `ls` czy znajduje się tam sklonowane repozytorium. Poniższy screen w górnej części pokazuje terminal z kontenera, natomiast z dolnej części terminal hosta z informacją o uruchomionym kontenerze

<p align="center">
  <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/64956354/7ff97b0f-063d-4070-8a8e-f295082b313e" />
</p>

Aby wyczyścić niepotrzebne obrazy korzystamy z polecenia `docker image rm <image_id/image_name>`















