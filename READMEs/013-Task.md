# Zajęcia 13

# Wdrażanie na zarządzalne kontenery w chmurze (Azure)
## Zadania do wykonania
### Przygotowanie kontenera
 - Proszę upewnić się, że dysponuje się własnym kontenerem z aplikacją
 - Proszę zaktualizować wersję kontenera obecną na Docker Hub
 
### Zapoznanie z platformą
 - Konto do odblokowania za pomocą studenckiego konta Microsoft:
   https://azure.microsoft.com/en-us/free/ (personal) lub przez Panel AGH: https://panel.agh.edu.pl/ (student)
 - Cennik do przeczytania (ze zrozumieniem!!):
   https://azure.microsoft.com/en-us/pricing/details/container-instances/ 
 - Azure Cloud Shell dla powłok Bash i PowerShell, narzędzie potrzebne do wdrożenia:
   https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart
 - **Miej na uwadze, że zalogowanie ACS do Azure'a i wołanie az na instancji zużywa kredyty!**
 - Procedura wdrożenia kontenera:
   https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart
 - Przygotowanie aplikacji:
   https://docs.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-app
 - "Push image to Azure Container Registry" nie jest potrzebne!
 - *"Nie musisz tworzyć Docker Registry w Azure! Twoje obrazy już są na dockerhub'ie!"*

### Zadanie do wykonania
 1. Utwórz własny resource group
 2. Wdróż swój kontener z Docker Hub w swoim Azure
 3. Wykaż, że kontener został uruchomiony i pracuje, pobierz logi, przedstaw metodę dostępu do serwowanej usługi HTTP
 4. Zatrzymaj i usuń kontener, pamiętaj o *resource group* (to bardzo ważne!)

# Wykorzystanie chmury AWS do wdrożenia aplikacji webowej
## Zadania do wykonania
Celem ćwiczenia jest wdrożenie dowolnej aplikacji webowej na chmurze AWS w formie three-tier architecture. Aplikacja powinna składać się co najmniej z następujących komponentów:
- frontendu, np. React, Vue
- backendu, np. Nodejs, Django
- bazy danych z puli dostępnych na chmurze.
Nie ma wymagań co do funkcjonalności - może to być wyświetlanie treści zwracanej przez jeden endopoint, uzupełnianej o dane z bazy danych.
## Polecenia
1. Upewnij się, że wykorzystujesz zasoby regionu us-east-1.
2. Stwórz trzy Security Groupy, umieszczając je w domyślnym VPC:
    1. Dla bazy danych - pozwól na dowolny ruch wychodzący (outbound rules) oraz na _bezpieczny_ przychodzący (inbound rules).
    2. Dla aplikacji backendowej - pozwól na dowolny ruch wychodzący (outbound rules) oraz na _bezpieczny_ przychodzący (inbound rules). Testowo należy dodać możliwość komunikacji poprzez SSH.
    3. Dla aplikacji frontendowej - pozwól na dowolny ruch wychodzący (outbound rules) oraz _bezpieczny_ przychodzący (inbound rules). Testowo należy dodać możliwość komunikacji poprzez SSH.
3. Stwórz maszyny wirtualne dla aplikacji backendowej oraz frontendowej w ramach usługi EC2. Zalecane parametry:
    - System operacyjny: Amazon Linux 2 (ami-006dcf34c09e50022)
    - Typ instancji: t2.micro
    - VPC: domyślnie stworzone
    - Umieść maszyny we właściwych Security Groupach stworzonych w punkcie 2
4. Skonfiguruj maszyny wirtualne dla aplikacji backendowej oraz frontendowej, by mogły zostać prawidłowo uruchomione.
5. Stwórz bazę danych w dowolnej usłudze bazodanowej. Zalecane parametry:
    - Usługa RDS
    - Baza mysql
    - Template: free tier
    - Typ instancji: dowolny micro lub small
    - Dostęp publiczny ustawić na wyłączony (domyślna wartość)
    - Umieść tworzoną bazę w Security Groupie stworzonej w punkcie 2b
    - Wyłącz performance insights, backup oraz encryption (mogą mieć wpływ na koszty)
6. Zweryfikuj:
    1. Połączenie pomiędzy backendem a bazą danych. W razie potrzeby wgraj backup bazy z poziomu maszyny EC2.
    2. Połączenie pomiędzy frontendem a backendem.
    3. Dostępność frontendu z adresu publicznego.
    4. Brak dostępu do backendu oraz bazy danych z adresów publicznych.
7. Po weryfikacji usuń **wszystkie** zasoby, stworzone w ramach ćwiczenia. Udokumentuj to w sprawozdaniu!
8. Dodaj wszystkie pliki do swojej gałęzi do folderu Lab_cloud.
9. Wystaw Pull Request do gałęzi grupowej jako zgłoszenie wykonanego zadania. Kod źródłowy aplikacji może znajdować się w innym repozytorium, jednak wówczas należy do sprawozdania dołączyć do niego link.
