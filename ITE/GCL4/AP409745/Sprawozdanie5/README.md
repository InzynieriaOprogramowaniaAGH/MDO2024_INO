# SPRAWOZDANIE 5
Andrzej Piotrowski, IT
DevOps GCL4

## Cel Zajęć
Laboratoria koncentrowały się na zarządzaniu kontenerami w ramach technologii Kubernetes.

# Przygotowanie Kubernetes
Najpierw należało zainstalować implementację stosu k8s, jaką jest `minikube`
W tym celu na [stronie](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Frpm+package)
 wybrano odpowiedni pakiet dla maszyny na której pracowano (system Linux, architektura procesora x86, instacja jako pakiet RPM). Wymagało to pobrania pakietu i instalacji za pomocą poniższych komend:.
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```
Następnie zaopatrzono się w polecenie kubectl w wariancie minikube. W tym celu utworzono alias `alias kubectl="minikube kubectl --"`, po czym uruchomiono Kubernetes. Minikube automatycznie pobrał najnowszą wersję Kubernetes (Wersja 1.30 Uwubernetes) i ją uruchomił.
![alt text](images/image1.png)
Do zarządzania nim przy pomocy interfejsu graficznego potrzebne było uruchomienie Dashboard'a, który daje możliwość zarządzania z poziomu przeglądarki. Dashboard uruchomiono komendą `minikube dashboard`. Jako, że korzystałem ze środowiska VSCode, VSC automatycznie przekierował port, pozwalając połączyć się z zewnątrz maszyny wirtualnej.
![alt text](images/image2.png)
![alt text](images/image3.png)

## Przygotowanie Aplikacji
Niestety okazało się, że aplikacja z tkórej chciałem wcześniej skorzystać (klient Irssi), nie nadawała się do tych labolatoriów. Nie działała ona w trybie ciągłym, wymagała do tego uruchamiania interaktywnego. Z tego powodu zmuszony byłem wykorzystać inną aplikację. Wybrałem NGINX, serwer webowy.

W celu rozpoczęcia prac nad wdrażaniem NGINX'a w ramach Kubernetes, musiałem najpierw stworzyć obraz lokalny, z własną konfiguracją, więc stworzyłem prosty plik HTML z przepisem na nachosy jako stronę, oraz plik Dockerfile do tworzenia obrazu.

![alt text](images/image4.png)
Dockerfile definiuje nam pobranie NGINX w wersji 1.26.0 oraz podmienienie domyślnego pliku strony index.html na nasz własny. Następnie należało utworzyć obraz i uruchomić w celu sprawdzenia czy nasza aplikacja działa. Kontener uruchomiono, eksponując go na (przekierowanym w VS Code) porcie 80.

```
docker build -f nginx.Dockerfile -t nginx-img .
docker run -d -p 80:80 --name nginx-cont nginx-img
```
![alt text](images/image6.png)
![alt text](images/image5.png)

Jak widać, nasza strona została uruchomiona jako kontener, i możliwym było połączenie się z nią w celu wyświetlenia przepisu.

Następnie, jako że chcemy uruchomić nasz kontener na stosie K8s, musimy go opublikować na DockerHub'ie, gdyż domyślnie Kubernetes obrazy pobiera. Alternatywnie możliwe jest skorzystanie z lokalnych obrazów, poprzez ustawienie odpowiednich zmiennych środowiskowych oraz polityki pobierania, ale wybrałem DockerHub'a gdyż był bardziej przystępny w implementacji.

W tym celu zalogowałem się do swojego konta, otagowałem obraz oraz opublikowałem go w repozytorium.
```
docker login
docker tag [nazwa obrazu] [nowa nazwa : tag]
docker push [repozytorium]
```

![alt text](images/image8.png)
![alt text](images/image7.png)

Następnie testuję czy uda się uruchomić obraz ściągająć z DockerHub'a. Kontener się uruchamia i nie zamyka i można odwiedzić witrynę.
`docker run -d --rm -p 80:80 --name nginx-dockerhub apiotrow/nginx-img:0.1`
![alt text](images/image9.png)
![alt text](images/image10.png)

## Uruchamianie oprogramowania

Następnie należało uruchomić kontener na stosie k8s. W tym celu użyłem wcześniej zamieszczonych danych z DockerHub'u.

W tym celu uruchomiłem pod z obrazem, wyeksponowałem jego port 80, a nastepnie zforwardowałem go na port 2133 maszyny. Dzięki temu możliwy był dostęp do strony zawartej w podzie.

```
kubectl run kube-nginx-01 --image=apiotrow/nginx-img:0.1 --port=80 --labels app=kube-nginx-01
kubectl expose pod kube-nginx-01 --port=80 --target-port=80 --name=kube-nginx-01
kubectl port-forward pod/kube-nginx-01 2133:80
```
![alt text](images/image11.png)
![alt text](images/image14.png)
![alt text](images/image13.png)
![alt text](images/image12.png)