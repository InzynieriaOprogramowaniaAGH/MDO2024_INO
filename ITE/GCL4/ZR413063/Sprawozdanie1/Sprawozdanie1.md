Sprawozdanie nr 1

1. 001-Task

Na tym laboratorium głównym celem było ustawienie githuba oraz później repoozytorium na maszynie wirtualnej by było zgodne z wymaganiami.

1. 1. Klonowanie repozytorium

By móc sklonować repozytorium musiałam najpierw pobrać gita na maszynę wirtualną. Będąc w katalogu domowym zainstalowałam go przy użyciu komendy:
    sudo apt install git
By upenić się, że git został pobrany sprawdziłam jego wersję:
    git --version

Po wykonaniu tych czynności nie mogłam jednak prezjść od razu do klonowania repozytorium. Musiałam ustanowić połączenie ssh między maszyną a githubem. Do realizacji tego z katalogu domowego przeszłam do katalogu .ssh:
    cd .ssh
Który jest domyślnym katalogiem by przechowywać takie informacje jak prywatne i publiczne klucze autoryzacyjne. Są to niezwykle poufn rzeczy i powinny być pilnie strzeżone. Katalog .ssh jest katalogiem domyślnie chronionym przez system, mają do niego dostęp tylko właściciel i root. Jest też ukryty i nie pojawia się w spisie po użyciu zwykłej komendy ls.

Po upewnieniu się, że znajduję się w katalogu .ssh, wygenerowałam klucze autoryzacyjne:
    ssh-keygen
W tym momencie wygenerowałam parę kluczy: prywatny i publiczny. Zostały zapisane w domyślnych plikach.

NAstępnie pobrałam klucz publiczny, który pozwoli mi ustanowić połączenie ssh z githubem. Klucz znajdował się w pliku id_rsa.pub i wypisałam go na terminal do skopiowania komendą:
    cat id_rsa.pub

Po skopiowaniu klucza przezszłam na stronę githuba, zalogowałam się na swoje konto i przeszłam do ustawień.  Przeszłąm do zakładki SSH and GPG keys i kliknęłam "new SSH key". Dodałam swój klucz.

By sprawdzić ustanowione połączenie w mojej maszynie wirtualnej użyłam komendy:
    ssh git@github.com
Wyświetliła mi sie informacja powitalna z moim nickiem githubowym i wiadomością, że zostałam pomyślnie zindentyfikowana.

Teraz mogłam przystąpić do sklonowania repozytorium. Przeszłam do odpowiedniego katalogu, do którego chciałam sklonować repo i użyłam polecenia:
    git clone <link ssh repozytotium githuba>

1. 2. Tworzenie gałęzi

Przeszłam do katalogu mojego repozytorium i sprawdziłam na jakiej gałęzi się znjaduję:
    git branch
Domyślnie wylądowałam na głównej gałęzi repozytorium - main. Pracując wspólnie na repozytoium dobrą praktyką jest, by tworzyć własną gałąź lub gałąź danego elementu. Ułatwia to prace nad wspólnym projektem oraz porządek w repozytorium. Jest to również bezpieczniejsze niż wypychanie wszystkiego na główną gałąź produkcji.
By przejść na gałąź dedykowaną mojej grupie laboratoryjnej wpisałam:
    git checkout GCL4

Następnie od tej gałęzi poprowadziłam swoją osobistą gałąź roboczą na której będę umieszczać swoje commity. Zgodnie z ustaleniami nazwałam ją swoimi inicjałami i numerem indeksu więc polecenie w terminalu wyglądało tak:
    git branch ZR413063

Przeszłam na swoją gałąź i byłam gotowa by tworzyć nowe commity.
Przeszłam do katalogu grupy laboratoryjnej, gdzie stworzyłam nowy katalog ZR413063.

1. 3. Git hook

Git hook to wspaniałe narzędzie, bardzo ułatwiające pracę w repozytorium. Są skryptami, które wykonują się automatycznie w określonych przez użytkownika zdarzeniach: przed commitem, po commitcie, mogą np sprawdzić też naszą wiadomość - commit message.

Miałam za zadanie stworzyć hook, który automatycznie sprawdzałby, czy moja commit message zacyzna się od moich inicjałów i numeru albumu.
Stworzyłam nowy plik w katalogu ZR413063 o nazwie commit-msg. Dzięki tej nazwie hooka git wykryje, kiedy mój hook ma zostać wywołany. W tym przypadku hook zostanie wywołany po utworzeniu wiadomości commita ale przed utworzeniem commita. Commit zostanie utworzony gdy hook zakończy pracę z powodzeniem.

Zawartość mojego hooka prezentuje się tak:

#!/bin/bash
# pobieram wartość wiadomości
commit_msg=$(cat "$1")
# wzór wg którego hook ma sprawdzać poprawność wiadomości         
sprawdzenie="^ZR413063 .*$"    

# sprawdzenie czy początek wiadomości zgadza się ze wzorem, jeśli tak hook kończy działanie z wartością 0, w przeciwnym wypadku zostanie wyświetlona poniższa wiadomość na terminalu
if [[ ! "$commit_msg" =~ $sprawdzenie ]]; then
echo "Commit message nie zaczyna się od twoich inicjalow i numeru indeksu. Zmien prosze tresc commit message i sprobuj ponownie"
exit 1
fi

By hook mógł działać i faktycznie sprawdzać każdy commit musiałam go skopiować do katalogu .git/hooks w repozytorium do czego użyłam prostej komendy cp.
Następnie musiałam nadać mu uprawnienia wykonywalne:
    chmod +x /home/zuza/devops/MDO2024_INO/.git/hooks/commit-msg

By sprawdzić czy na pewno działa zaczęłam testować na różnych wiadomościach w trakcie commitów:
# wstawic screeny

1. 4. Pierwszy commit

Przyszedł zas na pierwszy commit.
By stworzyć nowy commit wróciłam do katalogu grupy laboratoryjnej (GCL4) i sprawdziłam czy jakiś plik czeka na commit:
    git status

By dodać oczekujące pliki do obszaru przygotowania, który póżniej będę commitować użyłam:
    git add .
Kropka na końcu polecenia wskazuje, że wszystkie pliki nieśledzone zostaną dodane do obszaru śledzenia.

Commitowanie odbywa się za pomocą polecenia:
    git commit -m "ZR413063 commit"
Opja -m pozwala dodać wiadomość do commita bez potrzeby otwierania edytora tesktu. Dzięki stworzonemu wcześniej hookowi, moja wiadomość została sprawdzona pod kątem poprawności jej zaczęcia.

By wypchnąć zmiany na zdalne repozytorium użyłam komendy:
    git push --set-upstream origin ZR413063
Opcja --set-upstream jest ważna przy pierwszym pushu, ustawia gałąź zdalną jako gałąź śledzoną dla bieża=ącej gałęzi lokalnej.

2. Docker

Docker jest platformą, która umożliwia automatyzację procesu budowania, wdrażania i zarządzania kontenerami.

2. 1. Instalacja Dockera

Pracę z dockerem zaczęłam od jego instalacji. Będąc w katalogu domowym zastosowałam komendy znalezione na oficjalnej stronie dockera:
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh --dry-run
# screen
Była to najszybsza metoda instalacji dockera na ubuntu jednak nie najbezpieczniejsza. Instalacj odbyła się za pomocą skryptu z internetu, który został uruchomiony z uprawnieniami administartora. Nie mamy więc kontroli nad zawartością takiego skryptu. Brak też jego weryfikacji, więc nie możemy być pewni czy nie został zmieniony i czy nie instaluje dodatkowych rzeczy, które byłyby niepożądane. Dobrą praktyką jest by pobierać takie skrypty tylko z wiarygodnych źródeł a najlepiej ich unikać.

By sprawdzić poprawność instalacji dockera wyświetliłam jego obrazy:
    sudo docker images
# screen

By nie musieć za każdym razem korzystając z polecenie dockera dodawać na początku sudo, które tymczasowo nadaje użytkowniki prawa administartora, dodałma swojego użytkownika maszyny wirtualnej do grupy docker:
    sudo usermod -aG docker <user>
Gdzie <user> zastąpiłam swoją nazwą użytkownika, a opcja -aG dodaje użytkownika do konkretnej grupy nie usuwając go przy tym z grup, do których już należy.
Po wykonaniu tej komendy musiałam wpisać swoje hasło a następnie się wylogowałam by wprowadzone zmiany mogły wejść w życie.

Po ponownym zalogowaniu sprawdziłam, czy dodanie do grupy użytkownika przebiegło pomyślnie:
    groups <user>
# screen

2. 2. Pobieranie obrazów

Po upewnieni się, że wszystko działa rozpoczęłam ściąganie wymaganych obrazów:
- hello-world: docker pull hello-world
- busybox: docker pull busybox
- ubuntu: docker pull ubuntu
- mysql: docker pull mysql

Na koniec pononwnie użyłam komendy docker images by upenić się, że obrazy zostały ściągnięte.
# screen

2. 3. Uruchamianie kontenera z obrazu busybox

Kontener busybox uruchomiłam nadając mu też nazwę poleceniem:
    docker run -d --name <nazwa_kontenera> busybox
W tym momencie uruchomiłam mój kontener do pracy w tle. By sprawdzić czy faktycznie działa, uzyłam polecenia, które pokazuje wszystkie uruchomione kontenery:
    docker ps

Okazło się, że moja lista jest pusta. Kontener został uruchomiony poprawnie jednak kontenery docker mają to do siebie, że kończą swoje działanie jeśli nie mają procesów działających w tle. Sprawdziłam więc czy znajduje się na liście wszystkich kontenerów i na pewno został stworzony:
    docker ps -a
# screen

Kontener jest nieaktywny, by go uruchomić muszę się do niego podłączyć interaktywnie używając opcji -it.
Komenda do interaktywnego uruchomienia kontenera wygląda tak:
    docker run -it --name kontener_bb busybox

Na uruchomionym kontenerze busybox sprawdziłam numer wersji busyboxa:
    busybox | head -1
# screen

2. 4. Uruchamianie systemu w kontenerze

By uruchomić "system w kontenerze" czyli kontener z obrazem systemu ubuntu użyłam komendy:
    sudo docker run -it ubuntu

By sprawdzić PID użyłam prostej komendy:
    ps -p 1
SPrawdziłam również procesy dockera na hoście:
    ps -ef
# screen

Kolejnym zadniem na systemie uruchomionym w kontenerze było zaktualizowanie pakietów. Pobrałam listę dostępnych aktualizacji:
    apt-get update
Następnie je pobrałam:
    apt-get upgrade

Po zakończonych aktualizacjach wyszłam z kontenera wpisując exit w terminalu i klikając enter.

2. 5.  Tworzenie i uruchamianie własnego pliku Dockerfile

Do stworeznie pliku Dockerfile użyłak komendy:
    touch Dockerfile
Przy tworzeniu tych plików jest ważne, by miały one dokładnie nazwę Dockerfile gdyż docker domyślnie szuka plików o tej nazwie.

Następnie stworzyłam nowy obraz ubuntu. W tym momencie plik Dockerfile wykona się automatycznie.
    docker build -t nowe_ubuntu .
Kropka w poleceniu na końcu jest ważna, wskazuje na bieżący katalog gdzie docker ma szukać Dockerfile.

Następnie uruchomiłam interaktywnie stworzony obraz:
    docker run -it nowe_ubuntu bash

Obraz został uruchomiony i znalazłam się w katalogu roboczym app który podałam w Dockerfile. Aby sprawdzić, czy repozytorium zostało sklonowane użyłam komendy ls. Jak widać na screenie repozytorium znjaduje się w moim katalogu roboczym w obrazie:
# screen

2. 6. Czyszczenie kontenerów

By wyświetić wszystkie kontenery, nie tylko te działające użyłam komendy:
    docker ps -a
# screen

By usunąć kontenery użyłam polecenia:
    docker container prune
Należy pamiętać, że to polecenie jest permanentne i nie się go odwrócić, dlatego docker zawsze prosi o potwierdzenie pozwolenia na wykonanie polecenia.
# screen

2. 7. Czyszczenie obrazów

By usunąć obrazy i zwolnić miejsce na dysku użyłam bardzo podobnej komendy co do usuwania kontenerów:
    docker image prune
Usunie to wszystkie nie używane przez żadne kontenery obrazy.
By usnąć nie tylko te nieużywane obrazy nalęzy użyć trochę innej komendy:
    docker rmi -f <id_obrazu>
Id obrazu można pobrać z kolumny IMAGE ID po uruchomieniu polecenia:
    docker images
# screen

2. 7. Repozytoium

Na sam koniec posprzątałam pliki by wszystko było gotowe na commit do repozytorium.
Przede wszystkim do katalogu Sprawozdanie1 dodałma stworzony plik Dockerfile.

WNIOSKI
Przerobienie instrukcji pozwoliło mi zapoznać się z działaniem na gałęziach repozytorium oraz wprowadziło w temat kontenerów Docker.
Zadania były proste totż ni przysporzyły mi większych kłopotów. 
Nie pracując wczesniej z githubem musiałam trochę nauczyc się o pracy na gałeziach czy też dodawaniu commitów.
Największym problem jaki napotkałam (lacz mało znczącym) było to, że mimo dodania użytkownika do grupy docker i nadaniu mu wszystkich praw nie byłam wstanie uruchamiać poleceń docker bez wcześniejszego dopisania sudo. Opcja działała do momentu gdy nie wyłączyłam i włączyłam spowrotem VS Code.
