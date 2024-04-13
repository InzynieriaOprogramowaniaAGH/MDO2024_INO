# Sprawozdanie 2

## Cel ćwiczenia

## Przebieg ćwiczenia - zajęcia 3

### Znalezienie repozytorium

Znalazłem repozytorium [maven-demo](https://github.com/davidmoten/maven-demo), które dysponuje otwartą licencją (Apache-2.0 license), zawiera narzędzie do budowania (maven) oraz posiada testy.

<div align="center">
    <img src="screenshots/ss_01.png" width="850"/>
</div>

### Sklonowanie i uruchomienie

Sklonowałem repozytorium poleceniem:

```
git clone https://github.com/davidmoten/maven-demo.git
```

Następnie zainstalowałem maven'a:

<div align="center">
    <img src="screenshots/ss_02.png" width="850"/>
</div>

<br>

Zbudowałem program poleceniem:

```
mvn clean install
```

<div align="center">
    <img src="screenshots/ss_03.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_05.png" width="850"/>
</div>

<br>

Uruchomiłem testy:

```
mvn test
```

<div align="center">
    <img src="screenshots/ss_04.png" width="850"/>
</div>

### Przeprowadzenie buildu w kontenerze

Uruchomiłem obraz ubuntu w trybie interaktywnym, zaktualizowałem pakiety, pobrałem gita oraz maven'a:

```
apt update
apt upgrade
apt install git
apt intall maven 
```

<div align="center">
    <img src="screenshots/ss_06.png" width="850"/>
</div>

<br>

Pobrałem repozytorium:

<div align="center">
    <img src="screenshots/ss_07.png" width="850"/>
</div>

<br>


Zbudowałem program:

<div align="center">
    <img src="screenshots/ss_08.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_09.png" width="850"/>
</div>

<br>

Uruchomiłem testy:

<div align="center">
    <img src="screenshots/ss_10.png" width="850"/>
</div>

### Stworzenie Dockerfile

Stworzylem Dockerfile który przeprowadza wszystkie kroki aż do builda:

```
FROM ubuntu

RUN apt update && \
    apt upgrade -y && \
    apt install -y git && \
    apt install -y maven

RUN git clone https://github.com/davidmoten/maven-demo.git
WORKDIR /maven-demo
RUN mvn clean install
```

Następnie go zbudowałem:
```
docker build -f BLDR.Dockerfile -t bldr .
```

<div align="center">
    <img src="screenshots/ss_11.png" width="850"/>
</div>


<div align="center">
    <img src="screenshots/ss_12.png" width="850"/>
</div>

<br>

Utworzyłem drugi dockerfile który bazuje na pierwszym i wykonuje testy

```
FROM bldr 

WORKDIR /maven-demo
RUN mvn test
```

<br>

I go zbudowałem:

<div align="center">
    <img src="screenshots/ss_13.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_14.png" width="850"/>
</div>

<br>

*zbudowane obrazy*

<div align="center">
    <img src="screenshots/ss_15.png" width="850"/>
</div>

<br>

Uruchomienie kontenerów

<div align="center">
    <img src="screenshots/ss_17.png" width="850"/>
</div>

<br>

Oba kontenery uruchamiają się poprawnie i kończą swoją pracę (exited 0)

<div align="center">
    <img src="screenshots/ss_16.png" width="850"/>
</div>