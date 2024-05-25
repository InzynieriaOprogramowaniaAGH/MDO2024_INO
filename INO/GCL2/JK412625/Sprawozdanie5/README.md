## Sprawozdanie 5

### Wdrażanie na zarządzalne kontenery (K8s cz. 1)

> Informacja: W niektórych miejscach zamiast komendy kubectl może pojawić się samo k. W pliku ~/.bashrc został ustawiony alias na komendę kubectl (alias k='kubectl').

#### Minikube i inne narzędzia

Na zajęciach wykorzystaliśmy kilka narzędzi, które pozwalają na pracę w środowisku Kubernetes. [Kubernetes](https://kubernetes.io/docs/tutorials/kubernetes-basics/) to technologia pozwalająca zautomatyzować wdrażanie, skalowanie i zarządzanie aplikacjami. [Kluczowe elementy](https://kubernetes.io/docs/concepts/architecture/) Kubernetesa to:
- Pod -> najmniejsza zarządzalna jednostka w k8s
- Node -> węzęł to najczęsciej fizyczna lub wirtualna maszyna
- Master Node (Control Plane) -> główny element klastra, składa się z kilku kluczowych komponentów służących do zarządzania resztą węzłów: kube-apiserver, etcd (baza danych) czy kube-contoller-manager itd. 

> Więcej informacji znajduje się na stronie z dokumentacją: https://kubernetes.io/docs/home/.

Na zajęciach wykorzystaliśmy jedną z implementacji k8s.

Minikube to narzędzie open-source, które umożliwia uruchomienie lokalnego klastra Kubernetes na jednym komputerze. Jest często stosowane zamiast pełnego klastra Kubernetes ze względu na swoją prostotę i niskie wymagania systemowe. Minikube obsługuje różne platformy wirtualizacji, takie jak VirtualBox, Docker, oraz VMware, co pozwala na łatwe dostosowanie do różnych środowisk deweloperskich. Oferuje wsparcie dla większości funkcji k8s. Minikube jest idealne do testowania i rozwoju aplikacji kontenerowych, umożliwiając deweloperom szybkie tworzenie, uruchamianie i debugowanie aplikacji bez konieczności konfigurowania i zarządzania złożonym klastrem produkcyjnym.

##### Instalacja Minikube

W celu instalacji minikube należy wykonać kroki z instrukcji: https://minikube.sigs.k8s.io/docs/start/. Po pobraniu i zainstalowaniu klastra należy go uruchomić komendą `minikube start`.

![alt text](image-1.png)

Minikube działa w kontenerze. Gdy wypiszemy działające kontenery będzie można zauważyć forwarding charakterystycznych portów, które przekierowywuje minikube, np. 2376 (docker daemon).

![alt text](image-2.png)

Kolejnym krokiem jest instalacja kubectl'a.

##### Instalacja kubectl

Aby móc zarządzać klastrem z poziomu terminala potrzebne jest narzędzie `kubectl`. Pozwoli nam ono wykonywać komendy na węźle (np. uruchamiać wdrożenia, sprawdzać stan podów itp.). Aby zainstalować `kubectl` ze źródła należy wykonać [instrukcję](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/). Po poprawnej instalacji powinniśmy móc sprawdzić np. wersję kubectl'a lub wylistować pody.

![alt text](image.png)

Powyżej widać przykładowe pody z nginx'em (serwerem webowym).

#### Analiza wybranego oprogramowania

Kontener z sekcji `Deploy` z zajęć z Jenkinsowym Pipeline'em nie nadaje się do ciągłego wdrożenia. Ghidra to aplikacja GUI, która jedynie mogła by być dystrybuowana w środowisku kubernetes.

Zaistniała konieczność zmiany opgrogramowania na coś co może działać w trybie ciągłym i da się łatwo zweryfikować czy poprawnie działa. Najprostszym tego przykładem jest serwer webowy [Nginx](https://nginx.org/en/). Pozwala on na np. hostowanie statycznych treści, może działać jako [reverse-proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/), pozwala na cache'owanie treści lub pomaga regulować ruch sieciowy.

Domyślny kontener z nginx'em został lekko zmodyfikowany. Po pierwsze zmodyfikowany został domyślna konfiguracja znajdująca się w pliku `nginx.conf`. Dodany został nowy nagłówek serwera oraz zmodyfikowana została strona powitalna, która wyświetla się gdy poprawnie skonfigurujemy nginx'a. Dodatkowo włączony został SSL z [`self-signed` certyfikatami](https://www.sectigo.com/resource-library/what-is-a-self-signed-certificate). Pozwala to na połączenie się z webserwerem po `HTTPS`, jednakże gdy połączymy się z serwerem otrzymamy informację, że połączenie nie jest bezpieczne. Jest to spowodowane, że certyfikaty zostały wygenerowane własnoręcznie i nie są respektowane przez np. przeglądarkę.

Poniżej znajduje się zmodyfikowana koniguracja nginx'a. Większość atrybutów w tej konfiguracji stanowi wersję początkową. Jak wyżej wspomniano dodano możliwość komunikacji po HTTPS (server {listen 443}), dodano nagłówek z numerem studenta (add_header) i dodano hostowanie statycznego pliku o nazwie `index.html` (część kodu z location).

```conf
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    add_header X-server-header "My personal header JK412625!";
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;

    server {
        listen 80;
        listen [::]:80;
        server_name localhost;
        return 301 https://$host$request_uri;
    }
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name localhost;

        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        location / {
            root /var/www/html;
            index index.html;
        }
    }
    include /etc/nginx/conf.d/*.conf;
}
```

Zmodyfikowany obraz docker

```Dockerfile
FROM nginx

RUN mkdir -p /var/www/html/
COPY index.html /var/www/html/index.html

RUN mkdir -p /etc/nginx/ssl/ && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
```

Eksponujemy dwa porty: 80 (http) i 443 (https) w kontenerze.

#### Wdrożenie na k8s

Ay uruchomić kontener na stosie k8s można wykorzystać minikube'a. Na początku należy zbudować obraz ze zmodyfikowanym nginx'em. Są dwie opcje, z których można skorzystać:
- zbudować obraz i wypchnąć go do docker huba
- zbudować obraz wewnątrz środowiska docker'owego minikube'a, aby to zrobić należy w terminalu uruchomić polecenie `eval $(minikube -p minikube docker-env)`, które na czas trwania sesji w terminalu podmieni środowisko docker'owe na to w klastrze minikube. Dzięki temu nie będzie konieczności zaciągać obrazów z zewnętrznych źródeł.

W moim przypadku wybrana została opcja numer dwa. Gdy wypiszemy jakie zbudowane obrazy znajdują się w środowisku docker zobaczymy, że różnią się nieco od tego co jest dostępne w głównym systemie.

Wewnątrz minikube'a

![alt text](image-3.png)

W głównym systemie

![alt text](image-4.png)

Budowa zmodyfikowanego nginx'a. Dla celów zajęć zbudujemy dwa obrazy różniące się wiadomością w powitalnym html'u. Każdy z obrazów będzie otagowany inną wersją.

W katalogu z Dockerfile'em

```bash
docker build -t custom-nginx:1.0.0 .
docker build -t custom-nginx:2.0.0 .
```

Przykładowy wynik dla drugiej komendy.

![alt text](image-5.png)

Obraz można również dodać do głównego rejestru dockera (DockerHub) wykonująć poniższe komendy:

```bash
docker login
docker tag custom-nginx:1.0.0 <username>/custom-nginx:1.0.0
docker push <username>/custom-nginx:1.0.0
```

Kolejnym krokiem jest uruchomienie poda. Aby to zrobić można skorzystać z polecenia `minikube kubectl run`. Należy podać nazwę obrazu docker, który ma zostać uruchomiony, wyprowadzone porty (przez, które połączymy się z nginx'em) oraz label, dzięki któremu w prosty sposób będzie można sterować podem. Korzystając z `kubectl get pods` można wypisać działające pody.

```bash
minikube kubectl run -- nginx-deployment --image=nginx:latest --port=443 --labels app=nginx-deployment
```

![alt text](image-6.png)

Widać pojedynczy kontener z działającym nginx'em. Nie jesteśmy jeszcze w stanie połączyć się z kontenerem ponieważ znajdujemy się w innej sieci. W tym celu należy przekierować porty. Kubectl umożliwia na przekierowanie portów z wewnątrz klastra do naszej lokalnej sieci. W tym celu należy wykonać polecenie `kubectl port-forward pod/nginx-deployment 8000:443`. Port `443` kontenera będzie dostępny pod portem `8000` w naszej lokalnej sieci.

![alt text](image-7.png)

Można wykonać połączenie do webowego serwera, który wita nas zmodyfikowaną wcześniej stroną powitalną.

![alt text](image-8.png)

#### Dashboard k8s

Kubernetes udostępnia graficzny interfejs w formie aplikacji webowej, dzięki której można zarządzać klastrem. Aby go uruchomić w minikube należy wykonać komendę `minikube dashboard`. Wygląda on jak poniżej. 

![alt text](image-12.png)

Umożliwia on wykonywanie tych samych operacji, które można przeprowadzić za pomocą narzędzia wiersza poleceń kubectl, ale w bardziej interaktywny i dostępny sposób. Dzięki Dashboardowi użytkownicy mogą np. tworzyć i edytować zasoby lub monitorować stan klastra (jest to wygodniejsze niż uruchamianie kolejnych komend w terminalu).

### Wdrażanie na zarządzalne kontenery (K8s cz. 1)

#### Manifest

Kroki z poprzedniej części (uruchamianie poda, przekierowywanie portów itp.) można ubrać w tzw. wdrożenia (deployment'y) zapisane w formacie yaml. Zawierają one finalny stan aplikacji jaki chcemy otrzymać w klastrze k8s. Można sprecyzować wszystkie parametry związane z wdrożeniem danej aplikacji (przekierowanie portów, ilość podów jakie mają zostać uruchomione, ograniczenia zasobów dla podów takie jak procesor, pamięć itp.).

Plik wdrożenia dla zmodyfikowanego nginx'a

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: custom-nginx:1.0.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        - containerPort: 443
        resources:
          limits:
            memory: "512Mi"
```

Głównymi parametrami pliku wdrożenia są:
- `.kind` -> rodzaj wdrożenia np. Deployment/StatefulSet/CronJob/ReplicaSet
- `.spec.replicas` -> ilość replik danego poda
- `.spec.template.spec.containers` -> sprecyzowanie kontenerów znajdujących się w danym podzie (pod może mieć uruchomione wiele kontenerów)
    - `.spec.template.spec.containers.image` -> nazwa obrazu, który zostanie uruchomiony

#### Zmiany w deploymencie

Wdrażanie deploymentu zapisanego w formie yaml jest bardzo proste. Wystarczy wykonać komendę `kubectl apply -f <nazwa-pliku-wdrożenia>`.

![alt text](image-9.png)

Wdrożenie zostało uruchomione. Można teraz sprawdzić czy k8s stworzył docelową ilość zreplikowanych podów.

![alt text](image-10.png)

Zamast sprawdzać czy pody zostały uruchomione można sprawdzić stan `rollout'u` czyli tzw. procesu wdrożenia nowej wersji aplikacji ze zdefiniowaną ilością podów. Należy wykonać komendę `kubectl rollout status <resource-type>/<name-of-the-resource>`.

![alt text](image-11.png)

Komenda `kubectl rollout <opcja>` posiada inne ciekawe opcje:
- history -> można sprawdzić historę wdrożeń
- status -> status wdrożenia, pokazuje dynamicznie status jeżeli wdrożenie nie jest jeszcze gotowe
- undo -> przywrócenie poprzedniej wersji deploymentu
- pause/resume -> wstrzymanie/wznowienie deploymentu
 
Aktualne wdrożenie można modyfikować np. zmieniając parametry w wyżej wspomniany pliku yaml i ponownie uruchamiając polecenie `kubectl apply -f <nazwa-pliku-manifest>`.

![alt text](image-13.png)
![alt text](image-14.png)

Jak widać liczba podów zwiększyła się do 8. Można również redukować liczbę podów np. do 1 lub 0. Zmniejszenie liczby podów do 0 pozwala na zachowanie konfiguracji deploymentu. Jeżeli pojawi sie potrzeba ponownego uruchomienia podów, wystarczy wykonać jedną komendę (np. `kubectl scale deployment <nazwa-deploymentu> --replicas=<liczba-replik>`).

![alt text](image-15.png)

'Wyzerowanie' deploymentu. Widać, że deployment dalej istnieje w klastrze.

![alt text](image-16.png)

K8s pozwala w prosty sposób podmieniać wersje danej aplikacji. Przykładem może być zmiana wcześniej zmodyfikowanego obrazu nginx'a. Mamy dwie wersje, które różnią się tagiem oraz posiadają inne strony powitalne. Wersja 1.0.0 była wdrażana w poprzednich przykładach. Aby wdrożyć wersję 2.0.0 należy zmodyfikować tag obrazu custom-nginx w pliku yaml (z wdrożeniem).

![alt text](image-17.png)

Jak widać powyżej po wdrożeni nowej wersji obrazu otrzymujemy nową rewizję historii. Gdy sprawdzimy wersję obrazów np. używając dashboarda k8s zobaczymy wersję 2.0.0.

![alt text](image-18.png)

Gdyby nowo wprowadzona wersja np. nie działała lub miała jakieś luki bezpieczeństwa, w prosty sposób można cofnąć się do poprzedniej wersji deploymentu uruchamiając komendę `kubectl rollout undo`. Można sprecyzować którą wersję deploymentu chcemy przywrócić podając flagę `--to-revision=<numer-rewizji>` (domyślnie jest to największy numer).

![alt text](image-19.png)

Pody korzystają z obrazów z wersją 1.0.0

![alt text](image-20.png)

#### Strategie wdrożenia

Oto główne strategie wdrożeń w Kubernetes:
- RollingUpdate -> w strategii RollingUpdate, pody są aktualizowane stopniowo, co oznacza, że część starych podów jest sukcesywnie zastępowana nowszymi wersjami. W trakcie aktualizacji zawsze pewna liczba podów pozostaje dostępna, co zapewnia ciągłość działania aplikacji. Można precyzyjnie określić, ile podów ma być jednocześnie niedostępnych i ile nowych podów ma być tworzonych podczas wdrażania aktualizacji.
  - Parametr MaxSurge -> precyzuje ile nowych podów może zostać stworzonych na raz
  - Parametr MaxUnAvailable -> precyzuje maksymalną ilość niedostępnych podów.
- Recreate -> w strategii Recreate wszystkie pody są usuwane przed stworzeniem nowych podów z nowszą wersją.
- CanaryDeployment -> polega na stworzeniu deploymentu z nową wersją oprogramowania i udostępnieniu jej określonej liczbie użytkowników. Z czasem co raz więcej ruchu sieciowego jest przekierowywane do nowej instancji. Dzięki temu nowy deployment stopniowo otrzyma cały ruch sieciowy poprzedniego deploymentu.

**Wdrożenie *RollingUpdate***

Strategie dla deploymentu definiuje się pod parametrem `.spec.strategy` w pliku yaml. Poniżej ustawiono również wyżej wspomniane parametry sterujące sposobem wdrożenia nowych podów i zmieniono liczbę replik na 6.

```yaml
spec:
  (...)
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
```

Gdy zmienimy wersję oprogramowania `rollout` powinien zachować się w poniższy sposób.

![alt text](image-21.png)

**Wdrożenie *Recreate***

```yaml
spec:
  (...)
  strategy:
    type: Recreate
```

Po uruchomieniu nowego deploymentu za pomocą komendy `kubectl apply`, otrzymujemy poniższy wynik. Jak widać na końcu, nie ma widocznej operacji usuwania starych podów. Na początku wszystkie stare pod'y są usuwane, a następnie wdrażane są nowe.

![alt text](image-22.png)

**Wdrożenie *Canary Deployment***



> Powyżej wymienione strategie wdrażały wersję 2.0.0 lub 1.0.0 zmodyfikowanego obrazu nginx'a.

#### Serwisy


#### Kontrola wdrożenia



Komendy:
eval $(minikube -p minikube docker-env)

dzięki temu możemy budować obrazy wewnątrze daemona dockera minikube'a. nie trzeba tworzyć rejestru dockera.

po kolei:
docker build -t custom-nginx .
k apply -f nginx-deployment.yaml 
k get pods -w
k expose deployment nginx-deployment --type=NodePort --port=80,443
minikube service nginx-deployment
curl https://192.168.49.2:31544 --insecure


kubectl port-forward services/nginx-service 8000:80 8001:443