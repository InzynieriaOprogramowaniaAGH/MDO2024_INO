# Sprawozdanie 5 - Konrad Rezler
## Zajęcia 10
## Wdrażanie na zarządzalne kontenery: Kubernetes (1)
### Instalacja klastra Kubernetes

Kubernetes to otwartoźródłowy system orkiestracji kontenerów. Umożliwia automatyzację wdrażania, skalowania i zarządzania aplikacjami kontenerowymi w klastrze serwerów. Kubernetes zarządza cyklem życia kontenerów, obsługuje balansowanie obciążenia, automatyczne przydzielanie zasobów, oraz monitorowanie stanu aplikacji. Dzięki temu umożliwia tworzenie skalowalnych, odporne na awarie i łatwo zarządzalnych środowisk produkcyjnych, co znacznie upraszcza operacje DevOpsowe.

Za pomocą następującej komendy zainstalowałem implementację stosu k8s (minikube)::
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/1.1%20Zaopatrz%20si%C4%99%20w%20implementacj%C4%99%20stosu%20k8s%20minikube.png">
</p>

Przy pomocy polecenia `minikube start` uruchomiłem instalację, konfigurację oraz kontener minikube:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/1.2 Zaopatrz się w implementację stosu k8s minikube.png">
</p>

Zainstalowałem `kubectl`, a na koniec uruchomiłem dashboard komendą `minikube dashboard`. Tak uruchomiony dashboard zostawiłem w dotychczasowym terminalu i na potrzeby dalszej pracy uruchomiłem kolejny terminal:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/2. intalacja kubectl.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/2.1 intalacja kubectl.png">
</p>

Uruchamiając link zamieszczony na końcu wydruku wywołanego uruchomieniem `minikube dashboard`, uzyskujemy dostęp do dashboarda:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.1.1 pusty dashboard.png">
</p>

### Instalacja klastra Kubernetes
Utworzyłem pod i przekierowałem port aplikacji, co miało swoje odzwierciedlenie w dashboardzie
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3. utworzenie poda i przekierowanie portu.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.2 widok z dashboarda.png">
</p>

Dodatkowo w zakładce `PORTS` obecnej w Visual Studio Code dodatkowo przekierowałem port `3000` na `localhost:3001`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.1 przekierowalem port.png">
</p>

Pozwoliło mi to ostatecznie otworzyć stronę w przeglądarce mojego komputera:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/4. otworzenie strony po przekierowaniu portow.png">
</p>

## Zajęcia 11
## Wdrażanie na zarządzalne kontenery: Kubernetes (2)
### Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML

Na potrzeby zajęć utworzyłem folder `files`, w którym zamieściłem wszystkie pliki utworzone w ramach zajęć, między innymi plik `deployment.yaml`, który okaże się niezbędny do rozpoczęcia wdrożenia i zbadania stanu aplikacji 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/1. utworzenie folderu i pliku.png">
</p>

Wspomniany plik `deployment.yaml` ma następującą treść i pozwala na posiadanie 5 replik:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-hot-cold
  labels:
    app: react

spec:
  replicas: 5
  selector:
    matchLabels:
      app: react
  template:
    metadata:
      labels:
        app: react
    spec:
      containers:
      - name: react
        image: krezler21/react-hot-cold:0.2.0
        ports:
        - containerPort: 3000
```

Następnie uruchomiłem dashboard i przełączyłem się do innego terminala, aby dashboard pozostał włączony:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/3. wystartowalem minikube'a.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/4. w drugim terminalu uruchomilem dashboard.png">
</p>

Powyższe działania pozwoliły mi na rozpoczęcie wdrożenia przy pomocy `kubectl apply` oraz zbadanie stanu za pomocą `kubectl rollout status`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/5. Rozpocznij wdrożenie za pomocą kubectl apply.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/6. Zbadaj stan za pomocą kubectl rollout status.png">
</p>

Co oczywiście znalazło swoje odzwierciedlenie w wyświetlanej zawartości dashboard:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/7.2 dashboard po wdrożeniu za pomocą kubectl apply.png">
</p>

Postanowiłem przetestować uruchomienie aplikacji, dlatego przekierowałem port i wszedłem na `localhost:3001`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/7. przekierowalem port.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/7.1 przekierowalem port.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/8. uruchomilem aplikacje.png">
</p>

### Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML

W Docker Hubie umieściłem dwie nowe wersje swojego obrazu, przy czym wersja 'error' podczas uruchomienia kończy się problemem:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/9.  Przygotowanie nowego obrazu.png">
</p>

### Zmiany w deploymencie

Wykorzystując komendę `kubectl apply -f deployment.yaml deployment.apps/react-hot-cold configured` oraz zmieniając ilość replik/wersję obrazu w pliku `deployment.yaml` przetestowałem kilka następujących przypadków:
- zwiększenie replik do 8 (Warto zauważyć, że posiadając wcześniej 5 replik, zostały dołożone 3 repliki, a nie na przykład usunięte pozostałe repliki i utworzone nowych 8 replik):
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/11. widok z dashboard, dolozono nowe repliki tak aby sumarycznie bylo 8, a nie po prostu dodano 8 .png">
</p>

- zmniejszenie liczby replik do 1:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/13. widok z dashboard.png">
</p>

- zmniejszenie liczby replik do 0:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/15. widok z dashboard.png">
</p>

- Zastosowanie nowej wersji obrazu:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/17. widok z dashboard.png">
</p>


- Zastosowanie starszej wersji obrazu:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/19. widok z dashboard.png">
</p>

Przywróciłem poprzednią wersję wdrożeń następującymi komendami:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/20. Przywracaj poprzednie wersje wdrożeń za pomocą poleceń kubectl rollout history.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/21. Przywracaj poprzednie wersje wdrożeń za pomocą poleceń kubectl rollout undo.png">
</p>

Co wywołało następujący efekt:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/22. widok z dashboard.png">
</p>

### Kontrola wdrożenia

Utworzyłem nowy plik i nadałem mu odpowiednie uprawnienia.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/23. utworzyłem plik i nadałem mu uprawnienia.png">
</p>

Następnie przygotowałem skrypt, aby weryfikował, czy wdrożenie zostało wykonane w ciągu 60 sekund:
```
#!/bin/bash

DEPLOYMENT_NAME="react-hot-cold"

kubectl apply -f deployment.yaml

end_time=$((SECONDS + 60))

while [ $SECONDS -lt $end_time ]; do
    status=$(kubectl rollout status deployment/$DEPLOYMENT_NAME)
    if [[ $status == *"successfully rolled out"* ]]; then
        echo "Aplikacja została wdrożona w ciągu 60 sekund."
        exit 0
    fi
    
    sleep 5
done

echo "Aplikacja nie została wdrożona w ciągu 60 sekund."
exit 1
```

Usuwając wcześniej obecne pody w dashboardzie, uruchomiłem skrypt, aby sprawdzić, czy test zakończy się sukcesem:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/24. uruchomienie skryptu (dodaj zawartosc skryptu).png">
</p>
Jak widać test zakończył się sukcesem.

### Kontrola wdrożenia

Podczas tego etapu zajęć zajmowałem się wdrażaniem następujących strategii wdrożeń:
- `Recreate` - Wstrzymuje działanie aplikacji i wymienia wszystkie pody jednocześnie, co prowadzi do przerwy w działaniu. Jest łatwy do wdrożenia i nie powoduje problemów z kompatybilnością, ale aplikacja jest niedostępna podczas aktualizacji.
- `RollingUpdate` - Wymienia pody stopniowo, zapewniając ciągłą dostępność aplikacji. Minimalizuje przestoje i utrzymuje dostępność, ale może prowadzić do problemów z synchronizacją danych i wymaga zgodności między starymi i nowymi wersjami.
- `Canary` - Nowa wersja aplikacji jest wdrażana tylko dla części użytkowników. Pozwala na testowanie nowej wersji w ograniczonym zakresie przed pełnym wdrożeniem, co umożliwia wczesne wykrywanie problemów, ale wymaga dodatkowej konfiguracji i zarządzania ruchem użytkowników. 

#### Strategia Recreate
Utworzyłem nowy plik `recreate.yaml`, który uruchomiłem komendą `kubectl apply -f recreate.yaml` w którym zamieściłem następującą treść:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/25. utworzylem nowy plik do reacreate.png">
</p>

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-hot-cold
  labels:
    app: react
spec:
  replicas: 15
  strategy:
    type : Recreate
  selector:
    matchLabels:
      app: react
  template:
    metadata:
      labels:
        app: react
    spec:
      containers:
      - name: react
        image: krezler21/react-hot-cold:0.2.0
        ports:
        - containerPort: 3000
```

Co pozwoliło uzyskać następujący efekt:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/26. Przygotuj wersje wdrożeń stosujące następujące strategie wdrożeń reacreate.png">
</p>

#### Strategia RollingUpdate
Utworzyłem nowy plik `rolling-update.yaml`, który uruchomiłem komendą `kubectl apply -f rolling-update.yaml` w którym zamieściłem następującą treść:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/27. utworzylem nowy plik do rolling update.png">
</p>

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-hot-cold
  labels:
    app: react
spec:
  replicas: 15
  strategy:
    type : RollingUpdate
    rollingUpdate:
      maxUnavailable: 8
      maxSurge: 30%
  selector:
    matchLabels:
      app: react
  template:
    metadata:
      labels:
        app: react
    spec:
      containers:
      - name: react
        image: krezler21/react-hot-cold:0.3.0
        ports:
        - containerPort: 3000
```

Co pozwoliło uzyskać następujący efekt:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/29. po udpateowaniu tylko pewien procent jednoczesnie sie usuwa dzieki parametrom, drugi parametr tez cos robi.png">
</p>

#### Strategia Canary
W celu realizacji tej strategii utworzyłem 5 plików oraz pobrałem usługę istio:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/30. utworzyłem 5 plikow.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/31. pobrałem usługę istio .png">
</p>

Pliki uzupełniłem w następujący sposób:
- canary.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-hot-cold-canary
spec:
  replicas: 5
  selector:
    matchLabels:
      app: react
      version: canary
  template:
    metadata:
      labels:
        app: react
        version: canary
    spec:
      containers:
      - name: react
        image: krezler21/react-hot-cold:0.3.0
```

- destination.yaml
```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: react
spec:
  host: react
  subsets:
  - name: stable
    labels:
      version: stable
  - name: canary
    labels:
      version: canary
```

- istio-service.yaml
```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: react
spec:
  hosts:
  - "localhost"
  http:
  - match:
    - headers:
        x-canary:
          exact: "true"
    route:
    - destination:
        host: react
        subset: canary
      weight: 100
  - route:
    - destination:
        host: react
        subset: stable
      weight: 90
    - destination:
        host: react
        subset: canary
      weight: 10
```

- service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: react
spec:
  type: NodePort
  selector:
    app: react
  ports:
    - nodePort: 32137
      protocol: TCP
      port: 3000
      targetPort: 3000
```

- stable.yaml 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-hot-cold
spec:
  replicas: 15
  selector:
    matchLabels:
      app: react
      version: stable
  template:
    metadata:
      labels:
        app: react
        version: stable
    spec:
      containers:
      - name: react
        image: krezler21/react-hot-cold:0.2.0
```

oraz uruchomiłem powyższe pliki:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/32. uruchomilem 5 plikow.png">
</p>

Co pozwoliło uzyskać następujący efekt. Jak widać, 15 podów zostało uruchomionych w wersji starszej, a 5 w nowszej wersji:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/32.1 widok z dashboarda.png">
</p>

Następnie uruchomiłem service oraz przekierowałem jego port.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/33. odpaliłem service.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/34. przekierowalem port.png">
</p>

Dodatkowo pobrałem wtyczkę w Google Chrome `ModHeader`, która pozwoliła mi na odróżnienie jednej wersji programu od drugiej
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/35. pobrałem wtyczke modheader, aby moc odroznic wersje aplikacji.png">
</p>

Ostatecznie uruchomiłem aplikację w przeglądarce:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie11-png/36. Po uzyciu mod headera wersja canary rozni sie niebieskim paskiem u gory.png">
</p>