# Sprawozdanie 1 
Maciej Radecki
Numer indeksu 413227
Inżynieria Obliczeniowa grupa II
# Cel projektu
Celem projektu było zapoznanie się z GitHubem, czy jest i jak działa repozytorium oraz nauka podstawowych komend do obsługi Githuba. Drugie zajęcia miały na celu pokazanie nam podstawowych komend używanych z Docker'em. 
# Wykonanie 
### 1. Instalacja klienta Git i obsługa kluczy SSH
Pierwszym krokiem było zainstalowanie Ubuntu na maszynie wirtualnej, podczas instalacji zaznaczona została opcja umożliwiająca pobranie OpenSSh automatycznie. Nastepnie zostało sprawdzone za pomocą poniższego polecenia czy instalacja przebiegła prawidłowo.
```
git --version
```
Po wpisaniu tej komendy powinna się wyświetlić aktualna wersja Gita.
![](./Screeny/1.1.1.png)
Sytuacja dotycząca zarządzania kluczami SSH jest bardzo podobna. Jeśli wcześniej zdecydowaliśmy się na instalację OpenSSH, nie powinniśmy napotkać żadnych problemów z obsługą kluczy. W końcu stanowi to element protokołu SSH.
![](./Screeny/1.1.1.png)
### 2. Klonowanie repozytorium za pomocą protokołu HTTPS i personal access token
Aby prawidłowo skopiować repozytorium za pomocą protokołu HTTPS wykorzystano poniższą komendę. 
```
git clone link_https_do_repozytorium
```
Polenie w terminalu wyglądało następująco:
![](./Screeny/1.2.1.png)
Kolejnym krokiem tego zadanie było utworzneie na swoim koncie token, który wykorzystano do osobnego sklonowania repozytorium. Token został utworzony w utawieniach a następnie w ścieżce Developer settings -> Personal access tokens -> Fine-grained tokens. 
```
git clone https://wygenerowany_token@dalsza_czesc_linku_skopiowanego_z_githuba
```
Przy pomocy powyższego polecenia wykonano klonowanie repozytorium. Poniższy screen przedstawia wykonanie tego klonowania.
![](./Screeny/1.2.2.png)
### 3. Klonowanie repozytorium za pomocą protokołu SSH
Kolejnym zadanie polegało na utworzeniu klucza SSH. W celu utworzenia go użyto nastepyjącego polcenia.
```
ssh-keygen 
```
Następnie użyto poniższego polecenia w celu wyświetlenia zawartości publicznego klucza SSH (id_rsa.pub) w terminalu lub konsoli systemu. 
```
cat ./.ssh/id_rsa.pub
```
Poniższy screen przedstawia wykonane zadanie.
![](./Screeny/1.3.1.png)
Nastepnie klucz publiczny został skopiowany i dodany do konta na Githubie
![](./Screeny/1.3.2.png)
Plik "id_rsa.pub" miał w sobie zapisany publiczny klucz SSH, co umożliwiało zmiany w repozytorium bez potrzeby autoryzacji za pomocą hasła. Zostało to wykonane za pomocą poniższego polecenia.
![](./Screeny/1.3.3.png)
### 4. Utworzenie i przełączenie się na swoją indywidualną gałąź
Moja osobista gałąź będzie miała nazwę MR410206. Przy klonowaniu repozytorium automatycznie znajdujemy się na gałęzi "main". W celu przełączenia się na inną gałąź użyłem poniższego polecenia.
```
git checkout NAZWA_GALEZI
```
Aby utworzyć nową gałąź wystarczy dodać opcje -b. Przy tworzeniu nowej gałęzi, od razu przenosimy się na nowoutworzoną gałąź. W celu wykonania zadania czyli utworzenia własnej gałęzi należało najpierw przejść na gałąź odpowiedniej grupy, a nastepnie utworzenie gałęzi <inicjały><numer_indeksu> czyli w moim wypadku: MR410206. Aby sprawdzić na jakiej gałęzi obecnie się znajdujemy można użyć poniższego polecenia.
```
git branch
```
Poniżej znajduje się screen z wykonania nowej gałęzi. 
![](./Screeny/1.4.1.png)
### 5. Utworzenie Git hook
W tym zadaniu należało utworzyć własny skrypt, który sprawdza poprawność commit message przed wykonaniem funkcji commit. W celu wykonania tego podpunktu wzorowałem się na git hook'u z folderu .git/hooks.
Na początku został utworzony plik o nazwie commit-msg we wcześniej utworzonym katalogu MR410206 oraz przekopiowano go w miejsca gdzie będzie on aktywowany na każdym poziomie, nie tylko w moim folderze. Czyli został on przekopiowany do folderu .git/hooks. Poniższy screen przedstawia opisane kroki.
![](./Screeny/1.5.1.png)
Za pomoca poniższego polecenia zostały dodane odpowiednie uprawnienia.
```
chmod +x commit-msg
```
![](./Screeny/1.5.2.png)
![](./Screeny/1.5.4.png)
Utworzony Git hook analizuje treść wiadomości wprowadzonej podczas wykonywania commita, porównując ją do wzoru składającego się z moich inicjałów i numeru legitymacji czyli MR410206. W przypadku, gdy treść wiadomości nie zgadza się z tym schematem, pojawia się komunikat o błędzie. Natomiast, jeżeli wiadomość spełnia wymagania formatu, commit jest realizowany bez problemów. Poniższy screen przedstawia efekty uruchomienia git hook'a.
![](./Screeny/1.5.3.png)
### 6. Napisanie sprawozdania
Sprawozdanie wykonano w formacie markdown, a umieszczono je w katalogu MR410206. Zrzuty ekranu będą dodawane jako zdjęcia inline. Zdjęcia tworzą się przy użyciu zapisu.
```
!["opis_zdjecia"]("sciezka_do_zdjecia")
```
Ścieżka do zdjęcia wyglądała zgodnie z poniższym wzore.
```
./ss/<nazwa zdjęcia>
```
Do przesłania sprawozdania na Github przydatne były poniższe komendy:
```
git add
```
Polecenie to służy do przenoszenia zmodyfikowanych plików do obszaru roboczego w celu zatwierdzenia. 
```
git status
```
Służy do sprawdzenia co zostało do tej pory zmodyfikowane.
```
git commit
```
Polecenie to przenosi zmiany z obszaru roboczego do lokalnego repozytorium. 
```
git push origin "nazwa_gałęzi"
```
![](./Screeny/1.6.3.png)
Ta komenda przenosi zmiany z lokalnego do zdalnego repozytorium, w ten sposób zmiany zostaną opublikowane i udostępnione. Dzięki powyższemu poleceniu można wysłać zniany  na konkretną gałąź.
