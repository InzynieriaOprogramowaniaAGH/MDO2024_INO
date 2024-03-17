# Sprawozdanie 1

---
# Git, Gałęzie, SSH, Docker

## Magdalena Rynduch ITE GCL4

Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu

Piersze laboratorium rozpoczęłam od wygenerowania kluczy SSH na maszynie wirtualnej za pomocą polecenia ssh-keygen. Po wykonaniu polecenia wybrałam domyślną lokalizację kluczy w katalogu ~/.ssh. Pojawiły się w nim dwa pliki. Jeden z kluczem prywatnym (id_rsa) oraz drugi z publicznym (id_rsa.pub). Następnie pojawiła się opcja zabezpieczenia kluczy hasłem, z której nie skorzystałam.

Otrzymane klucze powiązałam z moim kontem na Githubie. Po zalogowaniu na https://github.com/ weszłam w Settings -> SSH and GPG keys -> New SSH key. Ustawiłam typ klucza na Authentication Key oraz wkleiłam wygenerowany wcześniej klucz publiczny (id_rsa.pub). 
Korzystanie z protokołu SSH umożliwia łączenie się ze zdalnymi serwerami i usługami takimi jak np. GitHub bez podawania swojej nazwy użytkownika i osobistego tokena dostępu przy każdej wizycie. Uwierzytelnianie zachodzi przy użyciu pliku klucza prywatnego na maszynie.

Dzięki powiązaniu konta, maszyna wirtualna uzyskała dostęp do GitHuba. Umożliwiło to sklonowanie repozytorium przedmiotu za pomocą: git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git. 

Poleceniem git checkout przełączyłam się na gałąź `main`, a następnie na gałąź grupy `GCL4`. Własną stworzyłam gałąź poleceniem: git checkout -b MR412777 i na niej wykonywałam resztę poleceń. Po przejściu do katalogu grupy `GCL4`, utworzyłam katalog `MR412777` oraz podkatalog `Sprawozdanie1`.

W lokalizacji MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie1 utworzyłam plik README.md oraz zapisałam w nim skrypt weryfikujący, czy każdy commit message zaczyna się od mojego inicjału oraz numeru indexu.

Treść skryptu:

#!/bin/bash
commit_message=$(cat "$1")
pattern="^MR412777"
if [[ ! $commit_message =~ $pattern ]]; then
  echo "Błąd: Commit message  musi zaczynać się od 'twoje inicjały & nr indexu'"
  exit 1
fi
exit 0

Następnie skopiowałam skrypt do pliku commit-msg w lokalizacji MDO2024_INO/.git/hooks. Nadałam plikowi prawa do wykonywania za pomocą polecenia chmod +x commit-msg. Dzięki temu hook commit-msg będzie uruchamiany przy tworzeniu commita.

Działanie hooka:

Wprowadzone zmiany wypchałam na zdalną gałąź za pomocą git push --set-upstream origin MR412777. Weszłam na Github'a i wykonałam pull request do gałęzi grupowej.

Realizację drugiego laboratorium rozpoczęłam od instalacji Dockera. 
Za pomoca polecenia docker pull pobrałam obrazy `hello-world`, `busybox`, `ubuntu` oraz `mysql`. 

Uruchomiłam kontener z obrazu `busybox`. Samo uruchomienie nie jest widoczne w terminalu, ponieważ kontener po wykonaniu zadania natychmiast się zatrzymuje. Aby znaleźć się wewnątrz kontenera należy uruchomić go w trybie interaktywnym i się podłączyć. 


Znak /# w terminalu Docker’a symbolizuje powłokę systemu operacyjnego w kontenerze. Znak / oznacza katalog główny, a # informuje, że ​​sesja jest uruchomiona z uprawnieniami administratora (root). 
Aby wyświetlić numer wersji, posłużyłam się poleceniem busybox | head -n 1.

Uruchomiłam kontener z obrazu `ubuntu` poleceniem sudo docker run -it ubuntu. Aby wyświetlić informacje o procesach posłużyłam się poleceniem ps z różnymi parametrami:
    -p wyświetla informacje o konkretnym procesie o podanym PID
    -e wyświetla wszystkie procesy
    -f wyświetla szczegółowe informacje o procesach w formie pełnej listy.

W celu opuszczenia kontenera w obu przypdkach korzystałam z polecenia exit.

Następnie w osobnym katalogu docker_repo utworzyłam plik Dockerfile. Jest on odpowiedzialny za stworzenie nowego obrazu bazującego na ubuntu, instaluje gita oraz klonuje repozytorium przedmiotu za pomocą protokołu HTTPS. 

Obraz zbudowałam korzystając z polecenia docker build -t obraz-mr412777, a następnie uruchomiłam interaktywnie (docker run -it obraz-mr412777). Wyświetliłam listę katalogów. Wśród nich znajdował się główny katalog przedmiotu, co świadczy o tym, że kolonowanie repozytorium przebiegło pomyślnie.

Wyświetliłam uruchomione kontenery za pomocą docker ps -a, po czym je wyczyściłam korzystając z docker rm $(docker ps -a -q).

Analogicznie wyświetliłam obrazy (docker images) i następnie je wyczyściłam (docker rmi $(docker images -q)).

Utworzony plik `Dockerfile` wkleiłam do swojego folderu `Sprawozdanie1`.
