# Sprawozdanie 5
Dagmara Pasek
411875

### Cel ćwiczenia:
Celem tych zajęć było zainstalowanie i uruchomienie klastra Kubernetes za pomocą Minikube oraz kubectl, zapewniając jednocześnie bezpieczeństwo instalacji i zgodność z wymaganiami sprzętowymi. Należało przygotować i wdrożyć własny obraz Docker, uruchamiając aplikację jako kontener na Minikube oraz sprawdzając poprawność działania przez Dashboard i kubectl. Finalnie zapisano wdrożenie w pliku YML i przeprowadzono próbne wdrożenie przykładowego deploymentu. 

### Przebieg ćwiczenia 010:
# Instalacja klastra Kubernetes:
Minikube jest narzędziem, które umożliwia uruchamianie lokalnych klastrów Kubernetes na różnych systemach operacyjnych. 
Zaopatrzyłam się w implementację stosu k8s: minikube zgodnie z załączoną instrukcją znajdującą się w opisie zadania. Instalację wykonałam dla Fedory 38 w architekturze ARM64. Użyłam więc poniższych poleceń:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64
```


Kolejno użyłam polecenia:

```
minikube kubectl -- get po -A
```
aby pobrać kubectl. Jest on narzędziem wiersza poleceń do zarządzania klastrami Kubernetes, umożliwiającym tworzenie, aktualizowanie, usuwanie i monitorowanie zasobów takich jak pody, deploymenty i usługi

![](./screeny/5_kubectl.png)

Użyłam polecenia:
```
minikube start
```
aby uruchomić klaster minikube.

Zapewniłam bezpieczeństwo instalacji poprzez aktualizacje oprogramowania oraz pobieranie narzędzi z oficjalnych źródeł. 

Miałam problem z uruchomieniem Minikube, ponieważ automatycznie łączył się z QEMU zamiast z Dockerem. Aby to rozwiązać, musiałam ręcznie skonfigurować Minikube, dodając parametr --driver=docker podczas uruchamiania, co pozwoliło na poprawne działanie klastra. Dzięki tej konfiguracji udało się uruchomić Minikube bez dalszych problemów.

![](./screeny/5minikubel.png)

Aby zainstalować Minikube, potrzebny były co najmniej 2 procesory, 2 GB wolnej pamięci oraz 20 GB wolnego miejsca na dysku. Mogły zatem występować problemy z brakiem pamięci podczas instalacji albo z błędnie przydzieloną liczbą procesorów. Na szczęście moja maszyna spełniała powyższe wymagania. Przydzieliłam jej 2 procesory oraz 4 GB wolnej pamięci.

Sprawdziłam czy poprawnie został utworzony kontener stosując polecenie:
```
docker ps
```
![](./screeny/5ps.png)

Status klastra sprawdziłam stosując:
```
minikube status
```

![](./screeny/5status.png)

Kolejno uruchomiłam Dashboard stosując polecenie:
```
minikube dashboard
```
Wywołałam je w terminalu wewnątrz maszyny, przez co od razu wyświetlało się okno w przeglądarce. 

![](./screeny/5dash.png)

Po otwarciu Dashboard,  możliwe było zobaczenie wizualizacji statusu klastra Kubernetes, w tym informacji o podach, deploymentach, usługach i innych zasobach klastra.

# Analiza posiadanego kontenera:
Poprzedni projekt - Irssi nie nadawał się do pracy jako kontener, ponieważ jego charakterystyka nie pozwalała na ciągłą pracę. Zmieniłem projekt na serwer Nginx, co umożliwiło lepsze dostosowanie go do kontenera, który może działać w tle. Dodatkowo, wzbogaciłem funkcjonalność serwera Nginx poprzez dodanie własnej strony powitalnej, wyświetlającej wiadomość "Hello from NGINX", oraz podpisanie serwera własnymi danymi.
Utworzyłam więc osobny katalog o nazwie custom-nginx i zawarłam w nim Dockerfile oraz prosty plik html. 

```
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to NGINX</title>
</head>
<body>
    <h1>Hello from NGINX!</h1>
    <p>Created by Dagmara Pasek</p>
</body>
</html>
```

Dockerfile wyglądał tak:

```
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html
```
Dockerfile definiował bazowy obraz, na którym został zbudowany nowy obraz. Kopiował również plik index.html z lokalnego systemu plików do katalogu /usr/share/nginx/html w kontenerze. 

Zbudowałam obraz stosując:
```
docker build -t custom-nginx .
```

![](./screeny/5b.png)
