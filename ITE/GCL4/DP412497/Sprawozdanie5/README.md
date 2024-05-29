# Sprawozdanie 05
# IT 412497 Daniel Per
---

## Wdrażanie na zarządzalne kontenery: Kubernetes (1)
## Wdrażanie na zarządzalne kontenery: Kubernetes (2)
---
Celem tych ćwiczeń było zapoznanie się z Kubernetes'em.

---

## Wykonane zadanie - Lab 010-011
---


### Instalacja klastra Kubernetes
 * Zaopatrz się w implementację stosu k8s: [minikube](https://minikube.sigs.k8s.io/docs/start/)

![ss](./ss/ss01.png)
Wchodzimy na podaną stronę i wybieramy interesujący nas system i typ instalacji. W naszym przypadku (Fedora) jest to Linux i wybieramy RPM package.

 * Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji
Korzystamy z podanych nam na stronie komend w celu instalacji minikube'a.


```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```
![ss](./ss/ss02.png)

 * Zaopatrz się w polecenie `kubectl` w wariancie minikube, może być alias `minikubctl`, jeżeli masz już "prawdziwy" `kubectl`

Do tego korzystamy z podanej nam komendy:
```
alias kubectl="minikube kubectl --"
```

 * Uruchom Kubernetes, pokaż działający kontener/worker

```
minikube start
```

![ss](./ss/ss03.png)


 * Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność
Uruchamiamy dashboard komendą:
```
minikube dashboard
```
![ss](./ss/ss04.png)

I następnie (jeśli nie otworzy się automatycznie) przechodzimy na adres który pojawi się w konsoli.

![ss](./ss/ss05.png)


 
### Analiza posiadanego kontenera
 * Zdefiniuj krok "Deploy" swojego projektu jako "Deploy to cloud":
   * Deploy zbudowanej aplikacji powinien się odbywać "na kontener"
   * Przygotuj obraz Docker ze swoją aplikacją - sprawdź, że Twój kontener Deploy na pewno **pracuje**, a nie natychmiast kończy pracę! 😎
   * Jeżeli wybrana aplikacja nie nadaje się do pracy w kontenerze i nie wyprowadza interfejsu funkcjonalnego przez sieć, wymień projekt na potrzeby tego zadania:
     * Optimum: obraz-gotowiec (po prostu inna aplikacja, np. `nginx`, ale **z dorzuconą własną konfiguracją**), samodzielnie wybrany program, obraz zbudowany na jego bazie
     * Plan max: obraz wygenerowany wskutek pracy *pipeline'u*
   * Wykaż, że wybrana aplikacja pracuje jako kontener

Jako iż poprzednio pracowaliśmy na `irssi`, które nie jest stale działającym programem, dla tego zadania posłużymy się `nginx`.
Przygotujemy sobie `Dockerfile'a`, aby stworzyć swoją wersję obrazu lokalnie.
   
### Uruchamianie oprogramowania
 * Uruchom kontener na stosie k8s
 * Kontener uruchomiony w minikubie zostanie automatycznie ubrany w pod.
 * ```minikube kubectl run -- <nazwa-wdrożenia> --image=<obraz-docker> --port=<wyprowadzany port> --labels app=<nazwa-wdrożenia>```
 * Przedstaw że pod działa (via Dashboard oraz kubectl)
 * Wyprowadź port celem dotarcia do eksponowanej funkcjonalności
 * ```kubectl port-forward pod/<nazwa-wdrożenia> <LO_PORT>:<PODMAIN_CNTNR_PORT> ```
 * Przedstaw komunikację z eskponowaną funkcjonalnością
 
### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)
Kroki, od których zaczniemy następne zajęcia:
 * Zapisanie [wdrożenia](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) jako plik YML
 * Przeprowadź próbne wdrożenie przykładowego *deploymentu* `nginx`
 * ```kubectl apply``` na pliku



# ===============================================================================


# Zajęcia 11


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








```
137  cd Dev2/MDO2024_INO/ITE/GCL4/DP412497/Sprawozdanie5
  138  cd yamle
  139  minikube start
  140  kubectl apply -f deployment.yaml
  141  minikube apply -f deployment.yaml
  142  minikubectl apply -f deployment.yaml
  143  kubectl apply -f deployment.yaml
  144  alias kubectl="minikube kubectl --"
  145  kubectl apply -f deployment.yaml
  146  kubectl apply -f service.yaml
  147  kubectl get deployments
  148  kubectl get services
  149  minikube service nginx-service
  150  kubectl apply -f deployment.yaml
  151  kubectl apply -f service.yaml
  152  kubectl get deployments
  153  kubectl get services
  154  minikube service nginx-service
  155  kubectl get deployments
  156  minikube service nginx-service
  157  kubectl apply -f deployment.yaml
  158  kubectl get deployments
  159  kubectl apply -f deployment.yaml
  160  kubectl get deployments
  161  minikube dashboard
  162  kubectl rollout history
  163  kubectl rollout history deployments/nginx-deployment
  164  kubectl apply -f deployment.yaml
  165  kubectl rollout  deployments/nginx-deployment
  166  kubectl rollout deployments/nginx-deployment
  167  kubectl rollout history deployments/nginx-deployment
  168  kubectl apply -f services.yaml
  169  kubectl apply -f service.yaml
  170  minikube stop
```


