# Sprawozdanie 5 - Konrad Rezler
## Zajęcia 10
## Wdrażanie na zarządzalne kontenery: Kubernetes (1)
### Instalacja klastra Kubernetes

Kubernetes to otwartoźródłowy system orkiestracji kontenerów. Umożliwia automatyzację wdrażania, skalowania i zarządzania aplikacjami kontenerowymi w klastrze serwerów. Kubernetes zarządza cyklem życia kontenerów, obsługuje balansowanie obciążenia, automatyczne przydzielanie zasobów, oraz monitorowanie stanu aplikacji. Dzięki temu umożliwia tworzenie skalowalnych, odporne na awarie i łatwo zarządzalnych środowisk produkcyjnych, co znacznie upraszcza operacje DevOpsowe.

Następującą komendą zaopatrzyłem się w implementację stosu k8s (minikube):
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/1.1%20Zaopatrz%20si%C4%99%20w%20implementacj%C4%99%20stosu%20k8s%20minikube.png">
</p>

Przy pomocy polecenia `minikube start` uruchomiłem instalację, konfigurację oraz kontener minikube:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/1.2 Zaopatrz się w implementację stosu k8s minikube.png">
</p>

Zainstalowałem `kubectl` oraz na koniec uruchomiłem dashboard komendą `minikube dashboard`, tak uruchomiony dashboard zostawiłem w dotychczasowym terminalu i na potrzeby dalszej pracy uruchomiłem kolejny terminal:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/2. intalacja kubectl">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/2.1 intalacja kubectl.png">
</p>

Uruchamiając link zamieszczony na końcu wydruku wywołanego uruchomienie `minikube dashboard` uzyskujemy dostęp do dashboarda
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.1.1 pusty dashboard.png">
</p>

### Instalacja klastra Kubernetes
Utworzyłem pod i przekeirowałem port aplikacji, co odzwierciedliło swój efekt w dashboardzie
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3. utworzenie poda i przekierowanie portu.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.2 widok z dashboarda.png">
</p>

Dodatkowo w zakładce `PORTS` obecnej w Visual Studio Code dodatkowo przekierowałem port `3000` na `localhost:3001`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/3.1 przekierowalem port.png">
</p>

Pozwoliło mi to ostatecznie otworzyć stronę z przeglądarki mojego komputera:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie5/Sprawozdanie10-png/4. otworzenie strony po przekierowaniu portow.png">
</p>
