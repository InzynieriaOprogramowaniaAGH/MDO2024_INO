# Sprawozdanie 5 - Konrad Rezler
## Zajęcia 10
## Wdrażanie na zarządzalne kontenery: Kubernetes (1)
### Instalacja klastra Kubernetes

Kubernetes to otwartoźródłowy system orkiestracji kontenerów. Umożliwia automatyzację wdrażania, skalowania i zarządzania aplikacjami kontenerowymi w klastrze serwerów. Kubernetes zarządza cyklem życia kontenerów, obsługuje balansowanie obciążenia, automatyczne przydzielanie zasobów, oraz monitorowanie stanu aplikacji. Dzięki temu umożliwia tworzenie skalowalnych, odporne na awarie i łatwo zarządzalnych środowisk produkcyjnych, co znacznie upraszcza operacje DevOpsowe.

Następującą komendą zaopatrzyłem się w implementację stosu k8s (minikube):
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie10-png/1.1 Zaopatrz się w implementację stosu k8s minikube">
</p>

Przy pomocy polecenia `minikube start` uruchomiłem instalację, konfigurację oraz kontener minikube:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie10-png/1.2 Zaopatrz się w implementację stosu k8s minikube">
</p>

Zainstalowałem `kubectl` oraz na koniec uruchomiłem dashboard komendą `minikube dashboard`, tak uruchomiony dashboard zostawiłem w dotychczasowym terminalu i na potrzeby dalszej pracy uruchomiłem kolejny terminal:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie10-png/2. intalacja kubectl">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie10-png/2.1 intalacja kubectl">
</p>

Następnie utworzyłem pod i przekeirowałem port aplikacji
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie10-png/3. utworzenie poda i przekierowanie portu">
</p>