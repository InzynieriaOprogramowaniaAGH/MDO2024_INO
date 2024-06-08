# Sprawozdanie 5

## Cel ćwiczenia
## Przebieg ćwiczenia - zajęcia 10 

### Instalacja minikube 

Aby pobrać i zainstalować `minikube` użyłem dwóch poleceń:

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```

<div align="center">
    <img src="screenshots/ss_01.png" width="850"/>
</div>

<br>

Zaopatrzyłem się w polecenie `kubectl` tworząc alias:

```
alias kubectl="minikube kubectl --"
```

### Uruchomienie kubernetes

Uruchomiłem kubernetesa za pomocą polecenia:

```
minikube start
```

<div align="center">
    <img src="screenshots/ss_02.png" width="850"/>
</div>

<br>

Działający kontener kubernetes

<div align="center">
    <img src="screenshots/ss_07.png" width="850"/>
</div>

<br>

Wyświetliłem wszystkie pody

```
kubectl get po -A
```

<div align="center">
    <img src="screenshots/ss_03.png" width="850"/>
</div>

<br>

Uruchomiłem dashboard. Visual studio code automatycznie przekierowuje porty więc nie musiałem się o to martwić

```
minikube dashboard
```

<div align="center">
    <img src="screenshots/ss_04.png" width="850"/>
</div>

Po kliknięciu w link uruchamia się strona z dashboardem

<div align="center">
    <img src="screenshots/ss_05.png" width="850"/>
</div>

### Analiza posiadanego kontenera

Przez to ze wybrana przeze mnie aplikacja na poprzednich zajęciach nie nadaje się do pracy w kontenerze, wymieniłem ją na obraz nginx z wykonaną przeze stroną startową.

Stworzyłem nowego dockerfile:
```
FROM nginx

COPY index.html /usr/share/nginx/html/index.html
```

Zbudowałem obraz:
```
docker build -f click.Dockerfile -t click .
```
<div align="center">
    <img src="screenshots/ss_06.png" width="850"/>
</div>

<br>

uruchomiłem aplikacje udostępniając port 8081 (oraz przekierowałem port w visual studio code)
```
docker run --rm -p 80:8081 click
```

<div align="center">
    <img src="screenshots/ss_08.png" width="850"/>
</div>

<br>

Aplikacja pracuje jako kontener

<div align="center">
    <img src="screenshots/ss_10.png" width="850"/>
</div>

<br>

Stworzona przeze mnie aplikacja wyświetla liczbę kliknięć czerwonego przycisku przez użytkownika :)

<div align="center">
    <img src="screenshots/ss_09.png" width="850"/>
</div>

### Uruchamianie oprogramowania na stosie k8s

Próbowałem uruchomić poda

```
kubectl run click --image=click --port=80 --labels app="click"
```

Ale wystąpił błąd. Zrozumiałem że k8s nie wykrywa obrazów lokalnych więc muszę mój zbudowany obraz przesłać do docker huba.

<div align="center">
    <img src="screenshots/ss_11.png" width="850"/>
</div>

### Docker hub

Zalogowałem się do docker huba
```
docker login
```

<div align="center">
    <img src="screenshots/ss_12.png" width="850"/>
</div>

<br>

Dodałem tag z wersją do obrazu i przesłałem obraz do docker huba

```
docker tag click chlebiej/click:1.0
docker push chlebiej/click:1.0
```

<div align="center">
    <img src="screenshots/ss_13.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_14.png" width="850"/>
</div>

### Uruchamianie oprogramowania na stosie k8s v2

Uruchomiłem poda

```
kubectl run click --image=chlebiej/click:1.0 --port=80 --labels app="click"
```
 
<div align="center">
    <img src="screenshots/ss_16.png" width="850"/>
</div>

Tym razem pod uruchomił się poprawnie i działa

<div align="center">
    <img src="screenshots/ss_15.png" width="850"/>
</div>

<br>

Wyprowadziłem port 8082 (oraz przekierowałem port 8082 w visual studio code)

<div align="center">
    <img src="screenshots/ss_17.png" width="850"/>
</div>

Udało się połączyć

<div align="center">
    <img src="screenshots/ss_18.png" width="850"/>
</div>

## Przebieg ćwiczenia - zajęcia 11 