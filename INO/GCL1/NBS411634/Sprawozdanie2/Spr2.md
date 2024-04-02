# Sprawozdanie 2
Natalia Borysowska-Ślęczka, IO

## Streszczenie projektu


## Wykonane kroki - laboratorium nr 3

### Wybór oprogramowania

1. Znajdź repozytorium z kodem dowolnego oprogramowania, które:
* dysponuje otwartą licencją

Wybranym przeze mnie oprogramowaniem jest:

```https://github.com/codeclown/tesseract.js-node.git```

Repozytorium zawiera implementację biblioteki Tesseract.js która umożliwia rozpoznawanie tekstu w obrazach przy użyciu technologii (OCR - Optical Character Recognition).

Repozytorium dysponuje otwartą licencją (Apache 2.0 - zatem możliwe jest swobodne korzystanie, modyfikowanie oraz rozpowszechnianie kodu źródłowego)

![](./ss_lab3/lab3_1.png)

* jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt make build oraz make test. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...

W wybranym repozytorium do budowania aplikacji używa się komendy:

```npm install```

 Jest ona używana w środowisku *Node.js* do instalacji zależności zdefiniowanych w pliku *package.json* projektu. 

* zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)

Testy uruchamiane są poleceniem:

```npm test```

W wybranym repozytorium umieszczone zostały w osobnym folderze *test*

2. Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności)

W nowo utworzonym folderze *lab3* klonuje wybrane przeze mnie repozytorium

![](./ss_lab3/lab3_8.png)

Następnie przechodzę do folderu *tesseract.js-node* (który utworzył się automatycznie po sklonowaniu repozytorium)

![](./ss_lab3/lab3_9.png)

i instaluje potrzebne zależności poleceniem:

```npm install```

![](./ss_lab3/lab3_10.png)

3. Uruchom testy jednostkowe dołączone do repozytorium

Po zainstalowaniu zależności przechodzimy do uruchomienia testów jednostkowych za pomocą polecenia:

```npm test```

Wszystkie testy przebiegły pomyślnie:

![](./ss_lab3/lab3_11.png)


### Przeprowadzenie buildu w kontenerze

1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego (```node``` dla Node.js)
	* uruchom kontener
	* podłącz do niego TTY celem rozpoczęcia interaktywnej pracy
	* zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)

Uruchamiam kontener poleceniem:

```docker run -it nazwa_obrazu_kontenera node bash```

gdzie:

*-i* - umożliwia interaktywne wejście do kontenera (opzwala na wprowadzanie poleceń)

*-t* - umożliwia interaktywną pracę z konsolą

*--name* - opcją *name* nadaje nazwę nowoutworzonemu kontenerowi

![](./ss_lab3/lab3_2.png)

* sklonuj repozytorium

Analogicznie jak wyżej kolnuje repoytorium poleceniem:

```git clone https://github.com/codeclown/tesseract.js-node.git```

![](./ss_lab3/lab3_3.png)

* uruchom *build*

Przechodzę do folderu sklonowanego repozytorium:

```cd tesseract.js-node```

![](./ss_lab3/lab3_4.png)

gdzie uruchamiam proces budowania:

```npm install```

![](./ss_lab3/lab3_5.png)

![](./ss_lab3/lab3_6(2).png)
* uruchom testy

Używam ```npm test``` aby uruchomić testy

![](./ss_lab3/lab3_7.png)

Wszystkie testy przeszły pomyślnie.

2. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
* Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*

Utworzyłam plik DOckerfilea, który wykonuje wszystkie powyższe kroki:

![](./ss_lab3/lab3_12.png)

Obraz buduej komendą:

```docker build -f ./builder.Dockerfile -t builder .```

![](./ss_lab3/lab3_13.png)

Wszystko przebiegło prawidłowo (otrzymałam wartość 0).
Zwrócenie wartości 0 oznacza, że proces budowania zakończył się bez problemów, wszystkie instrukcje w Dockerfilu zostały wykonane poprawnie, a obraz został pomyślnie zbudowany.

![](./ss_lab3/lab3_16.png)

* Kontener drugi ma bazować na pierwszym i wykonywać testy

Drugi plik Dockerfilea bazuje na pierwszym - wykorzystując wcześniej zbudowane już oprogramowanie:

![](./ss_lab3/lab3_14.png)

Budujemy analogicznie jak wyżej komendą:

```docker build -f ./tester.Dockerfile -t tester .```

![](./ss_lab3/lab3_15.png)

Wszystko przebiegło prawidłowo (otrzymałam wartość 0).

![](./ss_lab3/lab3_17.png)

3. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?

Uruchomiłam kontenery na podstawie wcześniej utworzonych obrazów poleceniem:

 ```docker run```

![](./ss_lab3/lab3_18.png)

a ich status i poprawność działania sprawdziłam poleceniem: 

```docker container list --all```

![](./ss_lab3/lab3_19.png)



## Wykonane kroki - laboratorium nr 4
