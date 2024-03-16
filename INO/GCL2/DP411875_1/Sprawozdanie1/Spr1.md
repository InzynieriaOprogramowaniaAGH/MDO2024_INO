# Sprawozdanie 1
Dagmara Pasek

### Cel ćwiczenia:
Celem wykonanego ćwiczenia było zapoznanie z systemem kontroli wersji, jakim jest Git oraz serwisem Github, tak aby sprawnie zarządzać projektami. Było to związane z zarządzaniem repozytorium kodu, obsługą kluczy ssh, klonowaniem repozytorium za pomocą protokołów: SSH i HTTPS oraz tworzeniem gałęzi i pracy na nich. 

### Przebieg ćwiczenia:

1. Początkowo zainstalowałam maszynę wirtualną Ubuntu wykorzystując narzędzie Parallels. Skorzystałam z zainstalowanego już klienta Git. Sprawdziłam wersję wykorzystując polecenie:
```
   git --version
```

<img width="386" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/7d5aeee6-5e27-4e9b-9b4a-ac22c9c77a77">

Obsługa kluczy SSH również była już zainstalowana, gdyż poniższe polecenie było rozpoznawane.
```
ssh
```
 

2. Kolejno sklonowałam repozytorium przedmiotowe za pomocą protokołu HTTPS. Utworzyłam osobny katalog, a w nim użyłam polecenia:
 ```
git clone
``` 

<img width="833" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/02c45e7b-910a-4c5a-8ced-b231efbcebe8">


Zastosowałam również personal acces token do sklonowania repozytorium w inny sposób. Na Githubie weszłam w ustawienia profilu, Developer Settings i kolejno w okno Personal acces tokens, gdzie wygenerowałam nowy token o nazwie "Token1". Ponownie sklonowałam repozytorium. 


<img width="1430" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/be87b3b6-f820-4e96-a1d5-bbebef4af50d">

Klonowanie za pomocą HTTPS jest prostszym sposobem, jednak przy każdym pobieraniu kodu należy podawać hasło. Personal access token jest używany do uwierzytelnienia zamiast hasła, co wydaje się bezpieczniejsze. 


3. Jako trzeci krok, utworzyłam katalog, w którym sklonowałam repozytorium przy użyciu protokołu SSH. Za pomocą polecenia:
   
 ```
 ssh-keygen
 ```
   wygenerowałam nowy klucz. Za pomocą polecenia:
```
cat ./.ssh/id_rsa.pub
```
skopiowałam klucz publiczny i dodałam go do mojego konta na platformie Github, wchodząc w ustawienia. Plik "id_rsa.pub" zawierał klucz publiczny SSH. Pozwalało to na modyfikację repozytorium bez uwierzytelniania hasłem. Następnie sklonowałam repozytorium przedmiotu z wykorzystaniem protokołu SSH. 

<img width="841" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/4751bb66-13de-4543-be75-00aca5f7c52f">

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

<img width="600" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/3f424f92-bf2c-4866-802e-0d9e6a6da9f8">

5. Stosując powyższe polecenie utworzyłam gałąź: DP411875_1 stanowiącą inicjały oraz numer indeksu i przełączyłam się na nią. 


<img width="632" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/1970ffd9-2b02-4117-96a7-658228ca940c">

Wyglądało to następująco:

<img width="583" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/94080090/f5429a8a-9f49-41d5-b92c-7a77f3ac9ae0">

6. Rozpoczęłam pracę na nowej gałęzi. W katalogu grupy GCL2 utworzyłam katalog z inicjałami i numerem indeksu oraz "Sprawozdanie1". 



