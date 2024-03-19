# Sprawozdanie 1 - Konrad Rezler
## Zajęcia 01
## Wprowadzenie, Git, Gałęzie, SSH
### Instalacja środowiska
W moim przypadku wybór padł na narzędzie `Virtual Box`, z którym wcześniej podczas studiowania miałem do czynienia. Zainstalowany system operacyjny to obsługiwany wariant dystrybucji `Ubuntu`, który został wskazany przed prowadzącego. Wspomnianemu systemowi zostały przydzielone:
- 4GB pamięci RAM
- 25GB miejsca na dysku

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/VirtualBox.png">
</p>

### Zainstaluj klienta Git i obsługę kluczy SSH
Korzystając z następującego polecenia:
```
sudo apt install git
```
pobrałem klienta Git, który umożliwia zdalne klonowanie repozytoriów. Jednakże przed przystąpieniem do tego należy utworzyć `Personal access token`, który można pozyskać na platformie GitHub przechodząc do następujących zakładek: Settings > Developer settings > Personal access tokens > Tokens (classic). 

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie1/Personal Access Token.png">
</p>

Mając już utworzony token mogłem sklonować repozytorium przedmiotu wykorzystując następującą komendę:
```
git clone https://krezler21:<utworzony_token>@github.com/<ścieżka-repozytorium>
```



