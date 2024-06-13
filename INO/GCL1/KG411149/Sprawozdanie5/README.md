# Sprawozdanie 5
Krystian Gliwa, IO.

## Cel projektu
Celem projektu jest wdrożenie aplikacji opartej na kontenerach na platformie Kubernetes przy użyciu narzędzia Minikube. Projekt obejmuje instalację klastra Kubernetes, uruchomienie kontenerów z wykorzystaniem różnych strategii wdrożenia oraz zarządzanie nimi za pomocą YAML.

## Wdrażanie na zarządzalne kontenery: Kubernetes

### Instalacja klastra Kubernetes

#### Zaopatrzenie się w implementację stosu k8s: minikube oraz instalacja

Na początku zajęć przeszedłem do instalacji zgodnie z zamieszczoną na tej stronie instrukcją https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fdebian+package, pobrałem najnowszą wersje pakietu Minikube dla systemów opartych na architekturze AMD64 (czyli x86_64) w formacie **.deb**, który jest typowy dla dystrybucji Linux opartych na Debianie, takich jak Ubuntu, poleceniem:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
```
oraz rozpocząłem instalacje poleceniem:
```
sudo dpkg -i minikube_latest_amd64.deb
```
![instalacja minikube](./zrzuty_ekranu/1.jpg)

#### Zaopatrzenie się w polecenie **kubectl** w wariancie minikube
**kubectl** - jest to narzędzie wiersza poleceń do interakcji z klastrem Kubernetes, najpierw utworzyłem alias *kubectl*, który zawsze uruchamia *minikube kubectl --* zamiast bezpośredniego *kubectl* poleceniem:
```
alias kubectl="minikube kubectl --"
```
A następnie wykorzystując to uruchomiłem polecenie które służy do pobrania i wyswietlenia listy wszystkich podów we wszystkich przestrzeniach nazw w klastrze Kubernetes uruchomionym przez Minikube:
```
kubectl get po -A
```
![kubectl get po -A](./zrzuty_ekranu/3.jpg)

#### Uruchomienie Kubernetesa

Aby pokazać działający kontener (uruchomić Kubernetesa) użyłem polecenia: 
```
minikube start
```
![uruchomienie kubernetesa](./zrzuty_ekranu/2.jpg)

![dzialajacy kontener](./zrzuty_ekranu/5.jpg)

#### Wymagania sprzętowe

Podczas konfigurowania Minikube istnieją określone wymagania sprzętowe, które należy spełnić, aby zapewnić płynne działanie: 
- 2 CPU lub więcej
- 2 GB wolnej pamięci RAM
- 20 GB wolnego miejsca na dysku
- Połączenie z internetem
-Menadżer kontenerów lub maszyn wirtualnych, taki jak **Docker**, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox lub VMware Fusion/Workstation
Każde kryterium zostało spełnione przez moją maszynę, więc nie były konieczne teraz żadne modyfikacjie.

#### Uruchomienie Dashboard

Dashboard to graficzny interfejs użytkownika (GUI) dla klastra Kubernetes, który uruchamia się w przeglądarce - dzięki wykorzystaniu Visual Studio Code który automatycznie przekierował porty.  Do otworzenia użyłem polecenia:
```
minikube dashboard
```
![dashboard polecenie](./zrzuty_ekranu/4.jpg)

![dashboard ()](./zrzuty_ekranu/6.jpg)

Dzięki wykorzystaniu Dashboarda moge szybko przeglądać i zarządzać podami, deploymentami i jobami, wykonując takie akcje jak przeglądanie logów, skalowanie, aktualizacje i usuwanie zasobów.

### Analiza posiadanego kontenera

Z racji tego że moja wcześniej wybrana aplikacja uruchomiona w kontenerze kończyła swoją pracę odrazu, do tego zadania musiałem wybrać inną. Wybrałem **nginx** którego na swojej maszynie zainstalowałem poleceniem:
```
sudo apt update
sudo apt install nginx
```
Sprawdzenie czy **nginx** działa poprawnie:

![systemctl status nginx](./zrzuty_ekranu/7.jpg)

Następnie po skopiowaniu do katalogu roboczego pliku **/usr/share/nginx/html/index.html** dodałęm do niego odpowiedni fragment kodu który odpowiada za wyświetlenie aktualnej godziny na domyślnej stronie wyświetlanej przez serwer Nginx: 
```
<script>
    function updateTime() {
        var now = new Date();
        var timeString = now.toLocaleTimeString();
        document.getElementById('current-time').textContent = "Current time: " + timeString;
    }

    updateTime();
    setInterval(updateTime, 1000);
</script>
```
Cały plik **index.html**:

![index.html](./zrzuty_ekranu/8.jpg)

Oraz utworzyłem nowy plik **Dockerfile**:
```
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```
Który bazuje na oficjalnym obrazie **nginx** z Docker Hub i kopiuje lokalny plik *index.html* (który znajduje się w tym samym katalogu co Dockerfile) do obrazu Docker w miejsce */usr/share/nginx/html/index.html.* 

Następnie utworzyłem obraz Docker na podstawie tego pliku Dockerfile poleceniem:
```
docker build -f Dockerfile -t clock-nginx .
```
Potwierdzenie zbudowania obrazu: 

![obraz clock-nginx](./zrzuty_ekranu/9.jpg)

Następnie sprawdziłem czy zbudowany obraz działa poprawnie, uruchomiłem kontener poleceniem: 
```
docker run -d -p 8080:80 --name nginx-clock-container nginx-clock
```
Oraz w przeglądarce wpisałem **http://localhost:8080/** aby sprawdzić czy wyświetlany jest zegar - czy kontener uruchamia się i pracuje. Wszystko działa jak powinno:

![działanie clock-nginx](./zrzuty_ekranu/10.jpg)

Działający obraz trzeba było opublikować w DockerHub. Zalogowałem się poleceniem:
```
docker login
```
Przypisałem nowy tag do obrazu Docker **nginx-clock** poleceniem:
```
docker tag nginx-clock krystian3243/nginx-clock:1.0
```
Oraz opublikowałem go poleceniem: 
```
docker push krystian3243/nginx-clock:1.0
```
![docker push clock](./zrzuty_ekranu/11.jpg)

Teraz mój obraz znajduje się juz na DockerHub: 

![docker: nginx-clock](./zrzuty_ekranu/12.jpg)

Następnie spawdziłem czy mogę teraz wykorzystać ten obraz z mojego Dockera do utworzenia działającego kontenera, poleceniem (wcześniej musiałem zatrzymać uruchomiony lokalnie kontener):
```
docker run -d --rm -p 8080:80 --name nginx-clock krystian3243/nginx-clock:1.0
```
![działanie kontenera wykorzystujacego obraz z dockera](./zrzuty_ekranu/13.jpg)

Ponownie wpisałem w przeglądarce adres **http://localhost:8080/** Oto rezutlat: 

![działanie kontenera wykorzystujacego obraz z dockera w przeglądarce](./zrzuty_ekranu/14.jpg)

Aplikacja **nginx** z moją modyfikacją wyświetlającą godzine działa poprawnie.

### Uruchamianie oprogramowania

Uruchomiłem kontener na stosie k8s poleceniem:
```
minikube kubectl run -- nginx-clock --image=krystian3243/nginx-clock:1.0 --port=80 --labels app=nginx-clock
```
Co uruchomiło kontener w minikube który został automatycznie ubrany w pod:

![kontener w minikube który został automatycznie ubrany w pod](./zrzuty_ekranu/15.jpg)

Widać to wyżej w uruchomionym dashboardzie, ale spawdziłem tez to za pomocą **kubectl** poleceniem:
```
minikube kubectl -- get pods
```
![uruchomione pody (via kubectl)](./zrzuty_ekranu/16.jpg)

Następnym krokiem było wyprowadzenie portu celem dotarcia do eksponowanej funkcjonalności, poleceniem:
```
kubectl port-forward pod/clock-nginx 8080:80
```

Następnie sprawdziłem działanie wpisując w przeglądarce adres **lockalhost:8080** jednak tym razem strona nie wczytała się - "Ta witryna jest nieosiągalna". Musiałem przekierować port w Visal Studio Code:

![przekierowanie portu w VScode](./zrzuty_ekranu/17.jpg)

Oraz ponownie spróbowałem uruchomić aplikacje w przeglądarce, teraz juz adres to **lockalhost:8081**:

![localhost:8081](./zrzuty_ekranu/18.jpg)

![wyprowadzanie portow](./zrzuty_ekranu/19.jpg)

Output zmienił się po przekierowaniu portu: wypisały się linie: "Handling..."

### Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML

Na początku utworzyłem plik **nginx-clock-deployment.yaml** który definiuje jak aplikacja powinna być wdrożona, wzorując się przykładem z strony *kubernetes.io*:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-clock-deployment
  labels:
    app: nginx-clock
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx-clock
  template:
    metadata:
      labels:
        app: nginx-clock
    spec:
      containers:
      - name: nginx-clock
        image: krystian3243/nginx-clock:1.0
        ports:
        - containerPort: 80
```
Taki plik wzbogaca mój obraz o 4 replik. Następnie rozpocząłem wdrożenie poleceniem:
```
minikube kubectl -- apply -f nginx-clock-deployment.yaml
```
A następnie sprawdziłem jego stan poleceniem:
```
minikube kubectl rollout status deployments/nginx-clock
```
![rollout status](./zrzuty_ekranu/20.jpg)

Sprawdzenie działania w dashboardzie:

![dashboard- sprawdzenie deploments](./zrzuty_ekranu/21.jpg)

### Przygotowanie nowego obrazu

Nową wersje obrazu utworzyłem dopisanie nazwy tej wersji w tytule w wcześniej utworzonym plik **index.html**  A następnie zbudowałem obraz korzystając z istniejącego juz Dockerfila poleceniem:
```
docker build -f Dockerfile -t nginx-clock .
```
Potem otagowałem nowy obraz poleceniem:
```
docker tag nginx-clock krystian3243/nginx-clock:1.1
```
I opublikowałem go w DockerHub poleceniem:
```
docker push krystian3243/nginx-clock:1.1
```
Potwierdzenie wykonania w DockeHub: 

![dodanie wersji 1.1](./zrzuty_ekranu/22.jpg)

Następnym krokiem było utworzenie wersji której uruchomienie kończy się błędem. Użyłem do tego polecenia:
```
CMD ["false"]
```
Które dodałem na końcu Dockerfila, a w pliku **index.html** zmieniłem numer wersji na 1.2. Cały Dockerfile:
```
FROM nginx
COPY ./index.html /usr/share/nginx/html/index.html
CMD ["false"]
```
Następnie tak jak przy tworzeniu wersji 1.1, zbudowałem obraz, otagowałem go i opublikowałem w DockerHub: 

![dodanie wersji 1.2](./zrzuty_ekranu/23.jpg)

Sprawdzam działanie w kubernetesie: 

![(nie)działanie wersji 1.2](./zrzuty_ekranu/24.jpg)

### Zmiany w deploymencie

Kolejnym krokiem było zaktualizowanie pliku YAML z wdrożeniem i przeprowadzenie go ponownie dla nowych przypadków. Na początku zwiększyłem liczbę replik do 8: 
```
spec:
  replicas: 8
```
Następnie rozpocząłem wdrożenie poleceniem:
```
minikube kubectl -- apply -f nginx-clock-deployment.yaml
```
I po tym do monitorowania zmian użyłem polecenia:
```
minikube kubectl rollout status deployments/nginx-clock-deployment
```
![rollout z 8 replik](./zrzuty_ekranu/26.jpg)


I po tym sprawdziłem jak to wygląda w Dashboardzie:

![zmiany deploymencie: 8 replik](./zrzuty_ekranu/25.jpg)

Następnie zmieniłem liczbę replik do 1 po czym, powtórzyłem powyzsze kroki: 

![rollout 1 replika](./zrzuty_ekranu/27.jpg)

Dashboard:

![zmiany deploymencie: 1 replika](./zrzuty_ekranu/28.jpg)

Następnie zminiejszyłem liczbę replik do 0, oraz powtórzyłem kroki jak wcześniej: 
Dashboard:

![zmiany deploymencie: 0 replika](./zrzuty_ekranu/29.jpg)

Kolejnym krokiem było zastosowanie nowej wersji obrazu, aby to wykonać w pliku YAML zmieniłem wersję z **nginx-clock:1.0** na **nginx-clock:1.1** oraz ustawiłem liczbę replik na 4.

![zmiany deploymencie: nowa wersja](./zrzuty_ekranu/31.jpg)

Dashboard:
![Dashoboard: zmiany deploymencie: nowa wersja](./zrzuty_ekranu/30.jpg)

Widać że stare repliki są aktualizowane.

Następnie zmieniłem w pliku YAML wersje na starszą z 1.1 na 1.0, a oto co otrzymałem: 

![zmiany deploymencie: na starą wersje](./zrzuty_ekranu/32.jpg)

![dashboard: zmiany deploymencie: na starą wersje](./zrzuty_ekranu/33.jpg)

Następnie sprawdziłem liste zmian deploymentu poleceniem:
```
minikube kubectl rollout history deployment/nginx-clock-deployment
```
![history deployment](./zrzuty_ekranu/34.jpg)

Teraz na podstawie kolumny REVISION możemy wybrać wersje aplikacji do której chcemy wrócić, a robimy to poleceniem:
```
minikube kubectl rollout undo deployment/nginx-clock-deployment --to-revision=10
```
Lub poprostu gdy chcemy cofnąć się do poprzedniej wersji (tutaj-1.1) , użyjemy polecenia:
```
minikube kubectl rollout undo deployment/nginx-clock-deployment
```
![rollout undo deployment](./zrzuty_ekranu/35.jpg)

![dashboard: rollout undo deployment](./zrzuty_ekranu/36.jpg)

### Kontrola wdrożenia 

Kolejnym krokiem było napisanie skryptu weryfikującego, czy wdrożenie "zdążyło" się wdrożyć w 60 sekund. Treść: 
```
#!/bin/bash

DEPLOYMENT_NAME="nginx-clock-deployment"
TIMEOUT=60

minikube kubectl -- apply -f ./nginx-clock-deployment.yaml

minikube kubectl get deployments 

if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s > /dev/null 2>&1; then
echo "Wdrożenie wykonało się w czasie poniżej 60 sekund."
exit 0
else
echo "Wdrożenie nie wykonało się w czasie poniżej 60 sekund."
exit 1
fi
```
Skrypt ten automatyzuje wdrażanie aplikacji w Kubernetesie przy użyciu minikube. Po zastosowaniu konfiguracji z pliku clock-deployment.yaml, sprawdza status wdrażania i w zależności od wyniku, informuje, czy wdrożenie zakończyło się pomyślnie w określonym czasie, czy nie.
Następnie dodałem uprawnienia do wykonywania dla tego pliku poleceniem:
```
chmod +x skrypt.sh
```
oraz uruchomiłem go dla wersji 1.1: 

![skrypt 1.1](./zrzuty_ekranu/37.jpg)

Aby sprawdzić czy poprawnie działa uruchomiłem go również dla wersji 1.2 czyli wersja która zwraca błąd: 

![skrypt 1.2](./zrzuty_ekranu/38.jpg)

Po czym cofnąłem go do poprzedniej, działającej wersji korzystając z polecenia **rollout undo**:

![cofnięcie do 1.1](./zrzuty_ekranu/39.jpg)

### Strategie wdrożenia

Kolejnym krokiem było utworzenie trzech wersji wdrożeń stosując następujące strategie wdrożeń:
- Recreate
- Rolling Update (z parametrami maxUnavailable > 1, maxSurge > 20%)
- Canary Deployment workloadt

#### Recreate
Pierwsza z nich - recreate polegała na usunięciu wszystkich starych replik przed uruchomieniem nowych. Oznacza to, że podczas wdrożenia nie ma jednoczesnego działania starych i nowych wersji aplikacji. Aby ją zastosować utworzyłem nowy plik **recreate.yaml** o treści: 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-clock-deployment
  labels:
    app: nginx-clock
    version: 1.0
spec:
  replicas: 4
  strategy: 
    type: Recreate
  selector:
    matchLabels:
      app: nginx-clock
  template:
    metadata:
      labels:
        app: nginx-clock
    spec:
      containers:
      - name: nginx-clock
        image: krystian3243/nginx-clock:1.1
        ports:
        - containerPort: 80
```
Typ strategii *Recreate* został określony w *spec*.

Następnie rozpoczynam wdrożenie poleceniem:
```
minikube kubectl -- apply -f recreate.yaml
```
Oraz monitoruje je poleceniem:
```
minikube kubectl rollout status deployments/nginx-clock-deployment-recreate
```
![recreate](./zrzuty_ekranu/40.jpg)

#### Rolling Update
Strategia ta polega na stopniowym zastępowaniu starych replik nowymi. Aby ją zastosować utworzyłem nowy plik **rolling.yaml** o treści: 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-clock-deployment-rolling
  labels:
    app: nginx-clock
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
  selector:
    matchLabels:
      app: nginx-clock
  template:
    metadata:
      labels:
        app: nginx-clock
    spec:
      containers:
      - name: nginx-clock
        image: krystian3243/nginx-clock:1.0
        ports:
        - containerPort: 80
```
Dla tej strategi przyjąłem parametry: *maxUnavailable: 2*(określa maksymalną liczbę replik, które mogą być niedostępne (niedziałające) w trakcie aktualizacji) i *maxSurge: 30%*(określa maksymalną liczbę nowych replik, które mogą zostać utworzone powyżej liczby określonej w specyfikacji replicas w trakcie aktualizacji). Następnie rozpoczynam wdrożenie poleceniem:
```
minikube kubectl -- apply -f rolling.yaml
```
Oraz monitoruje je poleceniem:
```
minikube kubectl rollout status deployments/nginx-clock-deployment-rolling
```
![rolling](./zrzuty_ekranu/41.jpg)

#### Canary Deployment workloadt
Strategia ta polega na wdrożeniu nowej wersji aplikacji tylko na kilku replikach, aby przetestować jej działanie. Jeśli nowa wersja działa poprawnie, stopniowo zwiększa się jej udział w całkowitym ruchu. Aby ją zrealizowąc utworzyłem nowy plik **canary.yaml** do którego dodałem etykiety "track: canary" aby umożliwić Deployment oraz Podom włączenie do Canary Deployment, zmieniłem też liczbę replik na 1. Cały plik: 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-clock-deployment-canary
  labels:
    app: nginx-clock
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-clock
      track: canary
  template:
    metadata:
      labels:
        app: nginx-clock
        track: canary
    spec:
      containers:
      - name: nginx-clock
        image: krystian3243/nginx-clock:1.1
        ports:
        - containerPort: 80
```
Rozpoczynam wdrożenie poleceniem:
```
minikube kubectl -- apply -f canary.yaml
```
Oraz monitoruje je poleceniem:
```
minikube kubectl rollout status deployments/nginx-clock-deployment-canary
```
![canary](./zrzuty_ekranu/42.jpg)

Wszystkie pody:
![wszystkie pody](./zrzuty_ekranu/43.jpg)

Podsumowanie:
- Recreate: Całkowita zamiana wszystkich starych replik nowymi jednocześnie.
- Rolling Update: Stopniowa aktualizacja replik, gdzie stare są zastępowane nowymi na bieżąco.
- Canary Deployment:  Wprowadzenie nowej wersji aplikacji na niewielkiej liczbie replik do testowania przed pełnym wdrożeniem.

Ostatnim krokiem było użycie serwisów - w Kubernetes jest to metoda udostępniania aplikacji sieciowej działającej jako jeden lub więcej Podów w klastrze. Utworzyłem nowy plik **service.yaml** o następującej treści: 
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-clock-service
spec:
  selector:
    app: nginx-clock
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Następnie wykonałem go poleceniem:
```
minikube kubectl -- apply -f service.yaml
```
Oraz przekierowałem port poleceniem:
```
minikube kubectl port-forward service/nginx-clock-service 3000:80
```
Oraz dodałem port 3000 w VScode:

![przekierowanie portu w VSCode](./zrzuty_ekranu/44.jpg)

Po czym w przeglądarce wpisałem adres **localhost:3000** aby sprawdzić czy zadziałało to poprawnie:

![działa: localhost:3000](./zrzuty_ekranu/45.jpg)

![port-forward output](./zrzuty_ekranu/46.jpg)
