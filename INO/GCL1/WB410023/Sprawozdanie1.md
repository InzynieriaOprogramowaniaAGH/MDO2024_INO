# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

### Opis celu i streszczenie projektu:

Celem zajęć było zapoznanie się z Git'em i jego podstawowymi funkcjami oraz wykorzystanie SSH poprzez wykonanie następujących czynności: 
- sklonowanie repozytorium przy użyciu nowo utworzonych kluczy SSH,
- utworzenie własnej gałęzi,
- przesłanie nowych plików do repozytorium źródłowego.

Podczas zajęć korzystałam z systemu Ubuntu na Wirtualnej Maszynie.

## Zrealizowane kroki:
### 1. W terminalu zainstalowałam klienta Git. Obsługa kluczy SSH również odbywa się przez terminal.

Zrzut ekranu przedstawiający zainstalowaną wersję Git:

![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image1.png)

### 2. Utworzyłam personal access token.

Wybranie w ustawieniach GitHuba po kolei: 'Developer settings' -> 'Personal access token' -> 'Tokens (classic)' -> 'Generate new token (classic).

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image1d.png)

### 3. Sklonowałam repozytorium https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO za pomocą HTTPS.

Wykorzystane polecenie git wraz ze skopiowanym linkiem do repozytorium:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image2a.png)

### 4. Utworzyłam dwa klucze SSH (inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem).
- Klucz SSH typu ed25519 - klucz szyfrowany zabezpieczony hasłem:

Wykorzystane polecenie git:
```bash
ssh-keygen -t ed25519 -C "weronikaabednarz@gmail.com"
```
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image2b.png)

- Klucz SSH typu ecdsa - klucz szyfrowany algorytmem:

Wykorzystane polecenie git:
```bash
ssh-keygen -t ecdsa -b 521 -C "weronikaabednarz@gmail.com"
```

Wygenerowane klucze zapisałam w katalogu '/home/weronikaabednarz/.ssh/', a następnie dodałam do swojego konta na GitHubie kolejno: 'Settings' -> 'SSH and GPG keys'.

![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image3.png)

### 5. Skonfigurowałam klucz SSH jako metodę dostępu do GitHuba.

Wykorzystane polecenia git:

- Kopiowanie kluczy SSH:
```bash
clip < ~/.ssh/id_ed25519.pub
```
```bash
clip < ~/.ssh/id_ecdsa.pub
```
- Uruchomienie agenta SSH:
```bash
eval $(ssh-agent -s)
```
- Dodanie klucza typu ed25519 do agenta (należy podać hasło wprowadzone przy jego tworzeniu):
```bash
ssh-add ~/.ssh/id_ed25519
```
Zrzut ekranu przedstawiający powyższe kroki:

![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image4.png)

Zrzut ekranu przedstawiający utworzone klucze SSH:

![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image6.png)

### 6. Sklonowałam repozytorium wykorzystujac protokoł SSH.

Wykorzystane polecenie git:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```
![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image5.png)

### 7. Przełączyłam się na gałąź ```main```, a następnie na gałąź ```GCL1```.

Wykorzystane polecenia git (git checkout - przełączanie między gałęziami):
```bash
git checkout main

git checkout GCL1
```

### 8. Utworzyłam nową gałąź o nazwie ```WB410023``` oraz odgałęzilam się od brancha grupy.

Wykorzystane polecenia git:
- Utworzenie nowej gałęzi
```bash
git branch WB410023
```
- Odgałęzienie się od aktualnego brancha
```bash
git checkout WB410023
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image7.png)

### 9. W katalogu właściwym dla grupy utworzyłam nowy katalog o nazwie ```WB410023```.

Katalog właściwy dla grupy: /home/weronikaabednarz/Pulpit/MDO2024_INO/INO/GCL1/

Wykorzystane polecenie:
```bash
mkdir WB410023
```
![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image8.png)

### 10. Napisałam Git hook - skrypt weryfikujący, czy każdy mój "commit message" zaczyna się od ```WB410023```. Przykładowe githook'i znajdują się w folderze .git/hooks
### w repozytorium na dysku.

Wykorzystane polecenie:
```bash
nano commit-msg
```
Zrzut ekranu przedstaiwający napisany skrypt:

![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image9.png)

### 11. Następnie dodałam skrypt do utworzonego wcześniej katalogu, a potem skopiowiałam go we właściwe miejsce, tak by uruchamiał się z każdym commit'em.

Wykorzystane polecenia:
```bash
mv commit-msg .git/hooks
```
Dodanie użytkownikowi uprawnień aby plik mogł zostać uruchomiony:
```bash
chmod +x .git/hooks/commit-msg
```
![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image10.png)

### 12. Przetestowałam działanie git hook'a.

Obecna lokalizacja: /home/weronikaabednarz/Pulpit/MDO2024_INO/INO/GCL1/WB410023

Wykorzystane polecenia:
- Stworzenie pliku 'Sprawozdanie1' - plik Markdown
```bash
touch sprawozdanie_lab1.md
```
- Stworzenie folderu 'images'
```bash
mkdir images
```
![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image11.png)

- Przenoszenie nowych i zmodyfikowanych plików, z wyłączeniem plików usuniętych do obszaru roboczego (do commita) w celu zatwierdzenia
```bash
git add .
```
- Commitowanie zmian (błędny sposób wraz z wywołaniem błędu)
```bash
git commit -m "Test"
```
- Commitowanie zmian (poprawny sposób)
```bash
git commit -m "WB410023: first commit"
```
![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image12.png)

### 13. W katalogu dodałam pliki ze sprawozdaniem wraz z zrzutami ekranu (jako inline).

Wykorzystana składnia:
```bash
![teskt alternatwny](ścieżka do pliku)
```

### 14. Wysłałam zmiany do zdalnego źródła.

Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 zmiana struktury katalogow"
```
- Wysłanie zmian do źródła:
```bash
git push origin WB410023
```
![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image14.png)


### 15. Podjęłam próbę wciągnięcia swojej gałąź do gałęzi grupowej.

Wykorzystane polecenia:
- Przełączenie się na gałąź grupy
```bash
git checkout GCL1
```
- Wywołanie merge z własną gałęzią
```bash
git merge WB410023
```
![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/images/image13.png)


### 16. Dodałam zedytowane sprawozdanie oraz zrzuty ekranu.

Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 sprawozdanie"

git push origin WB410023
```

### 17. Wystawiłam Pull Request do gałęzi grupowej.


