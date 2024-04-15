# Sprawozdanie 2
Maciej Radecki 410206
## Cel ćwiczenia
Celem wykonanego ćwiczenia było zapoznanie się z procesem budowy, testowania i wdrażania dowolnego oprogramowania. W tym celu użyto narzędzia Docker. Należało wybrać odpowiednie oprogramowanie i przeprowadzić budowę w kontenerze. W kolejnym etapie zadaniem było stworzenie woluminów i ich podłączenie do kontenera bazowego. Celem było zaznajomienie się z operacjami na kontenerach w Dockerze oraz z narzędziem iperf3, służącym do pomiaru przepustowości sieciowej. Ostatecznie zainstalowano Jenkinsa.
# 1. Wybranie oprogramowania 
Pierwszyk krokiem tego laboratorium było odnalezienie repozytorium na GitHubie, które spełni kilka wymagań. Mianowicie będzie posiadać otwartą licencje, jest zamieszczone wraz ze swoimi narzedziami Makefile tak aby, można było uruchomić make oraz zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Klonowanie repozytorium odbyło się przy pomicy poniższego polecenia.
```
git clone https://github.com/sanity/LastCalc.git
```
Po sklonowaniu należało przeprowadzić build programu oraz wykonać testy. W tym celu najpierw należało zainstalować odpowiednie środowisko Java przy pomocy poniższego polecenia.
```
sudo apt-get install default-jdk
```
W celu sprawdzenia poprawności instalacji użyto polecenia ```java --version```
![](../Screeny/2.2.1.1.png)
Kolejnymi krokami była instalacja Mavena oraz ponownie sprawdzenie instalacji przy pomocy ```mvn --version```
![](../Screeny/2.2.1.2.png)
Sugerując się instrukcją zawartą w repozytorium przez autora, w celu uruchomienia buildu oraz testów należalo użyć kolejno po sobie poniższych komend.
```
mvn appengine:devserver
```
```
mvn test
```
Po uruchomieniu podanych komend dostaliśmy informacje o prawidłowym zbudowaniu programu oraz uruchomieniu testów, co przedstawiają screeny poniżej.
![](../Screeny/2.2.1.3.png)
![](../Screeny/2.2.1.4.png)
Kolejnym krokiem było wykonanie buildu oraz testów w wybranym kontenerze, zdecydowano, że na potrzeby ćwiczenia zostanie to wykonane w kontenerze ubuntu. Na paczątku należąło go uruchomić w trybie interaktywnym, czyli przy pomocy poniższego polecenia.
```
sudo docker run -it ubuntu
```
![](../Screeny/2.2.1.5.png)
Następnie należąło ponownie zainstalować wcześniejsze elementy oraz dodatkowo należało dodac do nich gita. Wykonano to przy pomocy poniższego polecenia
```
apt-get install default-jdk
```
```
apt-get install maven
```
```
apt-get install git
```
Po instalacji odpowiednich narzędzi sklonowano repozytorium tym samym poleceniem co wcześniej.
```
git clone https://github.com/sanity/LastCalc.git
```
![](../Screeny/2.2.1.6.png)
A na końcu ponownie przeprowadzono budowanie oraz uruchomiono testy porównując je z wynikami poprzednich, ponownie przy pomocy poniższych komend.
```
mvn appengine:devserver
```
```
mvn test
```
![](../Screeny/2.2.1.7.png)
# 2. Tworzenie plików Dockerfile
Kolejnym zadaniem było utworzenie dwóch Dockerfile, które miały za zadanie automatyzacje wcześniej wykonanych czynności. Dockerfile jest plikiem konfiguracyjnym, który definiuje wszystkie etapy budowy obrazu kontenera, rozpoczynając od określenia jego nazwy w pierwszej linii. W kolejnych trzech liniach następuje instalacja niezbędnych narzędzi: Git, Java, a także Maven. Po zainstalowaniu wymaganych zależności, Dockerfile instruuje system, aby pobrał kod źródłowy z określonego repozytorium. Następnie, zmienia bieżący katalog na katalog repozytorium, gdzie zostaje uruchomiony proces budowy projektu.
![](../Screeny/2.2.2.1.png)
Następnie po utworzeniu powyższego Dockerfile przy pomocy polecenia ```sudo docker build .``` rozpoczęto budowę.
![](../Screeny/2.2.2.2.png)
Następnie uruchomiono go przy pomocy poniższego polecenia oraz przy pomocy odpowiednich poleceń sprawdzających wersje mavena i gita sprawdzono czy został on prawidłowo napisany.
```
sudo docker run -it [ID]
```
![](../Screeny/2.2.2.3.png)
Zmieniono też REPOSITORY przy pomocy poniższej komendy.
```
sudo docker image tag [IMAGE ID] pierwszy
```
![](../Screeny/2.2.2.4.png)
Kolejnym krokiem było utworzenie nowego Dockerfile, tak aby nowy bazował na poprzednim. Nowy Dockerfile miał być teraz odpowiedzialny za testy. Jego treść przedstawia screen poniżej.
![](../Screeny/2.2.2.5.png)
Ponownie uruchomiono jego budowę, teraz przy pomocy troszkę zmodyfikowanej komendy ze względu na nową nazwę DockerfileTest.
```
sudo docker build -f DockerfileTest .
```
![](../Screeny/2.2.2.6.png)
Ponownie zmieniono REPOSITORY oraz uruchomiono utworzony obraz sprawdzając czy wszytsko zostało poprawnie zainstalowane.
![](../Screeny/2.2.2.7.png)
![](../Screeny/2.2.2.8.png)
## Dodatkowa terminologia w konteneryzacji
# 3. Przygotowywanie woluminów
Na samym początku przygotowano woluminy wejścia i wyjścia przy pomocy poniższej komendy.
```
sudo docker volume create
```
Następnie przy pomocy kolejnego polecenia została sprawdzona ścieżka gdzie dokładnie się znajdują. Wykonujemy to by w przyszłości wiedzieć gdzie będą się znajdować pliki "in" i "out"
```
sudo docker volume inspect
```
![](../Screeny/2.2.3.1.png)
Następnie uruchomiono kontener i zainstalowano ponownie te same elementy co wceśniej, czyli java i maven. Uzyto poniższych poleceń.
```
apt install default-jdk
```
```
apt install maven
```
Kolejnym krokiem było sklonowanie repo na woluminy wejścia. Należąło przejść do miesjca gdzie znajduje się wolumin wejściowy. Za pomocą polecenia ```cd``` udało się przejść do folderu lib. W tym miejscu przy pomocy ```git clone``` został skomplikowane repozytorium. 
![](../Screeny/2.2.3.2.png)
Następnie uruchomiono kontener w którym użyto poniższego polecenia.
```
mvn appengine:devserver
```
![](../Screeny/2.2.3.3.png)
Po tej komendzie powstał nowy katalog target który został skopiowany na wolumin wyjścia.
![](../Screeny/2.2.3.4.png)
To był ostatni krok jeżeli chodzi o zadanie związane z woluminami.
# 4. Eksponowanie portu
