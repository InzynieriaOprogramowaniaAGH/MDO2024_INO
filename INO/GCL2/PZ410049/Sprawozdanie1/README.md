Paweł Ząbkiewicz, IO

# Cel projektu

Celem projektu jest zapoznanie się z podstawowymi operacjami wykonywanymi przy pracy z systemem kontroli wersji Git oraz platformą GitHub. Dzięki zadaniom zawartym w projekcie można nauczyć sie m.in. korzystac z Git'a, obsługiwać klucze SSH, klonować repozytorium, tworzyć gałęzie, pisać commity oraz githooki. 

# Streszczenie projektu

Na samym wstępie utworzyłem maszynę wirtualną za pomocą programu Oracle VM VirtualBox na systemie Ubuntu w wersji 22.04.3 LTS. Ustawiłem odpowiednie parametry w maszynie wirutalnej zgodnie z instrukcją. 

![Oracle VM VirtualBox](screenshots/1.png)

### 1. Zainstalowanie klienta Git i obsługa kluczy SSH

Klienta Git zainstalowałem za pomocą komendy: 

    apt-get install git

Do obsługi ssh zainstalowałem openssh-client za pomocą komendy: 

    apt-get install openssh-client

Następnie w celu sprawdzenia poprawności instalacji i wersji użyłem następujących komend: 

![git version](screenshots/2.png)

![ssh version](screenshots/3.png)

# 2. Sklonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token

Aby dokonać skolonowania repozytorium za pomocą HTTPS najpierw musiałem wygenerować personal access token w ustawieniach mojego konta na GitHub -> Settings -> Developer settings -> Personal access token -> Tokens(classic). 

![personal access token](screenshots/4.png)

Następnie w celu sklonowania repozytorium za pomocą HTTPS należy wejść do odpowiedniej zakładki w repozytorium i skopiować link. 

![Https](screenshots/5.png)

Komenda, którą należy wykonać wygląda następująco: 

![Https-clone](screenshots/6.png)

# 3. Utworzenie kluczy SSH i sklonowanie repozytorium za ich pomocą

W celu utworzenia kluczy SSH należy poslużyć się poleceniem: 

    ssh-keygen

Wygenerowałem dwa klucze z czego jeden jest zabezpieczomny hasłem. 

Pierwszy klucz to ed25519, którego nie zabezpieczam hasłem. W tym celu podczas konfiguracji pozostawiam puste pola na hasło. Komenda jaką wykorzystałem to: 

    ssh-keygen -t ed25519 -C "pbz2002@gmail.com"

![klucz1](screenshots/7.png)

Drugi klucz to klucz ecdsa, który zabezpieczam hasłem. Używam komendy: 

    ssh-keygen ecdsa -C "pbz2002@gmail.com"

![klucz2](screenshots/8.png)

Wygenerowane klucze znajdują się domyślnie w katalogu '~/.ssh'. Znajduje się tam wersja prywatna i publiczna klucza: 

![klucze](screenshots/9.png)

Za pomocą komendy cat można wyświetlić zawartość klucza publicznego: 

![klucz1.pub](screenshots/10.png)

Następnie należy w ustawieniach konta w serwisie GitHub dodać wcześniej utworzone klucze. Dzięki temu uzyskujemy bezpieczne i wygodne uwierzytelnianie podczas komunikacji z repozytoriami w GitHub za pomocą protokołu SSH. 

Widok dodanych kluczy SSH w serwisie GitHub:

![Klucze SSH w GitHub](screenshots/11.png)

Po dodaniu kluczy SSH do serwisu GitHub można przejść do sklonowania repozytorium za pomocą protokołu SSH. 

Link to sklonowania repozytorium znajduję sie pod zakładką SSH: 

![Link ssh](screenshots/11.png)

Wykonuje to za pomocą komendy: 

    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git

# 4. Przełącznenie na gałaź main, a potem na gałąź swojej grupy

Przełączam się na gałąź main, a nastepnie na gałąź swojej grupy. Aby sprawdzić na jakiej gałęzi jest się obecnie nalezy użyć komendy: 

    git branch

W celu sprawdzenia wszystkich istniejących gałęzi należy posłużyć się poleceniem: 

    git branch --all

Aby przełaczyć się na gałąź naszej grupy trzeba użyć komendy: 

    git checkout GCL2

# 5. Utworzenie gałęzi o nazwie "inicjały & nr indeksu"

Gdy znajduję sie na galęzi mojej grupy, mogę utworzyć i przełączyć sie na moją gałąź za pomocą komendy: 

    git checkout -b PZ410049

Sprawdzam, czy jestem na odpowiendiej gałęzi: 

    git branch

![branch](screenshots/16.png)


# 6. Rozpoczęcie pracy na nowej gałęzi

#### Tworzę katalog o nazwie "inicjały & nr indeksu" w folderze grupy 

Tworzę katalog dla grupy "GLCL2" i w nim tworzę katalog o nazwię "PZ410049" za pomocą polecenia:
    mkdir PZ410049

#### Napisanie Git hooka i dodanie go do wcześniej utworzonego katalogu

Git hook ma wefyfikować każdy "commit message". Skrypt ten ma sprawdzać, czy "commit message" zaczyna się od inicjałów i numeru indeksu, czyli w moim przypadku "PZ410049".

W celu jego utworzenia modyfikuje plik w folderze ".git/hooks" o nazwie "commit-msg.sample". Należy umieścić skrypt w tym pliku i zmienić jego nazwę na "commit-msg". Dzięki tej nazwie skrypt będzie uruchamiany automatycznie przy każdym commitowaniu. 

![commit-msg](screenshots/13.png)

Następnie kopiuje ten skrypt do wcześniej utworzonego katalogu o nazwie "PZ410049".

Skrypt ten używa polecenia "grep" do sprawdzenia, czy zawartość pliku "COMMIT_MSG_FILE" (czyli plik z wiadomością commitu) rozpoczyna się od wzorca "PZ410049". Jeśli wzorzec nie znajdzie znaleziony to skrypt wyświetli odpowiedni komunikat.

Wyświetlony komunikat w przypadku błędnej treści commita: 

![commit-msg-błąd](screenshots/15.png)

Treść Git Hooka wygląda następująco: 

![commit-msg-treść](screenshots/14.png)

W katalogu o nazwie "PZ410049" tworzę katalog o nazwie "Sprawozdanie1" i umieszczam w nim sprawozdanie o nazwie "README.md" w formacie "Markdown". 

Utworzyłem również katalog o nazwie "screenshots", w którym umieszczam zrzuty ekranu. 

Dodaje do sprawozdania zrzuty ekranu jako inline. Realizuje to poprzez użycie formatu: 

    ![Podpis](ścieżka do zdjęcia)

W moim przypadku ścieżka ta wyglada następująco: 

    ![podpis]("./screenshots/nazwa")

#### W tym kroku wysyłamy zmiany do zdalnego źródła

Na tym etapie pomocna jest komenda: 

    git status

Służy ona do wyświetlania informacji na temat stanu repozytorium. 

![git-status](screenshots/17.png)

W tym celu na początku dodaje pliki do obszaru stage. Jest to pośredni etap, gdzie możemy przygotować nasze zmiany przed zatwierdzeniem ich za pomocą commita. Realizuje to za pomocą polecenia: 

    git add 

![git-add](screenshots/18.png)

Następnie tworzę nowy commit z zatwierdzonymi zmianami w obszarze stage. Do tego służy komenda: 

    git commit

![git-commit](screenshots/19.png)

Końcowym etapem jest wysłanie wszystkich zatwierdzonych commitów z repozytorium lokalnego do repozytorium zdalnego przy użyciu komendy: 

    git push









