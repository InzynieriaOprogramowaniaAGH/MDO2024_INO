# Sprawozdanie 5
Natalia Borysowska-Ślęczka, IO

## Streszczenie projektu

...

## Wykonane kroki - laboratorium nr 10

## Zadania do wykonania

### Instalacja klastra Kubernetes
 * Pobieram [minikube](https://minikube.sigs.k8s.io/docs/start/)
 * Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji

 Pobieram paczkę komendą

 ```curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb```

 ![](./ss_lab10/lab10_1.png)

 Następnie przechodzę do instalacji

 ```sudo dpkg -i minikube_latest_amd64.deb```

 ![](./ss_lab10/lab10_2.png)

 * Zaopatrz się w polecenie `kubectl` w wariancie minikube, może być alias `minikubctl`, jeżeli masz już "prawdziwy" `kubectl`

 Pobieram `kubectl`

 ```minikube kubectl -- get po -A```

 ![](./ss_lab10/lab10_3.png)

 Wprowadzam alias 

 ```alias kubectl="minikube kubectl --"```

 ![](./ss_lab10/lab10_4.png)

 * Uruchom Kubernetes, pokaż działający kontener/worker

 Uruchamiam minikube

 ```minikube start```

 ![](./ss_lab10/lab10_5.png)

 Poprawnie działający kontener

 ```sudo docker ps```

 ![](./ss_lab10/lab10_7.png)

 Działający klaster

 ```kubectl get nodes```

 ![](./ss_lab10/lab10_6.png)

 * Zmityguj problemy wynikające z wymagań sprzętowych lub odnieś się do nich (względem dokumentacji)

    Minikube wymaga:
    * 2 CPU
    * 2GB RAM
    * 20GB wolnego miejsca na dysku

 Tworząc maszynę wirtualną spełniłam wszystkie powyższe wymagania, zatem nie było konieczne wprowadzać żadnych zmian. 
 Jeżeli wymagania sprzętowe okazałyby się nie wystarczające należy odpowiednio skonfigurować Minikube, zwiększając ilość przydzielonej pamięci RAM pamięci na dysku lub procesorów

 ```minikube config set memory 2048```

 ```minikube config set disk-size 20g```
 
 ```minikube config set cpus 2```

 Aby zastosować zmiany należy ponownie uruchomić Minikube

 ```minikube stop```

 ```minikube start```

 * Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność

 ```minikube dashboard```

 ![](./ss_lab10/lab10_8.png)

 Korzystam z VisualStudio Code, zatem nastąpiło przekierowanie do przeglądarki (vs code zapewnia automatyczne wbudowane przekierowanie portów)

 ![](./ss_lab10/lab10_9.png)

 * Zapoznaj się z koncepcjami funkcji wyprowadzanych przez Kubernetesa (*pod*, *deployment* itp)
    1. *Pod* - jest najmniejszą i najbardziej podstawową jednostką przetwarzania w Kubernetesie
        * Może zawierać jeden lub więcej kontenerów
        * Kontenery w podzie dzielą ten sam adres IP, przestrzeń nazw i woluminy
        * Żywotność podó jest krótka, są zastępowane w przypadku awarii
    2. *Deployment* - zarządza zestawem Podów
        * Dba o utrzymanie określonej liczby działających Podów
        * Automatyzuje proces aktualizacji aplikacji, skalowania i odzyskiwania awarii
        * Umożliwia zarządzanie wersjonowaniem aplikacji
        * Umożliwia automatyczne skalowanie i samonaprawianie się aplikacji
    3. *Service* - definiuje sposób uzyskiwania dostępu do Podów
        * Zapewnia stały adres IP i nazwę DNS dla zestawu Podów
        * Umożliwia zrównoważenie obciążenia ruchu sieciowego do zestawu Podów

 Do poprawnego wyłączenia Kubernetesa używam komendy

 ```minikube stop```

 Zapobiegam pojawieniu się ewentualnych błędów

### Analiza posiadanego kontenera

 Do wykonania tej części zadania użyję aplikacji `nginx`zmodyfikowanej o własną konfigurację.

 Pracę rozpoczynam od pobrania `nginx'a` na swoją maszynę

 ```sudo apt update```

 ![](./ss_lab10/lab10_10.png)

 ```sudo apt install nginx```

 ![](./ss_lab10/lab10_11.png)

 Po aktualizacji listy pakietów oraz pobraniu, sprawdzam status `nginx'a`

 ![](./ss_lab10/lab10_12.png)

 Widać, że `nginx` jest uruchomiony, zatem instalacja przebiegła poprawnie.

 Dodatkowo, aby upewnić się czy `nginx` działa, otwieram przeglądarkę internetową i wchodzę na stronę:

 ```http://your_vm_ip_address``` *(IP maszyny wirtualnej można psrawdzić poleceniem `hostname -I`)*

 Powinna pojawić się powitalna strona `nginx'a`

 ![](./ss_lab10/lab10_13.png)

 Strona uruchamia się poprawnie, zatem obraz `nginx'a` jest prawidłowy

 Kolejnym krokiem będzie własna konfiguracja `nginx`. Modyfikacji dokonam w pliku `index.html`

 Tworzę plik Dockerfile

 ```nano Dockerfile```

 ![](./ss_lab10/lab10_14.png)

 ```
 FROM nginx
 COPY index.html /usr/share/nginx/html/index.html
 ```
 Tworzę plik `index.html`, w nim dokonam modyfikacji jeśli chodzi o działanie `nginx'a`. Moja strona będzie wyświetlać napis powitalny.

 ```
 <!DOCTYPE html>
 <html>
 <head>
     <title>Moja Strona NGINX</title>
 </head>
 <body>
     <h1>Witaj w mojej stronie na NGINX!</h1>
 </body>
 </html>
 ```

 Buduję obraz `nginx` w katalogu zawierającym Dockerfile i index.html (u mnie folder *kubernetes*)

 ```docker build -t my-nginx .```

 ![](./ss_lab10/lab10_15.png)

 ![](./ss_lab10/lab10_16.png)

 Uruchamiam skonfigurowanego `nginx`

 ```docker run -d -p 8070:80 my-nginx``` (używam portu 8070, gdyż port domyślny - 8080 był u mnie zajęty) 

 *-d* - opcja działania kontenera w trybie *detached*, co pozwala mu działać w tle

 ![](./ss_lab10/lab10_17.png)

 Efekt konfiguracji `nginx'a'

 ![](./ss_lab10/lab10_18.png)

 Kolejnym krokiem będzie publikacja na DockerHubie. W tym celu loguje się na DockerHuba'a poleceniem

 ```docker login```

 ![](./ss_lab10/lab10_19.png)

 Nadaje odpowiedni tag na swój kontener

 ```docker tag my-nginx nbsss/my-nginx:1.0```

 ![](./ss_lab10/lab10_20.png)

 Publikuje

 ```docker push nbsss/my-nginx:v1```

 ![](./ss_lab10/lab10_21.png)

 Obraz po opublikowaniu jest widoczny na DockerHUbie

 ![](./ss_lab10/lab10_22.png)   

### Uruchamianie oprogramowania
 * Uruchom kontener na stosie k8s

 Zaczynam od załadowania obrazu pobranego z DockerHuba do minikube
 
 ```minikube image load my-nginx```

 * Kontener uruchomiony w minikubie zostanie automatycznie ubrany w pod.
 * ```minikube kubectl run -- <nazwa-wdrożenia> --image=<obraz-docker> --port=<wyprowadzany port> --labels app=<nazwa-wdrożenia>```

 ![](./ss_lab10/lab10_23.png)   

 * Przedstaw że pod działa (via Dashboard oraz kubectl)
 * Wyprowadź port celem dotarcia do eksponowanej funkcjonalności
 * ```kubectl port-forward pod/<nazwa-wdrożenia> <LO_PORT>:<PODMAIN_CNTNR_PORT> ```
 * Przedstaw komunikację z eskponowaną funkcjonalnością
 
### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)
Kroki, od których zaczniemy następne zajęcia:
 * Zapisanie [wdrożenia](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) jako plik YML
 * Przeprowadź próbne wdrożenie przykładowego *deploymentu* `nginx`
 * ```kubectl apply``` na pliku

## Wykonane kroki - laboratorium nr 11
 
## Zadania do wykonania
### Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML
 * Upewnij się, że posiadasz wdrożenie z poprzednich zajęć zapisane jako plik
 * Wzbogać swój obraz o 4 repliki
 * Rozpocznij wdrożenie za pomocą ```kubectl apply```
 * Zbadaj stan za pomocą ```kubectl rollout status```

### Przygotowanie nowego obrazu
 * Zarejestruj nową wersję swojego obrazu `Deploy` (w Docker Hub lub lokalnie)
 * Upewnij się, że dostępne są dwie co najmniej wersje obrazu z wybranym programem
 * Jeżeli potrzebny jest "gotowiec" z powodu problemów z `Deploy`, można użyć np `httpd`, ale powinien to być **własny** kontener: zmodyfikowany względem oryginału i opublikowany na własnym koncie DH.
 * Będzie to wymagać 
   * przejścia przez *pipeline* dwukrotnie, lub
   * ręcznego zbudowania dwóch wersji, lub
   * przepakowania wybranego obrazu samodzielnie np przez ```commit```
 * Przygotuj wersję obrazu, którego uruchomienie kończy się błędem
  
### Zmiany w deploymencie
 * Aktualizuj plik YAML z wdrożeniem i przeprowadzaj je ponownie po zastosowaniu następujących zmian:
   * zwiększenie replik np. do 8
   * zmniejszenie liczby replik do 1
   * zmniejszenie liczby replik do 0
   * Zastosowanie nowej wersji obrazu
   * Zastosowanie starszej wersji obrazu
 * Przywracaj poprzednie wersje wdrożeń za pomocą poleceń
   * ```kubectl rollout history```
   * ```kubectl rollout undo```

### Kontrola wdrożenia
 * Napisz skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)
 * Zakres rozszerzony: Ujmij skrypt w pipeline Jenkins (o ile minikube jest dostępny z zewnątrz)
 
### Strategie wdrożenia
 * Przygotuj wersje [wdrożeń](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) stosujące następujące strategie wdrożeń
   * Recreate
   * Rolling Update (z parametrami `maxUnavailable` > 1, `maxSurge` > 20%)
   * Canary Deployment workload
 * Zaobserwuj i opisz różnice
 * Uzyj etykiet
 * Dla wdrożeń z wieloma replikami, użyj [serwisów](https://kubernetes.io/docs/concepts/services-networking/service/)
 * Zaobserwuj i opisz różnice
 * Uzyj etykiet
 * Dla wdrożeń z wieloma replikami, użyj [serwisów](https://kubernetes.io/docs/concepts/services-networking/service/)
 
