# Sprawozdanie 5

---
# Wdrażanie na zarządzalne kontenery: Kubernetes

## Magdalena Rynduch ITE GCL4

Celem laboratorium była konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML oraz jego kontrola za pomocą Kubernetes.
Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu
Laboratorium rozpoczęłam instalacji `minikube`. Minikube to narzędzie open-source, które umożliwia uruchomienie lokalnego klastra Kubernetes na maszynie deweloperskiej.

![1 - install minikube](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/58cb0537-03a9-4c20-a935-0d0fbb58debd)

Docker wymaga uprawnień administratora do uruchamiania, ponieważ działa na poziomie systemowym. Dodanie użytkownika do grupy za pomocą docker `sudo usermod -aG docker` pozwala mu na uruchamianie komend Docker bez konieczności używania sudo. Po dodaniu użytkownika do grupy docker komenda `newgrp docker` pozwala na odświeżenie uprawnień użytkownika w bieżącej sesji terminala. Bez tego kroku zmiany nie byłyby widoczne, dopóki użytkownik nie zalogowałby się ponownie. 
Następnie za pomocą `minikube start` uruchamiany jest Minikube, który tworzy środowisko Kubernetes na lokalnym komputerze.
 
![2 - minikube start](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/4e18fb29-1129-4337-9827-6bfe63b4d768)
![3 - docker ps](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/137e28c5-ab92-4c18-bb6c-0c24e2d211f2)

Kolejnym krokiem jest instalacja `kubectl`. Jest to narzędzie wiersza poleceń służące do interakcji z klastrami Kubernetes. Jest niezbędny, ponieważ umożliwia zarządzanie zasobami Kubernetes, takimi jak pody, usługi, wdrożenia (deployments) i inne.
 
![4 1 - kubectl](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/eb2c7281-942d-4597-9ce4-335d820ba232)
![4 2 - kubectl minikube](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0c5cf510-d714-4648-8767-bd62693ce28b)

Skorzystałam z polecenia `minikube dashboard` w celu uruchomienia i otwarcia przeglądarki internetowej z graficznym interfejsem użytkownika dla klastra Kubernetes uruchomionego przez Minikube.

![5 - minikube dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/acdb513e-3290-445a-aee2-4e876d4df5e0)
![6 - dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fa3c9d52-307b-4b91-bc9f-aad63497620c)

Repozytorium, z którego korzystałam w poprzednich laboratoriach nie nadawało się do zrealizowania tej instrukcji, ponieważ nie pracowało ono w trybie ciągłym. Z tego powodu zdecydowałam się skorzystać z Nginx. Nginx to serwer internetowy o wysokiej wydajności i wszechstronnym zastosowaniu, który jest używany do obsługi stron internetowych, jako serwer proxy, oraz do równoważenia obciążenia (load balancing). 
W kolejnym kroku zaktualizowałam lokalne pakiety i zainstalowałam nginx.

![7 - nginx install](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/3445c332-1e9b-4301-8c0c-42e2ae98a4c4)

Korzystając z komendy `systemctl status nginx` sprawdziłan stan usługi Nginx.

![8 - nginx active](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b87e8488-30a6-4244-9140-f921b106fc5f)

Kolejnym krokiem było skopiowanie domyślnego pliku startowego Nginx - `index.html` do katalogu `Sprawozdanie5`.

![9 - cp](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/200ca115-e7d6-4af1-b687-22d5399d3a09)

Zmodyfikowałam zawartość strony tak, aby różniła się od oryginalnej. Dodałam napis „Udalo się!” do  nagłówka strony oraz paragraf z numerem katalogu w jej dolnej części.
Następnie stworzyłam plik Dockerfile, który bazuje na obrazie `nginx` i kopiuje zmodyfikowany `index.html` do odpowiedniego katalogu tak, aby był używany przy starcie.

```
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```

Bazując na podanym pliku Dockerfile, buduję obraz `nginx_image` za pomocą Dockera.

![10 - build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6fbadee9-154b-4d57-b89b-9d7893caa480)

W kolejnym kroku uruchamiam kontener z obrazu `nginx_image`.

![11 - run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/645340c4-4257-480d-8b53-9d4779ae029e)

Po uruchomieniu nasłuchuję port. Wynik potwierdza zastosowanie zmodyfikowanego pliku `index.html`.

![12 - run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a533247f-7bad-4ece-b804-2df46b700443)

W kolejnym etapie, korzystam z polecenia `minikube docker-env`. Generuje ono zmienne środowiskowe, które są potrzebne do skonfigurowania lokalnego klienta Docker, aby mógł komunikować się z demonem Docker działającym wewnątrz klastra Minikube. Dzięki poleceniu powłoki `eval` argument wykonywany jest jako komenda. Formuła `$(...)`najpierw wykonuje komendę wewnątrz nawiasów, a następnie używa wyniku tej komendy jako argumentu dla `eval`.
Wykonanie `eval $(minikube -p minikube docker-env)` zmienia kontekst działania klienta Docker, przekierowując jego operacje do demon Docker działającego w klastrze Minikube, co może spowodować zmianę listy obrazów Docker na te dostępne w klastrze Minikube.

![13 - minikube](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/172915d3-40d0-479e-a076-bab2b16506fc)

W następnym korku tworzę dwie wersje obrazu `nginx_image`.

![14 - build versions](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9fd2c5b5-63b4-4a34-ab7d-5f06968e5ea7)
![15 - docker images](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f6e2a0ff-0e68-421b-8de5-7b35ac998074)

Aby uruchomić aplikację w klastrze Minikube wykonuję komendę `minikube kubectl run`. Korzystając z `kubectl get pods` wyświetlam listę bieżacych podów.

![16 - minikube kubectl run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/91c97a8d-6b45-4017-905c-40bae2ab2f3b)

Pody można obserwować również korzystając GUI.

![17 - pods](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/effba95d-5ed3-46c2-876e-f86181c5fe0d)

Następnie  przy pomocy `kubectl post-forward` wyprowadziłam port w celu dotarcia do funkcjonalności.
 
![18 - przekierowanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/73696eb6-beb1-4230-8d31-efa0a09933e4)
![19 - run 8000](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ba38bea9-61e1-48ec-9b62-009ba481b27c)

Korzystając a Minikube, zaleca się po skończonej pracy wykonać polecenie 	`minikube stop` w celu zwolnienia zasobów systemowych oraz oszczędności energii. Dane i konfiguracje klastra są zachowywane, dzięki czemu po ponownym uruchomieniu będą nadal dostępne.

![20 - minikube stop](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ff0dcc5f-26d7-4061-9ad3-e23df7afd3dd)

Kolejnym krokiem było stworzenie pliku deploy.yml oraz zapisanie w nim wykonanych kroków.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - name: nginx-deploy
        image: nginx_image:2.0.0
        ports:
        - containerPort: 80
```

Następnie korzystając z `kubectl apply` zastosowałam zasoby Kubernetes zdefiniowane w pliku `deploy.yml`. Pozwoliło to na automatyzację wdrożenia Nginx. Obraz wzbogacony został o 4 repliki.

![21 - deploy yaml](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a200821f-6041-46a6-8222-6be7d87336ec)
![22 - pods dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b2187e82-06af-46d5-8a1b-494b857c94f7)

W celu usuwania podów z klastra Kubernetes używałam polecenia `kubectl delete pod`.

![23 - pod delete](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/80f24307-8445-489d-b742-d3448a091b93)

Poleceniami używanymi do zarządzania aktualizacjami w klastrze są: `kubectl rollout status` i `kubectl rollout history`. Pierwsze służy do sprawdzania stanu aktualizacji, a drugie do wyświetlania historii aktualizacji.

![24 - rollout history](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fdbe610d-cb70-4ba8-bf5b-ea244c78a1bc)

Zmiany w deploymencie:
- zwiększenie ilości replik do 8 (tworzone są brakujące 4 repliki)
- zmniejszenie ilości replik do 1 (system będzie usuwał najnowsze repliki, aż zostanie tylko jedna replika – najstarsza)
- zmniejszenie liczby replik do 0 (spowoduje wyłączenie działania aplikacji)

![26 - zmiany ilości replik](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/8afe6629-0572-418f-8118-0458d47f3893)

Zastosowanie nowej wersji obrazu skutkuje aktualizacją działających instancji aplikacji na tę nową wersję obrazu. Zmiana ta jest uwzględniana w historii aktualizacji.

![27 - zmiana wersji](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/2970ede7-b441-4d31-bd3e-968d0c5aa51d)
![28 - replica sets](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1dce3b06-38af-4149-96b6-1f86f093c9cd)

W celu zmiany wersji na starszą, można zastosować `kubectl rollout undo`. Kubernetes cofa wówczas aktualizację do poprzedniej wersji, jednak numery rewizji nadal wzrastają. Cofnięcie aktualizacji nie usuwa wpisów z historii.

![29 - undo](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/70407a41-44ce-4468-a9c8-13c0c60b5c62)
![30 - undo dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/88309872-b064-49a0-90a6-457a3ad83ccf)

W celu kontroli wdrożenia, napisałam skrypt sprawdzający czy wdrożenie zdążyło się wykonać w przeciągu 60 sekund (ze sprawdzaniem stanu 12 razy, co 5 sekund).

```
#!/bin/bash

DEPLOYMENT_NAME="error-deploy"
TIMEOUT=60
INTERVAL=5

MAX_TRIES=$(( TIMEOUT / INTERVAL ))

for (( i=0; i<MAX_TRIES; i++ )); do
  echo "Status wdrożenia - próba $((i+1))/$MAX_TRIES"
  
  READY_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}')
  TOTAL_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.replicas}')
  
  if [[ "$READY_PODS" -eq "$TOTAL_PODS" ]]; then
    echo "Wdrożenie $DEPLOYMENT_NAME zakończyło się w czasie $TIMEOUT s"
    exit 0
  fi
  
  sleep $INTERVAL
done

echo "Wdrożenie $DEPLOYMENT_NAME nie zakończyło się w czasie $TIMEOUT s."
exit 1

```
Przed uruchomieniem pliku należy nadać mu odpowiednie prawa. Wdrożenie przebiegło błyskawicznie i już po pierwszym sprawdzeniu statusu było zakończone.

![31 - script](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0ab04032-4526-4e7f-b4d8-005f263da407)

W ramach laboratorium napisałam również plik `Dockerfile.error` dla obrazu, którego uruchomienie kończy się błędem.

```
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
CMD ["sh", "-c", "Container failed. && exit 1"]
```
Zbudowałam i uruchomiłam obraz.

![32 - dockerfile error](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/23c35af6-e4bb-42bd-b956-024e8a98b77d)

W przypadku próby uruchomienia aplikacji z błędnego obrazu ukazuje się READY jako 0/1, co oznacza, że kontener nie został uruchomiony i nie jest gotowy do obsługi ruchu.

![33 - error created](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1019975b-543a-492a-94b1-4ef0b91ca2c6)
![34 - error dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ad8df2be-2152-48fc-8cc9-4e9f2d68b93d)

W tym celu skorzystania z błednego obrazu w skrypcie stworzyłam plik `deploy-error.yaml` analogicznie do `deploy.yaml`.

W przypadku korzystania z błędnego obrazu wykonanie skryptu skutkowało wykonaniem wszystkich możliwych prób w przeciągu 60 sekund i negatywnym wynikiem.

![35 - error script](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fb21e052-6f06-4c1e-96e1-7cef2261c327)

Skrypt `deploy-error.yaml` miał stworzyć dwie repliki. Oba procesy zakończyły się niepowodzeniem.

![36 - error script dashboard](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/468f0aac-2f14-4654-a407-004cef845e9f)

Kolejnym etapem było wykonanie różnych wersji wdrożeń zmieniając ich strategie wdrożeń.

Użycie `kubectl get pods -w` w drugim terminalu wraz z różnymi strategiami wdrożeń w Kubernetes umożliwiło monitorowanie stanu podów w czasie rzeczywistym w zależności od strategii.

Strategia Recreate polega na usunięciu wszystkich istniejących Podów przed utworzeniem nowych. 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 4
  strategy:
    type: Recreate
```

![38 - recreate](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e07b1c68-c156-4b65-9a5b-b767f48194f5)

Strategia RollingUpdate (domyślna) polega na stopniowym zastępowaniu starych Podów nowymi. Proces można kontrolować za pomocą parametrów:
- maxUnavailable – maksymalna liczba podów, które mogą być niedostępne (niewdrażane) podczas aktualizacji
- maxSurge - maksymalna liczba podów, które mogą być wdrożone ponad zdefiniowaną liczbę replik w czasie aktualizacji

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 5
      maxSurge: 30%
```

![39 - rolling](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/67a15105-5b0d-437f-80af-8303ef1a2804)

Strategia Canary polega na wdrożeniu nowej wersji aplikacji tylko dla niewielkiej części użytkowników. Utworzyłam drugi deployment z nową wersją aplikacji i stopniowo zwiększałam liczbę replik.

![46 - canary 4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6cfb09ac-35ea-457e-8913-0ece4f1fb2fc)
![45 - canary 3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f86dffe5-7883-4bc3-bf92-d8c827b3cdb0)


