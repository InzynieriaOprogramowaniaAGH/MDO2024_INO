
# Sprawozdanie 1

## Konfiguracja systemu

Wykorzystany został system operacyjny Linux, dystrybucja OpenSuse Leap. Do utworzenia maszyny wirtualnej wykorzystany został VirtualBox.

## Instalacja Git

W celu rozpoczęcia pracy nad projektem wymagany program kontrol wersji Git.
Aby zainstalować Gita należy posłużyć się komendą:

```console
foo@bar:~ sudo zypper install git
```

Aby zainstalować nowe oprogramowanie na serwerze wymagane są uprawnienia administratora (root'a). Musimy więc wykorzystać polecenie sudo (superuser do) aby je otrzymać.

Do instalacji wykorzystujemy menedżer pakietów **zypper**. Zypper umożliwia instalowanie, usuwanie oraz zarządzanie pakietami oprogramowania w systemach opartych na RPM(Red Hat Package Manager).

Jeżeli instalacja git przebiegła pomyślnie przy wpisaniu komendy
```console
foo@bar:~ git
```

Powinna pokazać się następująca wiadomość

-- git_1_foto --

## Utworzenie kluczy SSH
Aby móc sklonować repozytorium przedmiotowe oraz rozpocząc na nim pracę wymagane jest utworzenie pary kluczy SSH, które wykorzystywane są przez Git do bezpiecznej komunikacji z serwerem. Aby wygenerować klucze SSH wykorzystamy pakiet OpenSSH. OpenSSH składa się z klienta SSH, który umożliwia zdalne logowanie jak i serwer ssh nasłuchujący na porcie 22 oraz inne narzędzia.

Utworzymy dwie pary kluczy, jedną zabezpieczoną hasłem oraz drugą bez tego zabezpieczenia. Zamiast RSA wykorzystany zostanie algorytm szyfrowania ED25519, ponieważ utworzone za pomocą niego klucze charakteryzują się lepszymi zabezpieczeniami oraz wydajnością.

### Para kluczy bez hasła

Polecenie
```console
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Utworzy parę kluczy wykorzystując podany adres email jako etykietę.

-- zdjecie generate bez hasla --

Po wpisaniu powyższej komendy podmieniając etykietę na nasz email powinny zostać utworzone dwa nowe pliki w podanym przez nas folderze. Komendą **ls** wylistujmy pliki w aktualnym folderze, aby zweryfikować że klucze zostały utworzone.

-- zdjecie ls --

Utworzone zostały dwa klucze prywatny oraz publiczny. Nazwa klucza publicznego zakończona jest wyrazem **.pub**. Utworzony klucz publiczny należy skopiować oraz dodać do listy naszych kluczy na Github. Klucz prywatny należy dodać do agenta ssh poleceniem

```console
ssh-add ~/.ssh/id_ed25519
```

Nazwę id_ed25519 należy podmienić na odpowiednią nazwę utworzonego wcześniej klucza prywatnego.

### Para kluczy zabezpieczona hasłem

Utworzymy parę kluczy wykorzystując inny algorytm oraz dodatkowo zabezpieczymy je hasłem.

Ponownie wykorzystujemy polecenie ssh-keygen
```console
ssh-keygen -t ecdsa -C "another_email@example.com"
```

Tym razem przy pytaniu o hasło (secure phrase) należy wpisać hasło którym chcemy dodatkowo zabezpieczyć utworzone klucze.

Po wygenerowaniu klucz nasz folder z kluczami powinien wyglądać następująco

--zdjecie foldera--

## Klonowanie repozytorium

Mając do dyspozycji utworzone wczesniej klucze SSH możemy sklonować repozytorium Github. Repozytorium możemy sklonować poprzez HTTPS oraz SSH. Zaletą HTTPS jest fakt, że nie trzeba tworzyć kluczy kryptograficznych, jednak przy każdej komunikacji z repozytorium będziemy poproszeni o logowanie. Dodatkowo klucze SSH charakteryzują się lepszym bezpieczeństwem między innymi poprzez autentykację dwuskładnikową.

Aby sklonować repozytorium należy wejść na strone repozytorium, następnie nacisnąć przycisk **Code** oraz wybrać opcję SSH.

-- zdjecie z Github --

Komenda **git clone** umożliwi nam sklonowanie repozytorium. Przed sklonowaniem warto upewnić się, że znajdujemy się w odpowiednim folderze, ponieważ git umieści repozytorium w aktualnym folderze w którym się znajdujemy.

```console
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git
```

Po wpisaniu komendy powinniśmy zobaczyć

-- zdjecie --

Oznacza to, że repozytorium zostało prawidłowo sklonowane.
### Utworzenie nowej gałęzi


Git umożliwia tworzenie gałęzi (branchy) czyli oddzielonych od siebie serii commitów (w zasadzie mają one wspólnego przodka). Gałęzie pozwalają na kolaborację, równoległy rozwój oprogramowania oraz wersjonowanie. Git umożliwia przełączanie się pomiędzy gałęziami, tworzenie nowych gałęzi, scalanie oraz łączenie historii gałęzi (rebase).

Aby utworzyć nową gałąź musimy posłużyć się poleceniem

```console
git branch <branch_name>
```
Aby przełączyć się na inną gałąź wykorzystamy polecenie

```console
git checkout <branch_name>
```
Polecenie git status wyświetli nam informację o aktualnej gałęzi

```console
git status
```
Przeniesiemy się na odpowiednią gałąź oraz utworzymy nową gałąź o nazwie inicjały + nr indeksu

Wypisanie aktualnej gałęzi oraz jej zmiana

-- zdjecie --

Następnie poleceniami
```console
git branch JL407285
git checkout JL407285
```

Tworzymy nową gałąź oraz na nią przechodzimy. Tworzenie gałęzi nie zawiera zdjęcia z uwagi na to, że gałąź o tej nazwie już istnieje.

Na koniec poleceniem git status zweryfikujmy, że znajdujemy się na dobrej gałęzi

-- zdjecie --

### Utworzenie Git Hooka
Pracę na nowej gałęzi rozpoczniemy od stworzenia git hooka

Git hooks to skrypty wykonywane automatycznie w odpowiedzi na określone wydarzenia w operacjach gitowych, takich jak commit, push, merge. Działają one lokalnie na komputerze użytkownika, na którym znajduje się repozytorium gitowe. 

Utworzymy nowego git hook'a, którego zadaniem będzie weryfikacja, że commit mesage rozpoczyna się od inicjałów + nr indexu (w moim przypadku JL407285).