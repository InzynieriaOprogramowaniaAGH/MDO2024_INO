# Sprawozdanie 1

### Konfiguracja maszyny
Po zajęciach organizacyjnych zająłem się postawieniem maszyny wirtualnej z której będę korzystał w trakcie kolejnych zajęć. Zainstalowałem system [Ubuntu server w wersji 22.04 LTS](https://ubuntu.com/download/server) ze względu na jego popularność, oraz mnogość rozwiązań na potencjalne problemy.
Pakiet Git został zainstalowany wraz z systemem, zatem tylko zapoznałem się tylko z jego wersją korzystając z komendy:
```
git --version
```

### Obsługa kluczy SSH
Do obsługi kluczy SSH wykorzystam domyślnie zainstalowany pakiet programów **Openssh**. Zezwala on na komunikację w sieci korzystając z protokołu SSH przy pomocy narzędzi takich jak:
- SSH - nawiązuje połączenia ze zdalnymi serwarami SSH
- SCP i SFTP - kopiowanie oraz interaktywne przesyłanie plików pomiędzy urządzeniami
- SSHD - serwer SSH
- SSH-keygen - generator kluczy służących do uwierzytelniania zdalnego logowania
Ten ostatni użyję w celu wygenerowania klucza, który posłuży do komunikacji pomiędzy maszyną wirtualną a repozytorium na Githubie. Zapoznałem się z odpowiednią [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) , a następnie w terminal wpisałem komendę:
```
ssh-keygen -t ed25519 -C "example@email.com"
```
gdzie argumenty to:
`-t` - typ klucza
`-C` - komentarz, nie jest wymagany ale pozwala na łatwe odróżnienie kluczy.
Przykładowe działanie powyższej komendy:
![Pasted image 20240318000957.png]
Po wylistowaniu pliku w katalogu można zauważyć dwa nowoutworzone pliki:
![Pasted image 20240318002312.png]
Pierwszy z nich to klucz prywatny, a drugi to klucz publiczny.  Klucz publiczny należało dodać do swojego profilu.

### Klonowanie repozytorium
Są dwa sposoby na sklonowanie repozytorium - protokół HTTPS oraz SSH. Publicznego repozytoria nie wymagają żadnych danych od użytkownika. Sprawa ma się inaczej w przypadku repozytoriów prywatnych.
Chcąc sklonować repozytorium za pomocą HTTPS należy wygenerować i użyć **personal access token**. Można go wygenerować korzystając z [instrukcji](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).  W celu pobrania repozytorium używamy komendy:
```
git clone "link do repozytorium"
```
Przykładowy wynik działania takiej komendy (HTTPS):
![Pasted image 20240318102647.png]
Link do repozytorium znajduje się na Githubie pod przyciskiem **Code**.
W przypadku kluczy SSH sprawa jest nieco bardziej skomplikowana. Jeżeli klucze zostały utworzone w "głównym" folderze należało je przenieść do folderu *.ssh* oraz odpowiednio nazwać (przykładowo id_ed25519).
Jeżeli klucz został uprzednio dodany do konta, można po raz kolejny skorzystać z komendy klonowania podanej wyżej. W przypadku zabezpieczonego klucza wystąpi zapytanie o hasło.
![Pasted image 20240318103849.png]
Pojawi się katalog o nazwie repozytorium w miejscu gdzie obecnie znajdujemy się w systemie.
### Praca z gałęziami
Po przejściu do pobranego katalogu można rozpocząć pracę z gałęziami. Użycie komendy:
```
git branch
```
drukuje na ekran gałęź w której obecnie się znajduję
![Pasted image 20240318105448.png]
Jak można zauważyć na powyższym zrzucie ekranu obecnie znajduję się w swojej gałęzi, która jest podgałęzią *main*.
W przypadku potrzeby utworzenia nowej gałęzi należy użyć:
```
git checkout -b "nazwa gałęzi"
```
gdzie argument `-b` wskazuje na nazwę nowej gałęzi.
![Pasted image 20240318110033.png]
Zostajemy także natychmiastowo przeniesieni do nowej gałęzi. Jak można zauważyć, już wcześniej utworzyłem gałąź ze swoimi inicjałami oraz numerem indeksu. Tam będą przeprowadzane wszystkie zmiany oraz dalsza praca z laboratoriami, aby nie zakłócać pracy innych użytkowników. W ten także sposób jestem w stanie monitorować zmiany jakich dokonuję.
W swojej gałęzi utworzyłem folder *Sprawozdanie1* w którym zawarłem plik *readme.md* w którym potem zawrę to sprawozdanie. 
### Git hooks
Hook'i to skrypty służące do weryfikowania commitów oraz dołączonych do nich wiadomości. W tym przypadku miał on kontrolować, że moje commity zaczynają się od moich inicjałów i numeru indeksu w celu łatwego rozróżnienia ich pochodzenia. W przypadku nie spełnienia tych warunków zostaje zwrócony komunikat, a commit nie zostaje wykonany. Poniżej zawartość skryptu:
![Pasted image 20240318115201.png]
W celu wysłania zmian do zdalnego źródła należy wykonać sekwencję komand:
```
git add
git commit -m "treść wiadomości"
git push
```
przydatna jest także komenda
```
git status
```
pokazująca zmiany jakie zaszły od ostatniej pushniętej wersji
![Pasted image 20240318122140.png]
Na powyższym zrzucie ekranu widać, że żadna zmiana nie zaszła w mojej gałęzi.
### Docker
Aby pobrać paczkę *Docker* należało wpisać w terminal komendę:
```
sudo apt install Docker
```
Następnie pobrałem wymagane obrazy z instrukcji:
```
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull mysql
sudo docker pull ubuntu
```
Przykładowy wydruk korzystając z powyższej instrukcji. Dla przykładu pobrałem obraz z **Fedorą**.
![Pasted image 20240318131244.png]
Można także wypisać listę pobranych obrazów:
![Pasted image 20240318131324.png]

### Uruchamianie kontenerów
Uruchamiamy przykładowy kontener z obrazu **busybox** przy pomocy:
```
sudo docker run busybox
```
Uruchomiony bez żadnych argumentów nie zwraca nic, nawet błędu. Aby zobaczyć wszystkie konterery jakie zostały uruchomione wcześniej w systemie wykorzystujemy komendę:
```
sudo docker contaier list -a
```
Wyświetlona lista prezentuje się w następujący sposób:
![Pasted image 20240318134529.png]
Jak można zauważyć, interesujący nas kontener **busybox** wyszedł z błędem *0*, zatem poprawnie zakończył pracę. Wynika to z tego że nie miał zleconej żadnej pracy.

Jest jednak możliwość podłączenia się do kontenera w sposób interaktywny dodając argument `-it` do komendy `run`. Pozwala to na korzystanie z poleceń w kontenerze.
```
sudo docker run -it busybox
```
Aby otrzymać informację o numerze wersji kontenera można użyć komendy
```
cat --help
```
Ten zestaw poleceń pozwala na połączenie się do kontenera, a także zapoznanie się z jego wersją:
![Pasted image 20240318143535.png]

### System w kontenerze
Aby wykonać to zadanie uruchomię w sposób interaktywny kontener z systemem *ubuntu* . Uruchomię także drugi terminal, aby móc kontrolować działanie kontenera z zewnątrz.
W terminalu kontenera używam komendy `ps` w celu wyświetlenia PID1. Jest on odpowiedzialny za inicjację pozostałych procesów.
![Pasted image 20240318150328.png]
W celu aktualizacji pakietów w kontenerze wykorzystam to samo polecenie co w normalnym systemie:
```
apt-get update
```
![Pasted image 20240318150828.png]
W celu wyjścia z kontenera należy użyć prostego polecenia `exit`
### Dockerfile
Ostatnie zadanie polegało na utworzeniu własnego *Dockerfile*, który bazując na wybranym systemie - w moim przypadku Ubuntu - sklonuje repozytorium przedmiotowe. 
Najpierw należało ustawić odpowiedni syntax dla pliku:
```
# syntax=docker/dockerfile:1
```
Aby zachować dobre praktyki budowania plików typu *Dockerfile*, należy pobrać i zaktualizować odpowiednie pakiety, w tym przypadku git oraz ssh.
```
RUN apt-get update && apt-get install -y git ssh
```
Tworzymy zmienną dla klucza prywatnego, do którego ścieżka będzie podawana w trakcie budowy projektu:
```
ARG SSH_PRIVATE_KEY
```
Ostatnim ważnym elementem jest dodanie kluczy oraz nadanie uprawnień, aby wszystkie operacje wykonały się bezproblemowo
```
RUN mkdir /root/.ssh/ && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 400 /root/.ssh/id_rsa && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
Jako dodatkową instrukcję dodałem polecenie zmieniające obecny katalog roboczy na ten sklonowany
```
WORKDIR MDO2024_INO
```
Wykorzystując odpowiednią komendę można zobaczyć, że kontener został poprawnie utworzony
![Pasted image 20240318161841.png]
Po dołączeniu się w trybie interaktywnym zgodnie z ostatnią linijką *Dockerfile'a* zostaliśmy od razu przeniesieni do sklonowanego repozytorium:
![Pasted image 20240318162028.png]
### Zarządzanie obrazami
Listę uruchamianych kontenerów można wywołać poleceniem:
```
sudo docker ps -a
```
W celu wyczyszczenia tej listy można użyć dwie komendy:
```
sudo docker rm "nazwa kontenera" - usuwanie wybranego kontenera
sudo docker rm $(sudo docker ps -a -f status=exited -q) - usuwanie rekursywne
```
Przykładowy wynik:
![Pasted image 20240318162831.png]
Aby wypisać listę obrazów należy użyć polecenia:
```
sudo docker images -a
```
Aby je usunąć należy zastosować komendę podobną do tej usuwającej kontenery:
```
sudo docker rmi $(sudo docker images -a -q)
```
Wynik działania tych komend:
![Pasted image 20240318163140.png]
