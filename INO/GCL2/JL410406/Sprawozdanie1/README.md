# Sprawozdanie 1

Justyna Ladzińska

---

## Wstęp

Przeprowadzone zadania mają na celu skonfigurowanie środowiska pracy z repozytorium Gita, zaznajomienie się z podstawowymi pojęciami oraz operacjami związanymi z tworzeniem i pracą na gałęziach.

Do wykonania zadań wykorzystałam wirtualną maszynę Oracle VM VirtualBox oraz system Ubuntu 22.04.4

## Wykonanie

1. Instalacja kiletna Git i obslua kluczy SSH:

Rozpoczynamy od polecenia, które umożliwia nam korzystanie z Git'a:

``` bash
apt-get install git
```

Jeśli instalacja klienta przebiegnie poprawnie możemy wyświetlić aktualną wersję Git'a oraz klienta SSH:

![1.1](screenshots/1.1.png)

![1.2](screenshots/1.2.png)

2. Klonowanie repozytorium za pomocą klucza SSH:

Do uzyskania dostępu do GitHuba i sklonowania repozytorium wymagany jest klucz SSH. 

Pierwszy wygenerowany klucz jest kluczem ed25519. Jest stosunkowo krótkim lecz bezpiecznym i chętnie wykorzystywanym w dziedzinie bezpieczeństwa informatycznego:

``` bash
ssh-keygen -t ed25519 -C "j.ladzinska2002@gmail.com"
```

Drugi klucz ecdsa również jest popularnym kluczem, który zapewnia wysoki poziom bezpieczeństwa i wydajności. Dodatkowo zabezpieczyłam go hasłem:

![2.1](screenshots/2.1.png)
![2.2](screenshots/2.2.png)

Zapewniają one bezpieczeństwo podczas uzyskiwania dostępu i przesyłania danych wykorzystując wygenerowane klucze: prywatny znajdujący się na serwerze i publiczny dodany do konta GitHub, bez konieczności posługiwania ię hasłami.

3. Klonowanie repozytorium za pomocą protokołu HTTPS i personal access token:

Jest to alternatywny sposób na sklonowanie repozytorium na nasz serwer. W ustawieniach konta na GitHubie generujemy token i z jego pomocą klonujemy repozytorium. 

![3.1](screenshots/3.1.png)

``` bash
git clone https://username:token@github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```

Jest metodą mniej bezpieczną, często wymagającą od nas podawania hasła lub nazwy użytkowanika.

4. Przełączanie się na gałąź grupy:

W celu przełącznia się na istniejącą już gałąź skorzystam z komendy:

``` bash
git checkout GCL2
```

Początkowo znajdowałam się na głównej gałęzi ```main``` i z niej przeszłam na gałąź ```GCL2```.

5. Tworzenie swojej gałęzi:

Mój branch będzie miał nazwę składającą się z moich inicjałów i numeru indeksu: ```JL410406```.

Mogę utworzyć tę gałąź komendą

```bash
git branch JL410406
```

A następnie przejść do niej wykorzystując ```checkout'a``` lub korzystając z jednej komendy od razu utworzyć ją i do niej przejść:

``` bash 
git checout -b JL410406
```

Aby sprawdzić listę branchy wykorzystujemy:

```bash
git branch
```

Wyświetlają nam się wtedy wszystkie dostępne lokalnie branche, a ten w któym aktualnie się znajdujemy ma przy swojej nazwie symbol ```*```.
![5.1](screenshots/5.1.png)

6. Praca na własnej gałęzi:

- W katalogu grupy tworzę mój prywatny katalog oraz katalog Sprawozdanie1 odnoszący się do dzisiejszych zajęć. Jego ścieżka: ```MDO2024_INO/INO/GCL2/JL410406/Sprawozdanie1```

- W pierwszej kolejności, aby uniknąć pomyłek, a moje commit message spełniały wymóg tworzę Git hooka. Jest to skrypt odpalający się przy robieniu commitów i weryfikujący czy commit message rozpoczyna się od moich inicjałów i numeru indeksu. 

- Po analizie Git hook'ów z folderu ```MDO2024_INO/.git/hooks``` wybralam ```commit-msg``` i na jego podstawie utworzyłam własny, który umieściłam w moim folderze.

![6.1](screenshots/6.1.png)

- Następnie kopiuję go do katalogu ```.git/hooks``` i nadaję odpowiednie uprawnienia dla poprawnego działania.

![6.2](screenshots/6.2.png)

- W celu pracy nad repozytourium korzystam z czterech podstawowych komend:

```bash
git status
```

Wyświetla i informuje nas o wszystkich zmianach, które wprowadziliśmy i różnią naszą lokalną wersję repozytorium od zdalnej.

```bash
git add .
```

Dodaje wszystkie wprowadzone zmiany do stage area, gdzie oczekują na zatwierdzenie.

```bash
git commit -m "JL410406 treść"
```

Zatwierdza zmiany w repozytorium i przesyła wiadomość z informacją o zmianach.

```bash
git push
```

Polecenie to wysyła zatwierdzone zmiany do zdalnego repozytorium Git.

# Git, Docker

- Do zainstalowania Dockera korzystam z komendy:

```bash
sudo apt install docker.io
```

- A następnie rejestruje się w  [Docker Hub](https://hub.docker.com/):

![7.1](screenshots/7.1.png)

- Do pobierania obrazów można posłużyć się komendą:

```bash
sudo docker pull hello-world
```

Jednakże ja skorzystałam z ```run```, które od razu uruchamia pobrany obraz:

![8.1](screenshots/8.1.png)

- Uruchomiłam kontener z obrazu `busybox`.

Po sprawdzeniu listy kontenerów widzimy, że busybox zakończył juz swoje zadanie bez błędów:
![9.1](screenshots/9.1.png)

Dlatego z pomocą komendy

```bash
sudo docker run -it busybox
```

podłączam się do niego interaktywnie, dzięki czemu mogę korzystać z jego powłoki i komunikować się z systemem kontenera. Wywołuje numer wersji:

![10.1](screenshots/10.1.png)

- Po interaktywnym uruchomieniu systemu fedora instaluje paczkę `procps-ng` służącą do monitorowania procesów i wykorzystując

```bash 
ps aux
```

Wyświetlam wszystkie procesy działające na serwerze. 

![11.1](screenshots/11.1.png)

Następnie aktualizuje wszystkie pakiety i z pomocą `exit` wychodze z kontenera.

![11.2](screenshots/11.2.png)

- W folderze Sprawozdanie1 tworzę prosty plik `Dockerfile` bazujący na fedorze. 

Aktualizuję go i dodaję gita, a następnie klonuje nasze repozytorium do katalogu roboczego `/repo`:

![12.2](screenshots/12.2.png)

Po uruchomieniu i przejściu do odpowiedniego katalogu widzimy, że nasze repozytrium zostało sklonowane poprawnie.

![12.1](screenshots/12.1.png)

- Uruchomione kontenery:

![13.2](screenshots/13.2.png)

Wszystkie zakończyły działanie, dlatego wykonałam jedynie

```bash
sudo docker rm $(sudo docker ps -aq)
```

Inaczej musiałabym najpierw je zatrzymać komendą 

```bash
sudo docker stop $(sudo docker ps -aq)
```

- Czyszczenie obrazów przebiega podobnie do czyszczenia kontenerów. Za pomocą jednej komendy jesteśmy w stanie usunąc wszystkie obrazy znajdujące się w loklanym rejestrze:

![14.1](screenshots/13.2.png)

Przy wykonywaniu polecenia pojawił się problem z odnalezieniem ścieżki ostatnich obrazów, jednakże przy wyświetleniu listy wszystkich obrazów nie pojawiły się tam już żadne obrazy i możemy przyjąć, że wszytskie zostały usunięte: 

![14.2](screenshots/14.2.png)