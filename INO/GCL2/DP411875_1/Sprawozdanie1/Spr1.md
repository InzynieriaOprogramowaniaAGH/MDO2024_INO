# Sprawozdanie 1
Dagmara Pasek

### Cel ćwiczenia:
Celem wykonanego ćwiczenia było zapoznanie z systemem kontroli wersji, jakim jest Git oraz serwisem Github, tak aby sprawnie zarządzać projektami. Było to związane z zarządzaniem repozytorium kodu, obsługą kluczy ssh, klonowaniem repozytorium za pomocą protokołów: SSH i HTTPS oraz tworzeniem gałęzi i pracy na nich. 

### Przebieg ćwiczenia:

1. Początkowo zainstalowałam maszynę wirtualną Ubuntu wykorzystując narzędzie Parallels. Skorzystałam z zainstalowanego już klienta Git. Sprawdziłam wersję wykorzystując polecenie:
```
   git --version
```

![](./screeny/ss1)


Obsługa kluczy SSH również była już zainstalowana, gdyż poniższe polecenie było rozpoznawane.
```
ssh
```
 

2. Kolejno sklonowałam repozytorium przedmiotowe za pomocą protokołu HTTPS. Utworzyłam osobny katalog, a w nim użyłam polecenia:
 ```
git clone
``` 

![](./screeny/ss2)


Zastosowałam również personal acces token do sklonowania repozytorium w inny sposób. Na Githubie weszłam w ustawienia profilu, Developer Settings i kolejno w okno Personal acces tokens, gdzie wygenerowałam nowy token o nazwie "Token1". Ponownie sklonowałam repozytorium. 


![](./screeny/ss3)

Klonowanie za pomocą HTTPS jest prostszym sposobem, jednak przy każdym pobieraniu kodu należy podawać hasło. Personal access token jest używany do uwierzytelnienia zamiast hasła, co wydaje się bezpieczniejsze. 


3. Jako trzeci krok, utworzyłam katalog, w którym sklonowałam repozytorium przy użyciu protokołu SSH. Za pomocą polecenia:
   
 ```
 ssh-keygen
 ```
   wygenerowałam nowy klucz. Za pomocą polecenia:
```
cat ./.ssh/id_rsa.pub
```
skopiowałam klucz publiczny i dodałam go do mojego konta na platformie Github, wchodząc w ustawienia. 

![](./screeny/ss_klucze.png)

Plik "id_rsa.pub" zawierał klucz publiczny SSH. Pozwalało to na modyfikację repozytorium bez uwierzytelniania hasłem. Następnie sklonowałam repozytorium przedmiotu z wykorzystaniem protokołu SSH. 

![](./screeny/ss4)

4. Przełączyłam się na gałąź main oraz gałąź grupy - GCL2. Wywołałam polecenie:
```
git branch
```
Wyświetlona została lista gałęzi w repozytorium. Gwiazdką oznaczona była aktywna gałąź. 

Polecenie:
```
git checkout -b
```
powodowało utworzenie nowej gałęzi i jednoczesne przełączanie się na nią. 

![](./screeny/ss5)

5. Stosując powyższe polecenie utworzyłam gałąź: DP411875_1 stanowiącą inicjały oraz numer indeksu i przełączyłam się na nią. 


![](./screeny/ss6)

Wyglądało to następująco:

![](./screeny/ss7)

6. Rozpoczęłam pracę na nowej gałęzi. W katalogu grupy GCL2 utworzyłam katalog z inicjałami i numerem indeksu oraz "Sprawozdanie1". Napisałam git hooke'a, czyli skrypt weryfikujący, że każdy "commit message" zaczynał się od inicjałów i numeru indeksu. Utworzyłam go w moim katalogu, a następnie przekopiowałam do katalogu .git/hooks. Bazowałam się na przykładach zawartych w folderze .git i podfolderze hooks.
Treść githooke'a wyglądała następująco:

![](./screeny/hooke.png)

Przy każdym commicie pojawiał się komunikat, w zależności, czy dany commit zaczynał się od: "DP411875_1". Jeśli tak, wyświetlał się komunikat: "Jest ok". W przeciwnym razie: "Błąd: Commit nie zaczyna się od 'DP411875_1'."
Dokonałam sprawdzenia poprawności tego działania.

![](./screeny/spr.png)

W katalogu dodałam plik ze sprawozdaniem oraz dodałam zrzuty ekranu jako inline. Aby to zrobić utworzyłam osobny katalog o nazwie "screeny", do którego kopiowałam zrzuty ekranu za pomocą polecenia:
```
scp ~/Desktop/spr.png parallels@192.168.0.96:~/testssh/MDO2024_INO/INO/GCL2/DP411875_1/Sprawozdanie1/screeny
```



