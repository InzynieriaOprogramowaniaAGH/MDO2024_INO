# Sprawozdanie 5

## Cel ćwiczenia

Celem ćwiczenia było zapoznanie z kubernetes czyli wdrażaniem aplikacji na zarządzalne kontenery  

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
```Dockerfile
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
docker run --rm -p 8081:80 click
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
### Wdrożenie YAML

Stworzyłem plik wdrożeniowy w formacie YAML, który tworzy 4 repliki

```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: click-deployment
  labels:
    app: click 
spec:
  replicas: 4
  selector:
    matchLabels:
      app: click 
  template:
    metadata:
      labels:
        app: click 
    spec:
      containers:
      - name: click 
        image: chlebiej/click:1.0
        ports:
        - containerPort: 80
```

Uruchomiłem go:

```
kubectl apply -f click.yaml
```

<div align="center">
    <img src="screenshots/ss_19.png" width="850"/>
</div>

<br>

Zbadałem stan:

```
kubectl rollout status deployment/click-deployment
```

<div align="center">
    <img src="screenshots/ss_20.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_21.png" width="850"/>
</div>


### Przygotowanie nowego obrazu

Stworzyłem nową wersję aplikacji (zamieniłem kolor przycisku z czerwonego na niebieski)

Zbudowałem ją:
```
docker build -f click.Dockerfile -t click .
```
<div align="center">
    <img src="screenshots/ss_22.png" width="850"/>
</div>

<br>

Uruchomiłem aplikację aby sprawdzić czy działa poprawnie

```
docker run --rm -p 8081:80 click
```

<div align="center">
    <img src="screenshots/ss_23.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_24.png" width="850"/>
</div>

<br>

Dodałem tag i wysłałem nowy obraz na docker huba

```
docker tag click chlebiej/click:1.1
docker push chlebiej/click:1.1
```

<div align="center">
    <img src="screenshots/ss_25.png" width="850"/>
</div>

<br>

Następnie zrobiłem kolejną wersje tym razem której uruchomienie kończy się błędem. Użyłem do tego polecenia `exit 1` w dockerfile'u. Zbudowałem, dodałem tag i wysłałem obraz do docker huba.

```Dockerfile
FROM nginx

COPY index2.html /usr/share/nginx/html/index.html

CMD exit 1
```

<div align="center">
    <img src="screenshots/ss_26.png" width="850"/>
</div>

<br>

```
kubectl run click --image=chlebiej/click:1.2 --port=80 --labels app="click"
```
<div align="center">
    <img src="screenshots/ss_28.png" width="850"/>
</div>

<br>

Obrazy na docker hubie:

<div align="center">
    <img src="screenshots/ss_27.png" width="850"/>
</div>

### Zmiany w deploymencie

Robiłem zmiany po przez zmianę pliku wdrożeniowego `click.yaml` a następnie je aplikowałem:

```
kubectl apply -f click.yaml 
```

<br>

Zwiększenie replik do 8

```
...
replicas: 8
...
```

<div align="center">
    <img src="screenshots/ss_29.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_30.png" width="850"/>
</div>

<br>

Zmniejszenie replik do 1

```
...
replicas: 1
...
```

<div align="center">
    <img src="screenshots/ss_31.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_32.png" width="850"/>
</div>

<br>

Zmniejszenie replik do 0
```
...
replicas: 0
...
```

<div align="center">
    <img src="screenshots/ss_33.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_34.png" width="850"/>
</div>

<br>

Zastosowanie nowej wersji obrazu

```
...
image: chlebiej/click:1.1
...
```

<div align="center">
    <img src="screenshots/ss_35.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_36.png" width="850"/>
</div>

<br>

Zastosowanie starszej wersji obrazu

```
...
image: chlebiej/click:1.0
...
```

<div align="center">
    <img src="screenshots/ss_37.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_38.png" width="850"/>
</div>

<br>

Wyświetliłem poprzednie wersje wdrożeń:

```
kubectl rollout history deployment/click-deployment
```
<div align="center">
    <img src="screenshots/ss_39.png" width="850"/>
</div>

<br>

Przywróciłem poprzednią wersje:

```
kubectl rollout undo deployment/click-deployment --to-revision=2
```

<div align="center">
    <img src="screenshots/ss_40.png" width="850"/>
</div>


### Kontrola wdrożenia

Napisałem skrypt weryfikujący, czy wdrożenie zdążyło się wdrożyć w ciągu 60 sekund

```bash
#!/bin/bash

minikube kubectl -- apply -f click.yaml;

if ! minikube kubectl -- rollout status deployment/click-deployment --timeout=60s; then
exit 1 
fi
```

Uruchomiłem go dla aplikacji w wersji 1.0

<div align="center">
    <img src="screenshots/ss_41.png" width="850"/>
</div>

<br>

Oraz dla sprawdzenia, aplikacja w wersji dla której uruchomienie kończy się błędem (1.2) 

<div align="center">
    <img src="screenshots/ss_42.png" width="850"/>
</div>

### Strategie wdrożenia

**Recreate**

Utworzyłem plik wdrożeniowy ze strategią `recreate`. Strategia ta polega na tym że najpierw zakańcza działanie podów i dopiero wtedy uruchamia nowe.

```YAML
spec:
  strategy:
    type: Recreate
```

<br>

Tutaj widać że zanim uruchomi nowe pody kończy działanie starych
<div align="center">
    <img src="screenshots/ss_43.png" width="850"/>
</div>

<br>

**Rolling Update**

Utworzyłem plik wdrożeniowy ze strategią `rollingUpdate`. Strategia ta stopniowo kończy działanie starych podów i uruchamia nowe. 

Opcje:
- `maxUnavailable` - maksymalna liczba podów która może być nie dostępna podczas aktualizacji
- `maxSurge` - maksymalna liczba podów która może być utworzona ponad wybraną liczbę podów

```YAML
strategy:
    type: RollingUpdate 
    rollingUpdate:
        maxUnavailable: 2
        maxSurge: 30%
```

<div align="center">
    <img src="screenshots/ss_44.png" width="850"/>
</div>

<br>

**Canary Deployment workload**

Utworzyłem plik wdrożeniowy ze strategią `canary`. Strategia ta pozwala dodać poda z aplikacją z nowszą wersją do podów ze starszą wersją. Pozwala to na testowanie jak rodzi sobie nowa wersja nie wymieniając całej aplikacji od razu na nowszą wersje.

```YAML
labels:
    app: click
    track: canary
```

<div align="center">
    <img src="screenshots/ss_45.png" width="850"/>
</div>