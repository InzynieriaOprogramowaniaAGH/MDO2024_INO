# Sprawozdanie 2

> **Główne punkty sprawozdania :**
 > - budowa i testowanie wybranych aplikacji w kontenerze
 > -  tworzenie docker compose
 > -  korzystanie z wolumenów
 > -  iperf3
 > -  jenkins

W ramach zajęć przeprowadzamy operacje budowy i testowania wybranych aplikacji z wykorzystaniem różnych narzędzi (u mnie npm, meson i maven). Na tej podstawie następnie zautomatyzujemy cały proces poprzez stworzenie plikow Dockerfile. Poprzez nieumieszczanie poleceń CMD i ENTRYPOINT w plikach Dockerfile, kontenery są tworzone i kończą swoje działanie natychmiast po poprawnej budowie lub teście aplikacji (kod exit 0). Dzięki temu uzyskujemy środowisko o zdefiniowanej architekturze i konfiguracji, które wymaga niewielkich zasobów sprzętowych, co ułatwia automatyzację procesu (budowanie, testowanie, wdrażanie). Kontenery służą głównie do budowy i testowania aplikacji, a nie do ich uruchamiania. Jest to szczególnie istotne ze względu na to, że uruchamianie aplikacji graficznych lub interaktywnych w kontenerach może być mniej wydajne lub niepraktyczne, ponieważ kontenery są przede wszystkim przeznaczone do pracy w tle lub do serwowania usług.



## Wybór oprogramowania na zajęcia

Wybrałam repozytoria z zajęć:
-  [https://github.com/devenes/node-js-dummy-test](https://github.com/devenes/node-js-dummy-test)  (npm)
-   [https://github.com/irssi/irssi](https://github.com/irssi/irssi)  (meson)

Oraz
- https://github.com/spring-projects/spring-petclinic (maven)

Licencja dla wszystkich umożliwia korzystanie z kodu. Środowiska umożliwiają budowanie i testowanie.




## Wykorzystanie narzędzia Maven

Aby zbudować projekt w kontenerze maven, wykonujemy następujące kroki: Uruchamiamy kontener w trybie interaktywnym, instalujemy git, jeśli nie jest już zainstalowany w kontenerze, wykonujemy skrypt mavena do budowy projektu, a następnie uruchamiamy skrypt do wykonania testów aplikacji.


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

Zadanie wykonuje w wersji z Dockerfile, ponieważ wcześniejszą wykonywaliśmy na zajęciach.

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

