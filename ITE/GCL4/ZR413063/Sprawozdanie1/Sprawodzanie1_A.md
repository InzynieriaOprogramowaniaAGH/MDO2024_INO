# Sprawozdanie 1 - Poprawa

# 1. 1. Klonowanie repozytorium

By móc sklonować repozytorium musiałam najpierw pobrać gita na maszynę wirtualną. Będąc w katalogu domowym zainstalowałam go przy użyciu komendy:
```
 sudo apt install git
```
 By upewnić się, że git został pobrany sprawdziłam jego wersję: 
```
git --version
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/5b243392-77cd-440e-b923-70d02cd6e472)



Po wykonaniu tych czynności nie mogłam jednak przejść od razu do klonowania repozytorium. Musiałam ustanowić połączenie ssh między maszyną wirtualną a githubem. Do realizacji tego z katalogu domowego przeszłam do katalogu .ssh: 
```
cd .ssh 
```

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e4b7c583-b48c-4091-95ac-69e13ef4c106)

Który jest domyślnym katalogiem by przechowywać takie informacje jak prywatne i publiczne klucze autoryzacyjne. Klucze SSH potwierdzają dostęp do protokołu sieciowego SSH (secure shell), który zaszyfrowany i uwierzytelniony wykorzystywany jest do zdalnej komunikacji między komputerami w otwartej i niezabezpieczonej sieci.
Do przeprowadzenia uwierzytelnienia stosuje się parę kluczy – prywatny i publiczny. Klucz publiczny jest tym, który zostaje udostępniony zdalnym podmiotom by móc zaszyfrować dane. Można go porównać do zamka, który zamyka dane. By móc uzyskać dostęp do tych danych, czyli otworzyć zamek, stosuje się klucz prywatny. Tak jak klucze od domu, należy na niego bardzo uważać gdyż jest to niezwykle poufna rzecz i powinna być pilnie strzeżona. W momencie wycieku nawet fragmentu klucza prywatnego należy usunąć parę kluczy, wygenerować nową i ustanowić nowe połączenie ze świeżo wygenerowanymi kluczami.
Plik z kluczem prywatnym powinien być przechowywany w odpowiednim i bezpiecznym miejscu. W systemach Linuxowych kropka przed nazwą katalogu oznacza, że jest on ukryty i służy zazwyczaj do przechowywania ustawień użytkownika czy ustawień systemowych. 
Katalog .ssh jest więc katalogiem domyślnie chronionym przez system, mają do niego dostęp tylko właściciel i root. Jest też ukryty i nie pojawia się w spisie po użyciu zwykłej komendy ls. To wszystko sprawia, że jest odpowiednim miejscem na przechowywanie kluczy SSH.

Po upewnieniu się, że znajduję się w katalogu .ssh, wygenerowałam klucze autoryzacyjne: 
```
ssh-keygen 
``` 

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/0151caff-0785-4b00-a28d-ba257145c1ba)



W tym momencie wygenerowałam parę kluczy: prywatny i publiczny. Zostały zapisane w domyślnych plikach.

Następnie pobrałam klucz publiczny, który pozwoli mi ustanowić połączenie SSH z githubem. Klucz znajdował się w pliku id_rsa.pub i wypisałam go na terminal do skopiowania komendą: 
```
cat id_rsa.pub
```
Po skopiowaniu klucza przeszłam na stronę githuba, zalogowałam się na swoje konto i przeszłam do ustawień. Przeszłam do zakładki SSH and GPG keys i kliknęłam "new SSH key". Dodałam swój klucz.

By sprawdzić ustanowione połączenie w mojej maszynie wirtualnej użyłam komendy: 
```
ssh git@github.com 
```
Wyświetliła mi się informacja powitalna z moim nickiem githubowym i wiadomością, że zostałam pomyślnie zidentyfikowana.


![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/b41430c4-1f03-4ac3-8fef-c79b9798be47)



Teraz mogłam przystąpić do sklonowania repozytorium. Przeszłam do odpowiedniego katalogu, do którego chciałam sklonować repozytorium i użyłam polecenia: 
```
git clone <link ssh do repozytorium>
```
