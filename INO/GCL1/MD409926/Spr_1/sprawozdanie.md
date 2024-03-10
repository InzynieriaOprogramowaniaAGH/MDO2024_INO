*Maciej Dziura*
*IO 409926*

**CEL PROJEKTU**


**WYKONANE KROKI**

**1. Zainstalowanie klienta Git i obsługi kluczy SSH**
Aby zainstalować klienta Git na systemie Ubuntu skożystałem z menedżera pakietów APT (Advanced Package Tool), który jest wbudowany w system Ubuntu.


**2. Sklonuj [repozytorium przedmiotowe] za pomocą HTTPS i [personal access token]**



**3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH.**

- Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem


- Skonfiguruj klucz SSH jako metodę dostępu do GitHuba


- Sklonuj repozytorium z wykorzystaniem protokołu SSH



**4. Przełącz się na gałąź ```main```, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)**



**5. Utwórz gałąź o nazwie "inicjały & nr indeksu". Miej na uwadze, że odgałęziasz się od brancha grupy!**



**6. Rozpocznij pracę na nowej gałęzi**

- W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```

- Napisz Git hook'a - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)

- Dodaj ten skrypt do stworzonego wcześniej katalogu.

- Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.

- Umieść treść githooka w sprawozdaniu.

- W katalogu dodaj plik ze sprawozdaniem

- Dodaj zrzuty ekranu (jako inline)

- Wyślij zmiany do zdalnego źródła

- Spróbuj wciągnąć swoją gałąź do gałęzi grupowej

- Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)

