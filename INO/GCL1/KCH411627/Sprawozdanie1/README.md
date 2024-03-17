# Sprawozdanie 1



## Przebieg ćwiczenia
### Instalacja klienta Git i obsługa kluczy SSH

Zainstalowałem gita poleceniem:

```
sudo apt install git
```
`ssh-keygen` był u mnie domyślnie zainstalowany na maszynie.

### Sklonowanie repozytorium przedmiotowego za pomocą HTTPS

Przeszedłem do [repozytorium grupowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO), i skopiowałem jego link HTTPS

<div align="center">
    <img src="screenshots/ss_01.png" width="400"/>
</div>

<br>

i poleceniem ```git clone <url>``` sklonowałem repozytorium

<div align="center">
    <img src="screenshots/ss_02.png" width="700"/>
</div>

### Utworzenie personal access token

Klikając na githubie: `Settings > Developer settings > Personal access tokens > Tokens (classic) > Generate new token (classic) > Select scope: repo > Generate token` utworzyłem personal access token

<div align="center">
    <img src="screenshots/ss_03.png" width="700"/>
</div>




### Utworzenie kluczy SSH, dodanie ich do GitHuba i sklonowanie repozytorium

Poleceniem `ssh-keygen -t <algorithm> -C "your_email@example.com"` utworzyłem klucz ssh

*Utworzenie klucza z algorytmem ed25519 zabezpieczonego hasłem*

<div align="center">
    <img src="screenshots/ss_04.png" width="700"/>
</div>

<br>

*Utworzenie klucza z algorytmem ecdsa nie zabezpieczonego hasłem*

<div align="center">
    <img src="screenshots/ss_05.png" width="700"/>
</div>

<br>

Następnie uruchomiłem ssh-agent w tle i dodałem do niego utworzone klucze

<div align="center">
    <img src="screenshots/ss_06.png" width="700"/>
</div>

<br>

Wyświetliłem klucz z rozszerzeniem .pub poleceniem `cat` i skopiowałem go do schowka

<div align="center">
    <img src="screenshots/ss_07.png" width="700"/>
</div>

<br>

Aby skonfigurować klucz SSH jako metodę dostępu do githuba przeszedłem do `Settings > SSH and GPG keys > New SSH key` wkleiłem klucz publiczny i kliknąłem przycisk `Add SSH key`

<div align="center">
    <img src="screenshots/ss_08.png" width="700"/>
</div>

<br>

Przeszedłem do [repozytorium grupowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO), i skopiowałem jego link SSH 


<div align="center">
    <img src="screenshots/ss_09.png" width="400"/>
</div>

i poleceniem ```git clone <url>``` sklonowałem repozytorium

<div align="center">
    <img src="screenshots/ss_10.png" width="700"/>
</div>

### Utworzenie własnej gałęzi

Przełączyłem się na gałąź `main` a następnie na gałąź `GCL1` z użyciem polecenia `git checkout <branch name>`

<div align="center">
    <img src="screenshots/ss_11.png" width="700"/>
</div>

Następnie utworzyłem własną gałąź poleceniem:
```
git checkout -b KCH411627
```

### Praca na gałęzi

Utworzyłem nowy katalog poleceniem:

```
mkdir KCH411627
```

Następnie z folderu `.git/hooks` skopiowałem plik `commit-msg.sample` i zeedytowałem go tak aby weryfikował czy każdy "commit message" zaczynał się od KCH411627, do napisania skryptu użyłem pythona ponieważ jestem z nim najlepiej zaznajomiony 

```
#!/bin/python3

import sys

def main():
	with open(sys.argv[1], 'r') as file:
		lines = file.readlines()
		first_line = lines[0]
		first_word = first_line.split(" ")[0].strip('\n')
		
		if first_word != "KCH411627":
			print("Commit should start with: KCH411627")
			sys.exit(1)

	sys.exit(0)

if __name__ == "__main__":
	main()
```

Napisany skrypt skopiowałem do katalogu `.git/hooks` bez rozszerzenia .sample 

<div align="center">
    <img src="screenshots/ss_12.png" width="700"/>
</div>

<br>

*Utworzony git hook działa poprawnie*

<div align="center">
    <img src="screenshots/ss_13.png" width="700"/>
</div>

<div align="center">
    <img src="screenshots/ss_14.png" width="700"/>
</div>

<div align="center">
    <img src="screenshots/ss_15.png" width="700"/>
</div>