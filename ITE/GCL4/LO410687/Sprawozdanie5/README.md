# Sprawozdanie 5
## Łukasz Oprych 410687 Informatyka Techniczna

## Lab 10-11

Celem danego ćwiczenia było wykorzystanie `Kubernetesa` we wdrażaniu kontenerów zarządzalnych.

### Instalacja kubernetesa

W tym celu zaopatrujemy się w implementację stosu k8s `minikube`.
Instalacja  została wykonana na podstawie dokumentacji [minikube](https://minikube.sigs.k8s.io/docs/start/). 

Wymagania sprzętowe w celu prawidłowego działania to: dwurdzeniowy CPU, 2GB RAM oraz 20GB wolnej pamięci dyskowej.

Instalację wykonujemy na dystrybucji Fedora w architekturze x86-64, z typem instalatora RPM package.

Pobieramy paczkę przy użyciu `curl'a`:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
```
Instalujemy:
```bash
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

Następnie uruchamiamy poleceniem:
```bash
minikube start
```

Efekt wykonanych poleceń:

![1](./ss/1.png)

Następnie uruchamiamy dashboard, który w sposób graficzny pozwala na zarządzanie kontenerami oraz pozostałymi zasobami. 
```bash
minikube dashboard
```

Dashboard uruchomił się pod widocznym adresem.

![](./ss/dashboard.png)


Z powodu ustawień przeglądarki, należało skopiować link i dostać się do dashboardu w przeglądarce. Port 46131 został automatycznie przekierowany przy użyciu `vsc`, więc bez problemu można było się dostać.

![](./ss/port.png)

Dashboard prezentuje się następująco: 

![](./ss/dashboardweb.png)

Dashboard pozwala nam m.in. zarządzać Podami kubernetesowymi w zakładce Pods

#### Pod
`Pod` jest najmniejszą jednostką w Kubernetes, którą można utworzyć, wdrożyć i zarządzać.
Każdy pod zawiera jeden lub więcej kontenerów, które są uruchamiane wspólnie na tym samym hoście i współdzielą zasoby takie jak sieć i system plików.
Pody mają własne IP, dzięki czemu aplikacje działające w różnych podach mogą się komunikować bezpośrednio, 

#### Deployment
`Deployment` zarządza replikami podów i zapewnia, że określona liczba podów jest zawsze uruchomiona.

W przypadku przerwania prac nad kontenerami w Kubernetes, aby nie doszło do zaburzenia prac w przyszłości zatrzymać `minikube` poleceniem:

```bash
minikube stop
```

Poniższym poleceniem sprawdzamy czy działa kontener kubernetesowy.
```bash
docker ps
```

Jak widać kontener minikube działa:

![](./ss/kontener.png)


Następnie w celu sprawnego zarządzania zasobami, zainstalowano `kubectl`.

Pobieramy poleceniem:
```bash
kubectl get po -A
```

### Analiza posiadanego kontenera

Aplikacją użytą do opracowania ćwiczenia będzie bazująca na obrazie **nginx** z własną konfiguracją. Będzie to prosta gra do zgadywania wylosowanej liczby. Jest to aplikacja webowa, która działa nieprzerwanie po uruchomieniu kontenera.

Następnie musimy przygotować obraz naszej aplikacji przy użyciu
Dockerfile do zbudowania aplikacji.
Prezentuje się on następująco:
```Dockerfile
FROM nginx:1.26

COPY ./index.html /usr/share/nginx/html/index.html
```

Wybrano wersję 1.26, ponieważ jest to aktualnie najnowszą wersją **stable** i posiada wystarczającą konfigurację na wykonanie ćwiczenia. Następnie kopiowana jest nasza własna konfiguracja, którą utworzono w pliku `index.html`

![](./ss/nginx.png)

Następnie obraz znajdujący się w katalogu **deploy** repozytorium zajęciowego ze sprawozdaniem, buduję poleceniem:

```bash
docker build -t guess-the-number -f Dockerfile .
```

![](./ss/build.png)

Aplikacja nie posiada napisanych testów, lecz można ją przetestować ręcznie, uruchamiając kontener i  sprawdzając czy liczba się losuje i zwracany jest wynik naszej próby odgadnięcia.

Uruchomienie kontenera (przykładowo na porcie 8000):
```bash
docker run -d --rm -p 8000:8000 --name guess-the-number guess-the-number
```

Potwierdzamy czy kontener działa nieprzerwanie poleceniem:
```bash
docker ps
```

![](./ss/kontenerlok.png)

Test aplikacji:

![](./ss/test.png)

Następnie obraz zamieszczam na platformie **Dockerhub**.

![](./ss/image.png)

Loguję się z poziomu terminala poniższym poleceniem i podaję dane logowania:

```bash
docker login
```

Następnie taguję obraz, który będziemy pushować:
```bash
docker tag guess-the-number lukoprych/guess-the-number:1.0.0
```
Na koniec dokonujemy push obrazu:

```bash
docker push lukoprych/guess-the-number:1.0.0
```
![](./ss/push.png)

Jak widać poprawnie zamieszczono obraz na **Dockerhub**

![](./ss/dockerhub.png)

Następnie spróbujemy uruchomić kontener, ściągając obraz **Dockerhub**.

```bash
docker run -d --rm -p 80:80 --name guess-the-number lukoprych/guess-the-number:1.0.0
```

Jak widać kontener działa i nie zamyka się:

![](./ss/kontenergra.png)

### Uruchomienie oprogramowania

Tę część ćwiczenie rozpoczynamy od uruchomienia kontenera na stosie **k8s**


Przed uruchomieniem kontenera sprawdzamy poleceniem, czy port na, którym chcemy uruchomić kontener jest wolny, w tym przypadku wybrano 80.

```bash
sudo netstat -tuln | grep :80 
```

Jeżeli nie wyświetli się nic przypisanego do portu 80, to znaczy, że port jest wolny

Jak widać port jest wolny, uzyskujemy jedynie informację o zajętym porcie 8080

![](./ss/grep.png)

Następnie uruchmiamy kontener poleceniem, które wykorzystuje nasz obraz z **Dockerhub** oraz port 80:
```bash
minikube kubectl run -- guess-the-number --image=lukoprych/guess-the-number:1.0.0 --port=80 --labels app=guess-the-number
```

W celu ułatwienia korzystania z `kubectl` w środowisku **Minikube**, tworzymy alias `kubectl`, który przekierowuje wszystkie polecenia kubectl na pełne polecenie `minikube kubectl`. Dzięki temu, możemy używać standardowych poleceń `kubectl` do zarządzania lokalnym klastrem **Kubernetes** uruchomionym za pomocą **Minikube**

```bash
alias kubectl="minikube kubectl --"
``` 

Wystawiamy aplikację na zewnątrz klastra przy pomocy serwisu, który przekierowuje ruch do kontenera, umożliwiając dostęp do aplikacji z zewnątrz. Jest to przydatne, gdy chcemy udostępnić aplikację publicznie, na przykład do testów lub udostępnienia usługi klientom.

```bash
kubectl expose pod guess-the-number --port=80 --target-port=80 --name=guess-the-number
```
 
Jak widać nasz kontener uruchomiony w minikube został ubrany w pod.

via **dashboard**:

![](./ss/pod.png)

via **kubectl**:

Używamy polecenia:
```bash 
kubectl get all
```

![](./ss/getpod.png)


Aby uzyskać dostęp do eksponowanej aplikacji, użyjemy polecenia `kubectl port-forward` do przekierowania ruchu sieciowego z portu 3000 na naszym lokalnym komputerze do portu 80 wewnątrz kontenera o nazwie **guess-the-number**. Po przekierowaniu, możemy otworzyć przeglądarkę internetową i przejść pod adres `http://127.0.0.1:3000`, aby uzyskać dostęp do aplikacji.

Polecenie:
```bash
kubectl port-forward guess-the-number 3000:80
```

![](./ss/forward.png)

Należy też ręcznie przekierować port w `vsc`
![](./ss/port2.png)

Jak widać aplikacja działa na porcie 3000

![](./ss/afterforward.png)


## Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML


### Kontrola Wdrożenia

Następnym krokiem było napisanie skryptu weryfikującego czy wdrożenie wykonało się w 60 sekund.

**script.sh**
```bash
#!/bin/bash

DEPLOYMENT_NAME="game-deploy"
NAMESPACE="default" 
TIMEOUT=60
INTERVAL=5

end=$((SECONDS + TIMEOUT))

while [ $SECONDS -lt $end ]; do
    READY_REPLICAS=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
    REPLICAS=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.replicas}')

    echo "Ready replicas: ${READY_REPLICAS}/${REPLICAS}"

    if [ "$READY_REPLICAS" == "$REPLICAS" ]; then
        echo "Deployment $DEPLOYMENT_NAME is successfully rolled out on time."
        exit 0
    fi

    sleep $INTERVAL
done

echo "Deployment $DEPLOYMENT_NAME did not roll out within ${TIMEOUT} seconds"
exit 1
```


Skrypt sprawdza, czy wdrożenie zakończyło się sukcesem w ciągu 60 sekund. Ustawia nazwę wdrożenia, namespace, czas oczekiwania (60 sekund) i interwał sprawdzania (5 sekund).
Oblicza czas zakończenia, dodając czas oczekiwania do bieżącego czasu.
W pętli co 5 sekund sprawdza status wdrożenia:
Pobiera liczbę gotowych replik oraz całkowitą liczbę replik.
Wyświetla informacje o liczbie gotowych i całkowitych replik.
Sprawdza, czy liczba gotowych replik jest równa całkowitej liczbie replik.
Jeśli tak, wyświetla komunikat o sukcesie i kończy działanie.
Jeśli czas oczekiwania minie, a wdrożenie nie jest gotowe, wyświetla komunikat o niepowodzeniu i kończy działanie.

Wynik:

Po wykonaniu rollback w aktualnej wersji działającej:
![](./ss/script.png)

Po zastosowaniu zmian w pliku deployment:

![](./ss/script1.png)

Po rollbacku wersji z błędem:

![](./ss/script2.png)

### Strategie wdrożenia
