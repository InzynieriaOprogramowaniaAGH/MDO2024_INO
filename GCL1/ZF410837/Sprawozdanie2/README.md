# Sprawozdanie 2

> **Główne punkty sprawozdania :**
 > - budowa i testowanie wybranych aplikacji w kontenerze
 > -  tworzenie docker compose
 > -  
 > - 

W ramach zajęć przeprowadzamy operacje budowy i testowania wybranych aplikacji z wykorzystaniem różnych narzędzi (u mnie npm, meson i maven). Na tej podstawie następnie automatyzujemy cały proces poprzez stworzenie plikow Dockerfile. Brak poleceń CMD i ENTRYPOINT pozwala na efekt w którym kontenery są tworzone i natychmiastowo kończą swoje działanie, po poprawnej budowie lub teście aplikacji (kod exit 0). Dzięki temu uzyskujemy środowisko o zdefiniowanej architekturze i konfiguracji, mające niskie wymagania sprzętowe, co umozliwia łatwą automatyzacje procesu(budowanie, testowanie, wdrażanie). Kontenery służą głównie do budowania oraz testowania aplikacji, a nie do jej uruchamiania, głównie ze względów takich, że może to być mniej wydajne lub jest to słaba opcja dla aplikacji graficznych lub intearaktywnych bo kontenery głównie są przeznaczone do działania w tle lub serwerowania.



## Wybór oprogramowania na zajęcia

Wybrałam repozytoria z zajęć:
-  [https://github.com/devenes/node-js-dummy-test](https://github.com/devenes/node-js-dummy-test)  (npm)
-   [https://github.com/irssi/irssi](https://github.com/irssi/irssi)  (meson)

Oraz
- https://github.com/spring-projects/spring-petclinic (maven)

Licencja dla wszystkich umożliwia korzystanie z kodu. Środowiska umożliwiają budowanie i tetsowanie.




## Wykrzystanie maven

Aby przeprowadzić build w kontenerze zbudowanym z obrazu maven, uruchamiamy w trybie interaktywnym, pobieramy gita jeśli nie ma a nastepnie uruchamiamy skrypt mavena do budowania projektu. W przypadku Mavena ten krok obejmuje także proces pobierania zależności i kompilowania do postaci wykonywalnej. Następnie uruchamiamy skrypt do wykonywania testów.


```bash
docker run -it maven:latest /bin/bash
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw compile
./mvnw test
```

Budowa:
![](ss/1.png)

Testy:
![](ss/2.png)

### Automatyzacja powyższych operacji

![](ss/8.png)

Aby zbudować używam komendy:
```bash
	 sudo docker build -t app-bld -f BLDR.Dockerfile .
```
Tak samo robimy dla testów.

- Poprawność wykonania możemy sprawdzić poprzez: 
 
```bash
	docker run bld-app
	docker run tst-app
```
Wynik :
 
 ![](ss/6.png)

## Wykorzystanie środowiska npm

Zadanie wykonuje w wersji z Dockerfile, ponieważ wcześniejszą wykonywalismy na zajęciach.

Wersja zautomatyzowana: 

![](ss/5.png)

Wynik działania: 

![](ss/3.png)    ![](ss/4.png)




## Docker Compose
Docker Compose to narzędzie do definiowania i uruchamiania wielu kontenerów jako pojedynczej aplikacji. Pozwala ono zdefiniować konfigurację aplikacji w pliku YAML, w którym określane są kontenery, sieci, woluminy oraz inne ustawienia.

Plik napisany dla kontenerów stworzonych dla aplikacji napisanej w javie:

![](ss/11.png)


Aby uruchomić ten plik musimy pobrać rozszerzenie docker-compose, a później wykonać operację:
 ```bash
	docker-compose up
```



Plik dla środowiska node:
![](ss/10.png)


Wynik działania: 

![](ss/9.png)