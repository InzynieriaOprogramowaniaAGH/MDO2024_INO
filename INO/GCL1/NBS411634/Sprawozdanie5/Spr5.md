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

Aplikacja używana przeze mnie we wcześniejszych laboratoriach nie nadaje się do pracy w kontenerze
 * Zdefiniuj krok "Deploy" swojego projektu jako "Deploy to cloud":
   * Deploy zbudowanej aplikacji powinien się odbywać "na kontener"
   * Przygotuj obraz Docker ze swoją aplikacją - sprawdź, że Twój kontener Deploy na pewno **pracuje**, a nie natychmiast kończy pracę! 😎
   * Jeżeli wybrana aplikacja nie nadaje się do pracy w kontenerze i nie wyprowadza interfejsu funkcjonalnego przez sieć, wymień projekt na potrzeby tego zadania:
     * Optimum: obraz-gotowiec (po prostu inna aplikacja, np. `nginx`, ale **z dorzuconą własną konfiguracją**), samodzielnie wybrany program, obraz zbudowany na jego bazie
     * Plan max: obraz wygenerowany wskutek pracy *pipeline'u*
   * Wykaż, że wybrana aplikacja pracuje jako kontener
   

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
 