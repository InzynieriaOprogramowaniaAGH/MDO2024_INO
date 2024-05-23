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

Kolejnym krokiem jest uruchomienie poda. Aby to zrobić można skorzystać z polecenia `minikube kubectl run`. Należy podać nazwę obrazu docker, który ma zostać uruchomiony, wyprowadzone porty (przez, które połączymy się z nginx'em) oraz label, dzięki któremu w prosty sposób będzie można sterować podem. Korzystając z `kubectl get pods` można wypisać działające pody.

```bash
minikube kubectl run -- nginx-deployment --image=nginx:latest --port=443 --labels app=nginx-deployment
```

![alt text](image-6.png)

Widać pojedynczy kontener z działającym nginx'em. Nie jesteśmy jeszcze w stanie połączyć się z kontenerem ponieważ znajdujemy się w innej sieci. W tym celu należy przekierować porty.


#### Dashboard k8s


### Wdrażanie na zarządzalne kontenery (K8s cz. 1)

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