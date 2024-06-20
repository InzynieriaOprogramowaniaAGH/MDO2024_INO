1.	Cel laboratorium
Celem laboratorium było poznanie nowego narzędzia do wdrażania aplikacji.
2.	Instalacja klastra kubernetes
Minikube to lekka implemenntacja Kubernetesa. Tworzy maszynę wirtualną na lokalnej maszynie i instaluje prosty klaster, który składa się z jednego węzła. 
Rozpoczęłam od pobrania i zainstalowania Minikube za pomocą binary package.
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```
 

Następnie pierwszy raz uruchomiłam minikube
```
minikube start
```
 
W tym momencie wszystko się instaluje. Oprogramowanie automatycznie wybiera sobie sterownik wirtualizacji (w moim przypadku Docker), sprawdza dostępność pamięci (będę musiała niestety znowu zwiększyć pamięć maszyny wirtualnej), uruchamia węzeł kontrolny, pobiera obrazy – bazowy i ze wstępnie zainstalowanym Kubernetesem.
 
Następnie sprawdziłam status gotowego Minikube:
```
Minikube status
```
 
Następnie musiałam zaopatrzyć się w polecenie kubectl. By móc zarządzać moim klastrem musiałam zainstalować nnarzędzie wiersza poleceń – kubectl. Umożliwia ono tworzenie deploymentu, aktualizowanie aplikacji czy ich skalowanie. 
Kubectl pobierałam i instalowałam według dokumentacji na oficjalnej stronie:
 
```
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256
```
Powyższym poleceniem pobrałam najnowszą wersję kubectl oraz plik zawierający sumę kontrolną dla pobranego pliku kubectl. Suma kontrolna służy do weryfikacji integralności pliku – upewnia to, że plik nie został uszkodzony podczas pobierania.
 
By zweryfikować czy wszystko jest w porządku użyłam polecenia:
```
echo "$(cat kubectl.sha256)  kubectl" | sha256sum –check
```
Jednak wyskoczył mi błąd:
 
Sprawdziłam czy plik kubectl.sha256 istnieje i jakie mam do niego uprawnienia:
 
Mimo poprawnych uprawnień i pliku, który istania w odpowiednim katalogu coś było nie tak.
Postanowaiłam wyczyścić maszynę z niepotrzebnych plików i ponownie uruchomić obydwie komendy instalacyjne:
 
Tym razem wszystko poszło pomyślnie. Najprawdopodobniej pierwsze polecenie uruchomione za pierwszym razem musiało czegoś nie pobrać.
Następnie zainstalowała kubectl:
```
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
I sprawdziłam jego poprawność:
```
Kubectl version –client
```
 
Wszystko przebiegło zgodnie z planem.
Poeceniem:
```

```
Wyswietliłam informację o bieżących podach w klastrze:
 
Sprawdziłam również działanie polecenia dedykowanego dla klastrów minikube:
```
minikube kubectl -- get po -A
```
 
Działa dokładnie tak samo.
Ponownie uruchomiłam minikube start
 
I sprawdziłam czy klaster działa poprawnie:
```
Kubectl get nodes
```
 
Kontener działa poprawnie:
 
Wymagania sprzętowe są zgodne z dokumentacją. Jedynie co cały czas wyskakuje mi, że pamięć jest na granicy wyczerpania.

Kolejnym krokiem było uruchomienie Dashboarda. 
```
Minikube dashboard
```
I w tym momencie mój dashboard jest dostępny pod adresem:
http://127.0.0.1:36003/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
 
 
Kubernetes jest przenośną, rozszerzalną platformą open source umożliwiającą zarządzanie kontenerowymi obciążeniami pracy i usług, uruchamianie aplikacji. Pozwala również na deklaratywną konfigurację i automatyzację.
Pod jest najmniejszą jednostką obliczeniową Kubernetesa, zawiera jeden lub więcej kontenerów współdzielących przestrezń sieciową i zasoby.
Deployment definiuje jakie kontenery mają być uruchamiane jako pody.
Service to stały punkt dostępu do podów, pozwala na komunikację między nimi a zewnętrznym klientem.
Namespace to logiczne grupowanie zasobów w klastrze, pomaga w organizacji aplikacji.
ReplicaSet jest kontrolerem zapewniającym, że określona liczba replik podów jest uruchamiana w klastrze.

3.	Uruchomienie oprogramowania
Do kolejnych kroków postanowiłm użyć swojego kontenera z nginx
 
Komendą:
```
minikube kubectl run -- nginx-minikube --image=my-nginx-dep --port=80 --labels app=nginx-minikube
```
Utworzyłam pod w klastrze kubernetes. Sprawdziłam, czy wszystko się zgadza:
 
 
Coś niestety nie działało.
Błędy mogą wynikać z małej ilości dostępnej pamięci na maszynie wirtualnej.
Próbowałam również stworzyć poda z pliku yaml jednak nadal wyskakiwały błędy:
 
 
Przez nie działające pody nie była też wstanie zrobić dla nich forwad. Próbowałam  to zrobić komendą:
```
kubectl port-forward pod/nginxdeploy 8002:80
```
 
Komunikację z eksponowaną funkcjonalnością sprawdziłabym za pomocą wpisania adresu ip i portu w przeglądarce.

4.	Przekucie wdrożenia manualnego w plik wdrożenia i wdrożenie deklaratywne YAML
Stworzyłam kolejny plik tym razem deployment.yml. Bazuję w nim na stworzonym przez siebie obrazie nginx2
 
W tym pliku replicas:3 oznacza, że tworzone są trzy repliki.
Uruchomiłam plik poleceniem:
```
Kubectl apply -f deployment.yml
```
 
Jak widać dzięki poleceniu:
```
Kubectl get deployment
```
Deployment został stworzony jednak tak jak poprzednio pody – nie działa.
Spróbowałam stworzyć deployment z tradycyjnym obrazem nginx – tym razem wszystko poszło zgodnie z planem.
 
 
Na koniec sprawdziłam jeszcze rollout status deploymentu. Poinformuje mnie to o stanie wdrażania mojego obrazu.
```
kubectl rollout status deployment/nginx-deployment-new
```
 
5.	Przygotowanie nowego obrazu
Ze względu na wcześniejsze próby, stworzyłam znacznie więcej obrazów programu. Jednak ze względów na oszczędność miejsca zostawiłam dwa:
 
Jak widać po poniższym screenie zadanie zostało wykonane z sukcesme gdyż żaden z tych obrazów w deploymencie nie działa:
 
6.	Zmiany w deplomencie
Ze względu na problemy z deploymentem zmodyfikowanego i zbudowanego przeze mnie obrazu nginx będę korzystać ze zwykłego obrazu.
Aktualizacja YAML wg kryteriów:
- zwiększenie replik do 8
 
- zmniejszenie liczby replik do 1
 
- zmniejszenie liczby replik do 0
 
Liczba replik w deploymencie wpływa na skalowalność, dostępność i wydajność aplikacji. Wielokrotne repliki mogą np. obsługiwać żądania równolegle. Posiadając więcej podów można być też spokojniejszym w momencie gdy któryś ulegnie jakiejś awarii, gdyż pozostałe nadal obsługują ruch. Ustawienie replik na zero oznacza, że wszystkie działające pody zostaną zatrzymane. Przydatne jest to przy testowania czy debugowaniu.
Gdy chcemy cofnąć ostatnie wdrożenie przydatne może być polecenie:
```
Kubectl rollout undo deployment/nginx-deployment-new
```
Dzięki temu możemy wycofać zmiany lub cofnąć wprowadzone błędy.

By podejrzeć historię deploymentu i jego aktualizacji można zastosować polecenie:
```
Kubectl rollout history deployment/nginx-deployment-new
```
Komendy te świetnie działają w przypadku próby podglądu jak radziły sobie wcześniejsze wersje obrazu lub gdy chcemy się cofnąć z nowo deployowanego obrazu gdyż na przykład posiad błędy.

7.	Kontrola wdrożenia
By skontrlować czy wdrożenie jest się w satnie wykonać w mnij niż minutę napisałam skrypt w Bashu:
 

By go uruchomić najpierw musiała usunąć plik blokady:
```
Rm file_lock
```
Następnie uruchomiłam skrypt:
```
Bash deploy.sh
```
Wynik dla deploymentu z 8 replikami:
 

8.	Strategie wdrożenia
Wdrażając oprogramowanie można stosować różne strategie. Ich celem jest  dostosowanie procesu wdrożenia do konkretnych celów klientów, minimalizacja ryzyka związanego z wdrożeniem czy wpływ na dostępność i wydajność aplikacji podczas wdrożenia.
Skrypty i ich wyniki dla różnych wdrożeń:
- Recreate Deployment – najprostsza strategia w której występuje downtime gdyż cały zestaw podów jest zatrzymywany a następnie tworzony jest nowy zestaw z nową wersją aplikacji
 
 
- Rolling Update Deployment – nowa wersja aplikacji jest wdrażana stopniowo, można kontrolować ilość niedostępnych jednocześnie podów i ilość równocześnie uruchomionych
 
 
- Canary Deployment – umożliwia testowanie aplikacji w środowisku produkcyjnym gdyż nowa wersja wdrażana jest dla małego grona użytkowników lub serwerów
 
 
Strategia Cnary nie jest obsługiwana bezpośrednio w elemencie Deployment. Wdrożenie tego typu można uzyskać tworząc wiele wdrożeń z różnymi wagami dla dystrybucji ruchu.
Wymienione wyżej strategie wdrażania oprogramowania różnią się od siebie przede wszystkim tym jak i ile podów na raz jest włączonych/wyłączonych. Każda ze strategii znajdzie swoje rmiejsce w zależności od tego do czego dążymy z wdrożeniem naszej aplikacji.
