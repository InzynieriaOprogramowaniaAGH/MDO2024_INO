#	CEL LABORATORIUM 
Celem laboratorium było poznanie nowego narzędzia do wdrażania aplikacji.

# INSTALACJA KLASTRA KUBERNETES
Minikube to lekka implemenntacja Kubernetesa. Tworzy maszynę wirtualną na lokalnej maszynie i instaluje prosty klaster, który składa się z jednego węzła. 
Rozpoczęłam od pobrania i zainstalowania Minikube za pomocą binary package.
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/800752e8-5315-4df4-94cf-0506df8a642c)
 

Następnie pierwszy raz uruchomiłam minikube
```
minikube start
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/bccda990-f242-4f7f-89cc-20dda56401f0)

 
W tym momencie wszystko się instaluje. Oprogramowanie automatycznie wybiera sobie sterownik wirtualizacji (w moim przypadku Docker), sprawdza dostępność pamięci (będę musiała niestety znowu zwiększyć pamięć maszyny wirtualnej), uruchamia węzeł kontrolny, pobiera obrazy – bazowy i ze wstępnie zainstalowanym Kubernetesem.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/afd4845c-105c-4308-ac7f-5a00ec24747e)

 
Następnie sprawdziłam status gotowego Minikube:
```
Minikube status
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cefc6db6-c9b3-4d5d-81f6-32f794f8065d)

 
Następnie musiałam zaopatrzyć się w polecenie kubectl. By móc zarządzać moim klastrem musiałam zainstalować narzędzie wiersza poleceń – kubectl. Umożliwia ono tworzenie deploymentu, aktualizowanie aplikacji czy ich skalowanie. 
Kubectl pobierałam i instalowałam według dokumentacji na oficjalnej stronie:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/7ceda7bb-1316-4fa7-a814-1d909c3040f4)


```
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256
```
Powyższym poleceniem pobrałam najnowszą wersję kubectl oraz plik zawierający sumę kontrolną dla pobranego pliku kubectl. Suma kontrolna służy do weryfikacji integralności pliku – upewnia to, że plik nie został uszkodzony podczas pobierania.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/06664c86-273e-422e-a683-49cab522d1ea)

 
By zweryfikować czy wszystko jest w porządku użyłam polecenia:
```
echo "$(cat kubectl.sha256)  kubectl" | sha256sum –check
```
Jednak wyskoczył mi błąd:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e757e1c2-86c4-49da-9f5a-99a1972a811a)

 
Sprawdziłam czy plik kubectl.sha256 istnieje i jakie mam do niego uprawnienia:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/ef634a8e-44d1-4a9e-a38e-e35bf91a9c1d)

 
Mimo poprawnych uprawnień i pliku, który istniał w odpowiednim katalogu coś było nie tak.
Postanowaiłam wyczyścić maszynę z niepotrzebnych plików i ponownie uruchomić obydwie komendy instalacyjne:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/07707eee-1752-427b-9293-d00f6f880cdc)

 
Tym razem wszystko poszło pomyślnie. Najprawdopodobniej pierwsze polecenie uruchomione za pierwszym razem musiało czegoś nie pobrać.
Następnie zainstalowała kubectl:
```
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
I sprawdziłam jego poprawność:
```
kubectl version –-client
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/938618fe-d9f3-4e45-8f03-9f2dd8def4bc)

 
Wszystko przebiegło zgodnie z planem.
Poleceniem:
```
kubectl get po -A
```
Wyswietliłam informację o bieżących podach w klastrze:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/fa6aa53b-8f2b-48cc-8fbb-8527f16fc5c6)

 
Sprawdziłam również działanie polecenia dedykowanego dla klastrów minikube:
```
minikube kubectl -- get po -A
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/dc00be8c-b198-49a8-9917-f6341c5221bc)

 
Działa dokładnie tak samo.
Ponownie uruchomiłam minikube start
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/da2b1c98-ea14-4a3a-ac2e-a1f914c99bf8)

 
I sprawdziłam czy klaster działa poprawnie:
```
Kubectl get nodes
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/98ed2f4d-341c-4d99-9c64-ecacab2afc73)

 
Kontener działa poprawnie:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/66b1a254-8a3e-4244-aaaa-1dfd7ea44a99)

 
Wymagania sprzętowe są zgodne z dokumentacją. Jedynym problemem, który zgłasza minikube jest bardzo ograniczona ilość pamięci na maszynie wirtualnej.

Kolejnym krokiem było uruchomienie Dashboarda. 
```
Minikube dashboard
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/7cae353a-4343-435f-a556-2999f5fda065)


I w tym momencie mój dashboard jest dostępny pod adresem:
http://127.0.0.1:36003/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/47dc9abd-f0fe-42f9-8d45-7926b8235b3a)

 
 
Kubernetes jest przenośną, rozszerzalną platformą open source umożliwiającą zarządzanie kontenerowymi obciążeniami pracy i usług, uruchamianie aplikacji. Pozwala również na deklaratywną konfigurację i automatyzację.
Pod jest najmniejszą jednostką obliczeniową Kubernetesa, zawiera jeden lub więcej kontenerów współdzielących przestrezń sieciową i zasoby.
Deployment definiuje jakie kontenery mają być uruchamiane jako pody.
Service to stały punkt dostępu do podów, pozwala na komunikację między nimi a zewnętrznym klientem.
Namespace to logiczne grupowanie zasobów w klastrze, pomaga w organizacji aplikacji.
ReplicaSet jest kontrolerem zapewniającym, że określona liczba replik podów jest uruchamiana w klastrze.

# URUCHOMIENIE OPROGRAMOWANIA
Do kolejnych kroków postanowiłm użyć swojego kontenera z nginx
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/ebc22542-a274-476a-b4b0-893e6a7a76d9)

 
Komendą:
```
minikube kubectl run -- nginx-minikube --image=my-nginx-dep --port=80 --labels app=nginx-minikube
```
Utworzyłam pod w klastrze kubernetes. Sprawdziłam, czy wszystko się zgadza:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d84df703-d95d-4d4e-a27f-9aa9f7d988a6)

 
 
Coś niestety nie działało.
Błędy mogą wynikać z małej ilości dostępnej pamięci na maszynie wirtualnej.
Próbowałam również stworzyć poda z pliku yaml jednak nadal wyskakiwały błędy:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/9c116814-1e36-4f45-af4f-381cfb20bd1a)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/2cc065b2-6b33-44e2-83eb-ac712e8e2aa5)


 
 
Przez niedziałające pody nie byłam też wstanie zrobić dla nich forwad. Próbowałam  to zrobić komendą:
```
kubectl port-forward pod/nginxdeploy 8002:80
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/8a5f52bf-7a8e-48da-9418-b3cb7916cd75)

 
Komunikację z eksponowaną funkcjonalnością sprawdziłabym za pomocą wpisania adresu ip i portu w przeglądarce.

# PRZEKUCIE WDROŻENIA MANUALNEGO W PLIK WDROŻEENIA I WDROŻENIE DEKLARATYWNE YAML
Stworzyłam kolejny plik tym razem deployment.yml. Bazuję w nim na stworzonym przez siebie obrazie nginx2
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/b8abb8d0-2ce2-4c00-a3ad-83d39b5d712f)

 
W tym pliku replicas:3 oznacza, że tworzone są trzy repliki.
Uruchomiłam plik poleceniem:
```
Kubectl apply -f deployment.yml
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/5d797d63-9117-4890-b988-392d9b08bc3b)

 
Jak widać dzięki poleceniu:
```
kubectl get deployment
```
Deployment został stworzony jednak tak jak poprzednio pody – nie działa.
Spróbowałam stworzyć deployment z tradycyjnym obrazem nginx – tym razem wszystko poszło zgodnie z planem.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e6486984-12a7-4a65-ae6f-407b2a37057c)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d7b30d9a-2706-458f-b136-42e51382b34d)

 
 
Na koniec sprawdziłam jeszcze rollout status deploymentu. Poinformuje mnie to o stanie wdrażania mojego obrazu.
```
kubectl rollout status deployment/nginx-deployment-new
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/94db148f-ef3b-4032-b949-5921f6e10014)

 
# PRZYGOTOWANIE NOWEGO OBRAZU
Ze względu na wcześniejsze próby, stworzyłam znacznie więcej obrazów programu. Jednak ze względów na oszczędność miejsca zostawiłam dwa:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/dfac0b74-5ffe-4cec-8fc0-97f76f2af13e)

 
Jak widać po poniższym screenie zadanie zostało wykonane z sukcesme gdyż żaden z tych obrazów w deploymencie nie działa:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/835c63d0-650a-4c0f-98d1-63921d5ec9a6)

 
# ZMIANY W DEPLOYMENCIE
Ze względu na problemy z deploymentem zmodyfikowanego i zbudowanego przeze mnie obrazu nginx będę korzystać ze zwykłego obrazu.
Aktualizacja YAML wg kryteriów:
- zwiększenie replik do 8
- ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/8b75d0f1-b3d6-4a02-8a8f-0e5a6de56063)

 
- zmniejszenie liczby replik do 1
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/4b9619b4-40e5-48a9-9c9a-0b5ca20a7a03)

 
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

# KONTROLA WDROŻENIA
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
 

# STRATEGIE WDROŻENIA
Wdrażając oprogramowanie można stosować różne strategie. Ich celem jest  dostosowanie procesu wdrożenia do konkretnych celów klientów, minimalizacja ryzyka związanego z wdrożeniem czy wpływ na dostępność i wydajność aplikacji podczas wdrożenia.
Skrypty i ich wyniki dla różnych wdrożeń:
- Recreate Deployment – najprostsza strategia w której występuje downtime gdyż cały zestaw podów jest zatrzymywany a następnie tworzony jest nowy zestaw z nową wersją aplikacji
 
 
- Rolling Update Deployment – nowa wersja aplikacji jest wdrażana stopniowo, można kontrolować ilość niedostępnych jednocześnie podów i ilość równocześnie uruchomionych
 
 
- Canary Deployment – umożliwia testowanie aplikacji w środowisku produkcyjnym gdyż nowa wersja wdrażana jest dla małego grona użytkowników lub serwerów
 
 
Strategia Canary nie jest obsługiwana bezpośrednio w elemencie Deployment. Wdrożenie tego typu można uzyskać tworząc wiele wdrożeń z różnymi wagami dla dystrybucji ruchu.
Wymienione wyżej strategie wdrażania oprogramowania różnią się od siebie przede wszystkim tym jak i ile podów na raz jest włączonych/wyłączonych. Każda ze strategii znajdzie swoje rmiejsce w zależności od tego do czego dążymy z wdrożeniem naszej aplikacji.
