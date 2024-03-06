# Sprawozdanie 1
## Marcin Pigoń
## ITE gr. 4

### Cel: Zapoznanie się z podstawowymi działaniami w Git oraz podstawową konteneryzacją korzystając z Dockera.

### Lab 1

#### 0. Przygotowanie maszyny wirtualnej
Pobrałem program VirtualBox, gdyż już korzystałem z tego środowiska i nie mam dostępu do wirtualizatora Hyper-V, ponieważ mam jedynie wersję Windows Home. 
Dystrybucją Linuxa, którą wybrałem była Fedora, ponieważ jest znana i jest wiele materiałów na internecie.  

#### 1. Zainstaluj klienta Git i obsługę kluczy SSH

Korzystając z polecenia install, pobrałem klienta Git, który umożliwia działanie Gita na mojej maszynie wirtualnej. Należało użyć również przy tym poleceniu *sudo*, ponieważ jest to operacja, która pozwala wykonać polecenie z uprawnieniami administratora.
![sudo dnf install git](0.installgit.png)
Do obsługi kluczy SSH zainstalowano w analogiczny sposób *openssh*.

#### 2. Sklonuj repozytorium przedmiotowe za pomocą HTTPS i personal access token

Po wygenerowaniu **personal access token** https://github.com/settings/tokens, mogłem go wykorzystać przy poleceniu **git clone** i sklonować repozytorium przedmiotowe, do którego będę później przesyłać swoje pliki.

![git clone repo](1.gitclone.png)
Strona GitHub przypomina o traktowaniu swoich personal access token jak haseł i nie udostępniania ich. 

#### 3. Utworzenie kluczy SSH i połączenie ich do GitHub~

Za pomocą polecenia ssh-keygen generujemy pary kluczy (prywatny + publiczny).
Opcja **-t** odpowiada za typ klucza - w moim przypadku były to klucze ed25529 oraz rsa.
Opcja **-f** odpowiada za nazwę pliku.

![ssh-keygen](image.png)

Druga para kluczy była wygenerowana z użyciem wyłącznie polecenia ssh-keygen, co oznaczało, że nazywały się domyślnie *id_rsa* dla klucza prywatnego, a *id_rsa.pub* dla klucza publicznego. 

Zawartość klucza publicznego
![pub key](image-1.png)
Klucz publiczny pozwala połączyć się z maszyną w bezpieczny sposób. 
Klucz prywatny nigdy nie powinien być udostępniany.

Wstawiono ten klucz publiczny w GitHub w zakładce **SSH and GPG keys**
![github ssh](image-2.png)

Sklonowano repozytorium, teraz przy wykorzystaniu połączenia SSH:
**git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git**

Również tutaj połączyłem się do swojej maszyny wirtualnej przez środowisko Visual Studio Code i Extension *Remote Explorer - SSH*. Umożliwia to bardziej intuicyjny dostęp do maszyny i pozwala na dodaniu innych pakietów, które pozwalają na bardziej efektywną pracę - np. podświetlanie składni skryptów Bash. Jest to znacznie wygodniejsze w użyciu niż *nano*. Również w łatwy sposób można kopiować oraz wklejać do maszyny wirtualnej. To rozwiązanie również pozwala na otwieranie kilku terminali jednocześnie. 

#### 4. Przełącz się na gałąź main, a potem na gałąź swojej grupy 

Do przełączania się pomiędzy gałęziami stosujemy polecenie **git checkout**. 
 

Korzystając z polecenia git branch możemy zobaczyć jakie gałęzie istnieją.
![alt text](image-3.png)



