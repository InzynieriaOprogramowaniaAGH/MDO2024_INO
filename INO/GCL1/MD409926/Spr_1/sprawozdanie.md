Maciej Dziura*
*IO 409926*

**CEL PROJEKTU**


**WYKONANE KROKI**

**1. Zainstalowanie klienta Git i obsługi kluczy SSH**
Aby zainstalować klienta Git i obsługę kluczy korzystamy z menedżera pakietów APT (Advanced Package Tool), który jest wbudowany w system Ubuntu. Aktualizujemy listę dostępnych pakietów, wykonując następujące polecenie:

```sudo apt update```

Po zakończeniu aktualizacji instalujemy klienta Git, wpisując:

```sudo apt install git```

Po zakończeniu instalacji sprawdzamy, czy Git został pomyślnie zainstalowany, wpisując:

```git --version```

![ ](./SS/1.png)

Następnie instalujemy obsługę SSH, wpisując:

```sudo apt install openssh-client```

![ ](./SS/2.png)

Po zakończeniu instalacji upewniamy się, że obsługa kluczy SSH została zainstalowana, wpisując:

```ssh -V```

**2. Klonujemy [repozytorium przedmiotowe] za pomocą HTTPS i [personal access token]**
Wchodzimy na stronę repozytorium na Githubie i z zakładki HTTPS kopiujemy potrzebny link.

![ ](./SS/3.png)

Potrzebujemy jeszcze odpowiednio wygenerowanego tokenu.
Robimy to w ustawieniach konta na Githubie -> Developer settings -> Personal access tokens
Teraz, abyśmy mogli sklonować repozytorium musimy jeszcze potwierdzić naszą tożsamość poprzez zapisanie naszych danych:

```git config --global user.email "dmaciej@student.agh.edu.pl"\n```

```git config --global user.name "dmaciej409926"```

Klonujemy nasze repozytorium korzystając z wcześniej skopiowanego linku:

```git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git```

**3. Klonujemy [repozytorium przedmiotowe] za pomocą utworzonego klucza SSH.**

- Tworzymy dwa klucze SSH w tym jeden zabezpieczony hasłem

Generujemy pierwszy klucz ed25519 bez hasła (pole na hasło pozostawiamy puste). Korzystamy z komendy:

```ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519```

![ ](./SS/4.png)

Generujemy drugi klucz ecdsa już z hasłem:

```ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa```

![ ](./SS/5.png)

- Konfigurujemy klucz SSH jako metodę dostępu do GitHuba

Wygenerowane klucze pojawiają nam się w miejscu zapisu w wersji publicznej (.pub) jak i w prywatnej. Możemy skonfigurować nasz klucz z hasłem na platformie Github. Wykonujemy to poprzez skopiowanie zawartości publiczego klucza (zawartość wyświetlamy za pomocą konsoli i komendy cat):

![ ](./SS/6.png)

Wklejamy zawartość w odpowiednie miejsce na platformie Github. W ustawienach konta wchodzimy w zakładkę SSH and GPG keys i dodajemy klucz:

![ ](./SS/7.png)

- Klonujemy repozytorium z wykorzystaniem protokołu SSH

Wchodzimy na stronę repozytorium na Githubie i kopiujemy zawartośc zakładki SSH

![ ](./SS/8.png)

Klonujemy nasze repozytorium (będzie wymagane podanie hasła utworzonego podczas generowania klucza):

```clone git git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git```

![ ](./SS/9.png)

**4. Przełączamy się na gałąź ```main```, a potem na gałąź swojej grupy.**
Wchodzimy do folderu i sprawdzamy wszystkie istniejące gałęzie przy pomocy komendy:

```git branch --all```

![ ](./SS/10.png)

Widzimy gałąź naszej grupy GCL1, na którą przełączamy się za pomocą komendy:

```git checkout GCL1```

Sprawdzamy na jakiej gałęzi się znajdujemy:

```git branch```

![ ](./SS/11.png)


**5. Tworzymy gałąź o nazwie "inicjały & nr indeksu".

Gdy już znajdujemy się na gałęzi grupy możemy stworzyć swoją gałąź na której będziemy dokonywać zmian, wykonujemy to w ten sposób:

```git checkout -b MD409926```

Po jej stworzeniu od razu powinniśmy się na niej znaleźć, sprawdzamy czy tak się stało:

```git branch```

![ ](./SS/12.png)

**6. Rozpoczynamy pracę na nowej gałęzi**

- W katalogu właściwym dla grupy tworzymy nowy katalog, także o nazwie "inicjały & nr indeksu"
Na swojej gałęzi przechodzimy do folderu grupy (~/MDO2024_INO/INO/GCL1) i tam tworzymy swój folder o identycznej nazwie do naszej gałęzi:

```mkdir MD409926```

- Napisanie Git hook'a - skryptu weryfikującego, że każdy nasz "commit message" zaczyna się od "twoje inicjały & nr indexu".
Na podstawie przykładowych git hooków znajdujących się w folderze .git/hooks tworzymy skrypt (commit-msg) sprawdzający, czy każdy nasz commit zaczyna się od naszych inicjałów i numeru ideksu (MD409926):

```nano commit-msg```

- Kopiujemy go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robimy commita

Aby git hook działał prawidłowo należy skopiować go do folderu .git/hooks:

cp ~/MDO2024_INO/INO/GCL1/MD409926/commit-msg ~/MDO2024_INO/.git/hooks

Należy naszemu git hookowi nadać uprawnienia, aby mógł być wykonywany, używamy komendy:

```chmod +x ~/MDO2024_INO/.git/hooks/commit-msg```

Od teraz będzie uruchamiany przy każdym naszym commicie. Możemy teraz przetestować nasz skrypt.

Błędny commit:

![ ](./SS/14.png)

Prawidłowy commit:

![ ](./SS/15.png)

- Umieszczamy treść githooka w sprawozdaniu.

![ ](./SS/13.png)

- W katalogu dodajemy plik ze sprawozdaniem
W naszym katalogu tworzymy katalog przeznaczony na sprawozdanie, a w nim katalog na screenshoty potrzebne do sprawozdania:

```mkdir Spr_1```

```mkdir SS```

I teraz w katalogu Spr_1 dodajemy sprawozdanie w formacie "Markdown":

```nano sprawozdanie.md```

![ ](./SS/16.png)

- Dodajemy zrzuty ekranu (jako inline)

Dodajemy zrzuty ekranu jako zdjęcia - inline. Używamy w tym celu :

```![opis](ścieżka do zdjęcia)```

W naszym przypadku ścieżka będzie w postaci:

```![ ]("./SS/nazwa_zdjęcia")```

- Wysyłamy zmiany do zdalnego źródła
Do wysłania zmian wykorzystujemy 3 komendy:

Najpierw dodajemy jakie zmiany zaszły (dodanie/edycja plików):

```git add```

![ ](./SS/17.png)

Następnie tworzymy commit opisujący dodane/zmienione pliki:

```git commit```

![ ](./SS/18.png)

Na końcu wypychamy nasze zmiany do źródła - w naszym przypadku do repozytorium na GitHubie:

```git push```

![ ](./SS/19.png)

- Próbujemy wciągnąć naszą gałąź do gałęzi grupowej

Przechodzimy na gałąź naszej grupy:

```git checkout GCL1```

```git push```

- Aktualizujemy sprawozdanie i zrzuty o ten krok i wysyłamy aktualizację do zdalnego źródła (na naszej gałęzi)
Wykorzystamy do tego ponownie 3 polecenia:

```git add ./```

```git commit -m "MD409926 - sprawozdanie"```

```git push```