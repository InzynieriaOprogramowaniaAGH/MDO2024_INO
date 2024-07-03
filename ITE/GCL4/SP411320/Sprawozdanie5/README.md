# Wdrażanie na zarządzalne kontenery
Stanisław Pigoń

## Instalacja klastra Kubernetes
### K8s
Aby zainstalować stos k8s, instalujemy minikube, posiłkując się [dokumentacją](https://minikube.sigs.k8s.io/docs/start/). Wykonujemy poniższe polecenia:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

Następnie uruchamiamy minikube:
```bash
minikube start
```

![](img/10/minikube-start.png)

Klastrem w łatwy sposób możemy zarządzać z poziomu webowego panelu kontrolnego. Poniważ dostać do niego możemy się tylko z adresu lokalnego, polecenie `minikube dashboard` uruchamiamy w konsoli vscode podłączonego do maszyny wirtualnej - vscode automatycznie rozpoznaje próbę otwarcia przeglądarki przez polecenie i tworzy przekierowane

![](img/10/minikube-dashboard-strat.png)

![](img/10/minikube-dashboard.png)

![](img/10/vscode-proxy.png)

### `kubectl`
`kubectl` instalujemy również posiłkując się [dokumentacją](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/). Jest on wymagany do zarządzania zasobami Kubernetes na podobnej zasadzie podobnej do zarządzania usługami systemowymi poprzez polecenie `systemctl`.
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" # pobranie paczki
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" # pobranie sumy kontrolnej
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check # weryfikacja z sumą kontrolną
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl # instalacja
```

> [!tip]
> `kubectl` jest również jednym z kontekstów polecenia `minikube`, możliwe jest więc utworzenie aliasu `kubectl='minikube kubectl --'`

![](img/10/install-kubectl.png)

## Przygotowanie Aplikacji
### Dockerimage
Ze względu na potrzebę przygotowania aplikacji działającej w trybie ciągłym, przygotowujemy prostą stronę w pliku `index.html` i umieszczamy ją jako domyślny plik html w kontenerze nginx

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>The most powerfull hacker in the world...</title>
  <style>
    body {
      background-image: url('https://steamuserimages-a.akamaihd.net/ugc/94981434109308086/C48931A89D64785945BD0D364A481DA5BAB2B323/?imw=637&imh=358&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=true');
      background-size: cover;
      background-repeat: no-repeat;
      background-color: black;
    }
  </style>
</head>

<body>
</body>

</html>
```
> `src/index.html`

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```
> `src/Dockerfile`

### Zbudowanie, preztestowanie i publikacja obrazu
Obraz budujemy i uruchamiamy poleceniami w folderze `src`
```bash
docker build -t hackerman .
docker run -d -p 80:80 --rm --name hackerman-test hackerman
```

```
CONTAINER ID   IMAGE                                 COMMAND                  CREATED          STATUS          PORTS                                                                                                                                  NAMES
321895d72cb0   hackerman                             "/docker-entrypoint.…"   24 minutes ago   Up 24 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp                                                                                                      hackerman-test
964265c728e5   gcr.io/k8s-minikube/kicbase:v0.0.44   "/usr/local/bin/entr…"   26 hours ago     Up 26 hours     127.0.0.1:32772->22/tcp, 127.0.0.1:32771->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32769->8443/tcp, 127.0.0.1:32768->32443/tcp   minikube
```
> `docker ps`

![](img/10/hackerman-live.png)
> Uruchomiona strona

### Publikacja
Standardowo - tagujemy obraz i wypychamy go do remote'a po uprzednim zalogowaniu
```bash
docker tag hackerman pixel48/hackerman
docker login
docker push pixel48/hackerman
```

![](img/10/docker-push-hackerman.png)

![](img/10/dockerhub-hackerman.png)

## Uruchomienie aplikacji w Kubernetes
Za pomocą `kubectl` pobieramy i uruchamiamy aplikację.

`kubectl` syntaktycznie niewiele różni się od dockera, natomiast widoczny jest znaczny nacisk położony na kontrolę ustawień sieciowych i masowe zarządzanie połączeniami

![](img/10/tldr-kubectl.png)

![](img/10/tldr-kubectl-run.png)

![](img/10/tldr-kubectl-expose.png)

Aplikacje *podujemy* i *wystawiamy na zewnątrz* za pomocą następujących poleceń
> [!note]
> *Podujemy* i *wystawiamy na zewnątrz* są określeniami bardzo podobnymi do *spinu* elektronu, który możemy zwizualizować jako *kulę, która wiruje*, natomiast nie jest to kula, i nie wiruje - pojęcia te znacząco uogulniają faktycznie podjęte akcje.
```bash
kubectl run hackerman --image=pixel48/hackerman --port=80 --labels app=hackerman
kubectl expose pod hackerman --port=80 --target-port=80 --name=hackerman
```

Poprawność uruchomienia poda możemy zweryfikować poleceniem `kubectl get pods` oraz w panelu kontrolnym

![](img/10/kubectl-get-pods.png)

![](img/10/kubectl-dashboard-view.png)

Działanie aplikacji wystawionej na porcie 80tym możemy łatwo sprawdzić, wchodząc na adres hosta

![](img/10/kubectl-hackerman-pod-live.png)

Dodatkowo możemy również przekierować dostęp do poda na inny port za pomocą `kubectl port-forward` - nie wybierając portu lokalnego kubernetes sam wybierze losowy, wolny port

```bash
kubectl port-forward pod/hackerman :80
```

## Przygotowanie pliku wdrożenia
Wdrożenia można automatyzować za pomocą plików konfiguracyjnych w formacie YAML. Ułatwia to masowe tworzenie replik aplikacji, zarządzanie rozległymi sieciami mikroserwisów oraz znacząco przyśpiesza pracę.

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: &h hackerman
  labels:
    app: *h
spec:
  replicas: 12
  selector:
    matchLabels:
      app: *h
  template:
    metadata:
      labels:
        app: *h
    spec:
      containers:
        - name: hackerman-image
          image: pixel48/hackerman
          ports:
            - containerPort: 80
              protocol: TCP
```
> `src/hackerman-12.yml`

Zdefiniowany w ten sposób deployment można nastepnie uruchomić za pomocą polecenia `kubectl apply -f <filename>.y[a]ml`

![](img/10/hackermans.png)

![](img/10/dashboard-hackermans.png)
