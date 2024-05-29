# Sprawozdanie 5
Krystian Gliwa, IO.

## Cel projektu

## Wdrażanie na zarządzalne kontenery: Kubernetes

### Instalacja klastra Kubernetes

#### Zaopatrzenie się w implementację stosu k8s: minikube oraz instalacja

Na początku zajęć zapoznałem się z wymaganiami sprzętowymi związanymi z instalacją **minikube** które znajdują się na stronie https://minikube.sigs.k8s.io/docs/start/ oraz sprawdziłem czy moja wirtalna maszyna się nadaje, po czym przeszedłem do instalacji zgodnie z zamieszczoną na tej stronie instrukcją, najpierw pobrałem najnowszą wersje pakietu Minikube dla systemów opartych na architekturze AMD64 (czyli x86_64) w formacie **.deb**, który jest typowy dla dystrybucji Linux opartych na Debianie, takich jak Ubuntu, poleceniem:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
```
oraz rozpocząłem instalacje poleceniem:
```
sudo dpkg -i minikube_latest_amd64.deb
```
![instalacja minikube](./zrzuty_ekranu/1.jpg)

#### Zaopatrzenie się w polecenie **kubectl** w wariancie minikube
**kubectl** - jest to narzędzie wiersza poleceń do interakcji z klastrem Kubernetes, najpierw utworzyłem alias *kubectl*, który zawsze uruchamia *minikube kubectl --* zamiast bezpośredniego *kubectl* poleceniem:
```
alias kubectl="minikube kubectl --"
```
A następnie wykorzystując to uruchomiłem polecenie które służy do pobrania i wyswietlenia listy wszystkich podów we wszystkich przestrzeniach nazw w klastrze Kubernetes uruchomionym przez Minikube:
```
kubectl get po -A
```
![kubectl get po -A](./zrzuty_ekranu/3.jpg)

#### Uruchomienie Kubernetesa

Aby pokazać działający kontener (uruchomić Kubernetesa) użyłem polecenia: 
```
minikube start
```
![uruchomienie kubernetesa](./zrzuty_ekranu/3.jpg)
