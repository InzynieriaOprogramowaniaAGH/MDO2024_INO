# Sprawozdanie 1

---
# Git, Gałęzie, SSH, Docker

## Magdalena Rynduch ITE GCL4

Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu

Piersze laboratorium rozpoczęłam od wygenerowania kluczy SSH na maszynie wirtualnej za pomocą polecenia `ssh-keygen`. Po wykonaniu polecenia wybrałam domyślną lokalizację kluczy w katalogu ~/.ssh. Pojawiły się w nim dwa pliki. Jeden z kluczem prywatnym (`id_rsa`) oraz drugi z publicznym (`id_rsa.pub`). Następnie pojawiła się opcja zabezpieczenia kluczy hasłem, z której nie skorzystałam.

![ssh heys](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f839dfd7-10e3-484e-bbdb-6a98896d05af)

Otrzymane klucze powiązałam z moim kontem na Githubie. Po zalogowaniu na https://github.com/ weszłam w `Settings` -> `SSH and GPG keys` -> `New SSH key`. Ustawiłam typ klucza na `Authentication Key` oraz wkleiłam wygenerowany wcześniej klucz publiczny (`id_rsa.pub`).

![ssh github](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/cd2bd7b2-e680-4fe4-9cf3-a0d88d2bb9aa)

Korzystanie z protokołu SSH umożliwia łączenie się ze zdalnymi serwerami i usługami takimi jak np. GitHub bez podawania swojej nazwy użytkownika i osobistego tokena dostępu przy każdej wizycie. Uwierzytelnianie zachodzi przy użyciu pliku klucza prywatnego na maszynie.

Dzięki powiązaniu konta, maszyna wirtualna uzyskała dostęp do GitHuba. Umożliwiło to sklonowanie repozytorium przedmiotu za pomocą: `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git`.

Poleceniem `git checkout` przełączyłam się na gałąź `main`, a następnie na gałąź grupy `GCL4`. Własną gałąź stworzyłam poleceniem: `git checkout -b MR412777` i na niej wykonywałam resztę poleceń. Po przejściu do katalogu grupy `GCL4`, utworzyłam katalog `MR412777` oraz podkatalog `Sprawozdanie1`.

![branche](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c81959d8-08b8-4916-966c-f1bb67a41e02)

W lokalizacji MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie1 utworzyłam plik `README.md` oraz zapisałam w nim skrypt weryfikujący, czy każdy commit message zaczyna się od mojego inicjału oraz numeru indexu.

Treść skryptu:

#!/bin/bash
commit_message=$(cat "$1")
pattern="^MR412777"
if [[ ! $commit_message =~ $pattern ]]; then
  echo "Błąd: Commit message  musi zaczynać się od 'twoje inicjały & nr indexu'"
  exit 1
fi
exit 0

Następnie skopiowałam skrypt do pliku `commit-msg` w lokalizacji MDO2024_INO/.git/hooks. Nadałam plikowi prawa do wykonywania za pomocą polecenia `chmod +x commit-msg`. Dzięki temu hook będzie uruchamiany przy tworzeniu commita.

![hook -x](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/69f122cc-90cf-436a-bb77-313b7f0ad3c2)

Działanie hooka:

![hook git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fe2d6ebd-4f10-4051-962f-daace3b7123b)

Wprowadzone zmiany wypchałam na zdalną gałąź za pomocą `git push --set-upstream origin MR412777`. Weszłam w repozytorium przedmiotu na Github, następnie `Branches` -> `New pull request` i wykonałam pull request do gałęzi grupowej.

![pull req](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1c731ddc-edce-4e00-b563-a49afacfceee)

Realizację drugiego laboratorium rozpoczęłam od instalacji Dockera. 

![docker install](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9d9f3cdc-e636-412a-b1a4-df80fdc398e2)

Za pomoca polecenia docker pull pobrałam obrazy `hello-world`, `busybox`, `ubuntu` oraz `mysql`. 

![docker pull](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/eeb136f2-4775-4c62-bcda-f9915e30eaf1)

Uruchomiłam kontener z obrazu `busybox`. Samo uruchomienie nie jest widoczne w terminalu, ponieważ kontener po wykonaniu zadania natychmiast się zatrzymuje. Aby znaleźć się wewnątrz kontenera należy uruchomić go w trybie interaktywnym i się podłączyć. 

Znak `/#` w terminalu Docker’a symbolizuje powłokę systemu operacyjnego w kontenerze. Znak `/` oznacza katalog główny, a `#` informuje, że ​​sesja jest uruchomiona z uprawnieniami administratora (root). 
Aby wyświetlić numer wersji, posłużyłam się poleceniem `busybox | head -n 1`.

![docker busybox](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/5fde5743-637d-4a03-8119-3339716eb5ee)

Uruchomiłam kontener z obrazu `ubuntu` poleceniem `docker run -it ubuntu`. Aby wyświetlić informacje o procesach posłużyłam się poleceniem ps z parametrami:
    -p wyświetla informacje o konkretnym procesie o podanym PID
    -e wyświetla wszystkie procesy
    -f wyświetla szczegółowe informacje o procesach w formie pełnej listy.
W celu opuszczenia kontenera w obu przypdkach korzystałam z polecenia exit.

![docker PID](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/d4c4d451-4d36-4e11-9359-0ad7b186f273)

Uruchomiłam kontener z obrazu `ubuntu` ponownie i zaktualizowałam pakiety.

![docker update](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/57bc1136-736e-4d43-8f53-fa9b8f4d4486)

Warto zauważyć, że w tym przykładzie przy każdym uruchomieniu kontenera, tworzony jest jego unikalny identyfikator. Jest on używany jako nazwa hosta wewnątrz kontenera. Z tego powodu, wraz z każdym uruchomieniem ustawiany jest inny adres root@<id-kontenera>.

W osobnym katalogu `docker_repo` utworzyłam plik `Dockerfile`. Zawiera on skrypt odpowiedzialny za stworzenie nowego obrazu bazującego na ubuntu, instalację Gita oraz sklonowanie repozytorium przedmiotu za pomocą protokołu HTTPS. 
Następnie zbudowałam obraz korzystając z polecenia `docker build -t obraz-mr412777`, a następnie uruchomiłam interaktywnie (`docker run -it obraz-mr412777`). 

![docker build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e67845bb-c12d-463e-9fac-34e15c3032b4)

Wyświetliłam listę katalogów. Wśród nich znajdował się główny katalog przedmiotu, co świadczy o tym, że klonowanie repozytorium przebiegło pomyślnie.

![docker run obraz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/70c86e2a-1894-4a80-b370-f3a0a93b9e74)

Wyświetliłam uruchomione kontenery za pomocą `docker ps -a`, po czym wyczyściłam je korzystając z `docker rm $(docker ps -a -q)`.

![docker before rm](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b96554b2-e3cd-4162-98cb-a08964ef2aa8)
![docker rm ](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/310572e1-3763-4221-b280-86a0b4d8e368)

Analogicznie wyświetliłam obrazy (`docker images`) i następnie je wyczyściłam (`docker rmi $(docker images -q)`).

![docker rmi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/203359de-c73b-4d76-8b2f-eac054ddbbf5)

Utworzony plik `Dockerfile` wkleiłam do swojego folderu `Sprawozdanie1`.
