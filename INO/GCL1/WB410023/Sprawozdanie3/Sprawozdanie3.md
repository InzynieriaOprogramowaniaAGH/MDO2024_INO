# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 5 - Pipeline, Jenkins, izolacja etapów

### Opis celu i streszczenie projektu:

Celem ćwiczeń było przeprowadzenie procesu budowy i testowania projektu za pomocą narzędzi takich jak Jenkins oraz Docker, a także zapoznanie się z tworzeniem pipeline'ów, izolacją etapów oraz konfiguracją środowiska.

Projekt polegał na implementacji i testowaniu pipeline'a w Jenkinsie w celu automatyzacji procesu budowy, testowania i wdrażania aplikacji, a także skonfigurowanie Jenkinsa wraz z odpowiednimi kontenerami Docker, aby umożliwić ciągłe dostarczanie oprogramowania (CI/CD) poprzez zautomatyzowane wykonywanie kolejnych etapów, takich jak budowanie, testowanie i wdrażanie aplikacji.

Streszczenie wykonanego projektu:
W ramach projektu przeprowadzono szereg kroków. Na początku, zapewniono poprawne działanie kontenerów budujących i testujących, a następnie zainstalowano Jenkinsa oraz przygotowano obrazy Docker, w tym obraz Blueocean. Następnie utworzono projekty Jenkinsa, które wykonywały różne zadania, takie jak wyświetlanie informacji o systemie, sprawdzanie parzystości godziny, czy budowanie obrazu z Dockerfile. Dodatkowo, przeprowadzono integrację z repozytorium GitHub oraz wykonano pipeline, który automatyzował proces budowy, testowania i deployu aplikacji. Na koniec, utworzono dokumentację z diagramami UML oraz omówiono różnice między budowaniem na dedykowanym DIND a bezpośrednio na kontenerze CI. Cały proces przebiegł pomyślnie, a pipeline został skonfigurowany tak, aby automatycznie reagować na zmiany w repozytorium.

## Zrealizowane kroki:
### Przygotowanie:

### 1. Upewniłam się, że kontenery budujące i testujące, stworzone na poprzednich zajęciach działają.

W tym celu zalogowałam się i uruchomiłam kontener do budowania:
```bash
docker login
docker start <CONTAINER_ID>
```
Uruchomiłam kontener z **dockerem**, z którego korzysta **Jenkins**:
```bash
docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2
```

### 2. Zapoznałam się z instrukcją instalacji **Jenkinsa**: https://www.jenkins.io/doc/book/installing/docker/.

- Uruchomiłam obraz **Dockera**, który przedstawia środowisko zagnieżdżone.

- Na ostatnich zajęciach przygotowałam obraz **Blueocean** na podstawie obrazu **Jenkinsa**. 
Blueocean to nowoczesny i przejrzysty interfejs użytkownika stworzony specjalnie dla Jenkinsa. Jego celem jest ułatwienie wizualizacji i zarządzania procesami CI/CD. 
Dostarcza bardziej intuicyjne i uporządkowane narzędzia do monitorowania i analizowania procesów budowy i dostarczania aplikacji w porównaniu z tradycyjnym interfejsem Jenkinsa.

- Sprawdziłam stan utworzonego obrazu **Blueocean**:
```bash
docker ps
```
![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/1.jpg)

Zalogowałam się do **Jenkins** oraz zadbałam o konfigurację, archiwizację i zabezpieczenie logów.

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/2.jpg)

### Uruchomienie:

### 1. Utworzyłam pierwszy projekt, który wyświetla uname.

Utworzyłam ogólny projekt o nazwie **uname**.

![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/3.jpg)

W sekcji **Kroki Budowania** wybrałam opcję **Uruchom Powłokę** oraz napisałam poniższy skrypt.
```bash
uname -a
```
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/4.jpg)

Następnie uruchomiłam projekt i wyświetliłam **Logi Konsoli**.

![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/5.jpg)

![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/6.jpg)

![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/7.jpg)

### 2. Utworzyłam projekt, który zwraca błąd, gdy godzina jest nieparzysta.

Utworzyłam projekt ogólny o nazwie **is-the-hour-odd**.

![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/8.jpg)

W sekcji **Kroki Budowania** wybrałam opcję **Uruchom Powłokę** oraz napisałam poniższy skrypt.
```bash
#!/bin/bash
current_hour=$(date +%H)
if ((current_hour % 2 != 0 )); then
echo "Error: the hour is odd."
exit 1

else
echo "The hour is even."
exit 0

fi
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/9.jpg)

Następnie uruchomiłam projekt o godzinie **11:45**.

![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/10.jpg)

![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/10a.jpg)

Wyświetliłam **Logi Konsoli**.

![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/11.jpg)

Skrypt zwraca **błąd**, kiedy godzina jest nieparzysta - prawidłowe, oczekiwane działanie.

### 3. Utworzyłam "prawdziwy" projekt, którego zadaniem jest sklonowanie repozytorium, przechodzenie na osobistą gałąź oraz budowanie obrazu z dockerfiles, które wcześniej wrzuciłam do repozytorium.

Utworzyłam ogólny projekt o nazwie **real-project**.

![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/12.jpg)

W sekcji **Repozytorium kodu** wybrałam opcję **Git**, a następnie wkleiłam link do repozytorium. 

![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/13a.jpg)

Repozytorium jest prywatne, dlatego należało skonfigurować odpowiednie **Credentials** potwierdzające tożsamość. 
Aby tego dokonać skopiowałam hasło utworzonego **Personal Access Token**.
Następnie wpisałam login swojego konta **GitHub** oraz wkleiłam hasło utworzonego **Personal Access Token**:

![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/13b.jpg)

Dodany użytkownik w **Credientals**:

![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/13c.jpg)

W sekcji **Branches to build** wpisałam swoją gałąź **WB410023**.

Zapisałam oraz uruchomiłam utworzony projekt:

![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/15.jpg)

Logi konsoli:

![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/14.jpg)

Skrypt poprawnie pobiera repozytorium oraz przełącza się na moją gałąź.


### 4. Dokonałam edycji "prawdziwego" projektu, tak aby budował obrazy z dockerfile, który wcześniej wrzuciłam do repozytorium.

Dokonałam edycji **powłoki** w sekcji **Kroki budowania**:

```bash
cd INO/GCL1/WB410023/Sprawozdanie2/
docker build -t builder --build-arg TOKEN="<TOKEN>" .
```

![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/16.jpg)

Zapisałam oraz uruchomiłam utworzony projekt. Logi konsoli:

![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/17.jpg)

Skrypt prawidłowo pobiera repozytorium oraz przełącza się na moją gałąź, a następnie buduje obraz z **Dockerfile**, który wcześniej wrzuciłam do repozytorium.

###  Dokumenty z diagramami UML

Środowisko pracy:
Serwer CI/CD (Jenkins) zainstalowany i skonfigurowany. Dostęp do systemu kontroli wersji (np. Git) oraz repozytorium kodu.
Środowisko Docker zainstalowane na serwerze CI/CD.

Zależności i konfiguracje:
Repozytorium kodu źródłowego dostępne na platformie GitHub pod adresem: https://github.com/weronikaabednarz/spring-petclinic.
Ustawienia uwierzytelnienia do repozytorium przez ID (ID uwierzytelnienia e08d9a39-11d6-4211-b184-d7f62f6bf3e3).
Dockerfile dla budowania (dockerfile_builder) oraz testowania (dockerfile_tester) aplikacji dostępne w katalogu projektu.

- Diagram aktywności, pokazujący kolejne etapy (collect, build, test, report)

![43](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/diagram2.jpg)

- Diagram wdrożeniowy, opisujący relacje między składnikami, zasobami i artefaktami

![44](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/diagram3.jpg)

- Pozostałe diagramy uzupełniające

![45](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/diagram1.jpg)

![46](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/diagram4.jpg)

### Pipeline: Zdefiniowałam pipeline korzystający z kontenerów celem realizacji kroków build -> test

#### Pipeline może być konfigurowany do budowania zarówno na dedykowanym DIND (Docker-in-Docker) lub bezpośrednio na kontenerze CI. Funkcjonalne różnice między tymi podejściami:

- Dedykowany DIND (Docker-in-Docker):

W tym podejściu Docker działa wewnątrz kontenera CI.
Oznacza to, że wewnątrz kontenera CI można budować i uruchamiać inne kontenery Docker.
Jest to przydatne, gdy proces budowy wymaga pełnej izolacji środowiska i dostępu do funkcji Docker, takich jak budowanie obrazów Docker.
Jednakże użycie DIND może wprowadzić pewne problemy z wydajnością i bezpieczeństwem, związane z uruchamianiem kontenerów w kontenerze.

- Budowanie od razu na kontenerze CI:
W tym przypadku proces budowy odbywa się bezpośrednio na kontenerze CI, bez użycia DIND.
Nie ma potrzeby uruchamiania dodatkowego kontenera Docker wewnątrz kontenera CI.
Jest to zwykle szybsze i bardziej efektywne pod względem zasobów w porównaniu do użycia DIND.
Jednakże, jeśli proces budowy wymaga funkcji Docker, takich jak budowanie i uruchamianie kontenerów, może to być ograniczające.

W skrócie, główną różnicą między tymi podejściami jest sposób, w jaki Docker jest używany podczas procesu budowy. Dedykowany DIND umożliwia uruchamianie kontenerów Docker wewnątrz kontenera CI, podczas gdy budowanie od razu na kontenerze CI eliminuje potrzebę uruchamiania dodatkowego kontenera Docker i przyspiesza proces budowy. Przy wyborze należy kierować się wymaganiami projektu, oraz preferencjami dotyczącymi wydajności i bezpieczeństwa.

Dla swojego projektu wybrałam budowę na dedykowanym DIND.

### 1. Wykonanałam własny fork repozytorium: https://github.com/spring-projects/spring-petclinic.

![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/18.jpg)

![22](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/19.jpg)

Sforkowane repozytorium na moim koncie na GitHub:

![23](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/20.jpg)

### 2. Wstępne wymagania środowiska dla tego programu:
- min. Java 17
- Gradle/Maven

### 3. Spawdziłam czy licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania.

![24](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/21.jpg)

### 4. Do plików sforkowanego repozytorium dodałam pliki: **dockerfile_builder** oraz **dockerfile_tester**.
Zawartość pliku **dockerfile_builder**:
```bash
FROM gradle:latest

WORKDIR /app

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/spring-projects/spring-petclinic

WORKDIR /app/spring-petclinic
```
![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/22.jpg)

Zawartość pliku **dockerfile_tester**:
```bash
FROM spring-builder:latest

RUN ./gradlew build -x test
```
![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/23.jpg)

Dodane przeze mnie do repozytorium pliki **dockerfile_builder** oraz **dockerfile_tester**:

![27](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/24.jpg)

### 5. Utworzyłam nowy projekt **Pipeline**:

Na początku, stworzyłam nowy token w Docker Hubie i użyłam go jako identyfikator (sekcja Credentials w Jenkinsie) w celu umożliwienia Jenkinsowi dostępu
do moich obrazów Dockera, w sposób bezpieczniejszy niżeli bezpośrednie podawanie haseł:

![40](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/dockerhub.jpg)

![41](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/credential.jpg)

Kolejno, stworzyłam projekt typu pipeline:

![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/25.jpg)

Zmiany w sekcji Build Triggers:

![29](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/26.jpg)

Następnie napisałam skrypt Pipeline:

![30](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/27.jpg)

Zawartość pliku **Jenkinsfile**:
```bash
pipeline {
    agent any

    stages {

        stage('Collect') {
            steps {
                git branch: "main", credentialsId: 'e08d9a39-11d6-4211-b184-d7f62f6bf3e3', url: "https://github.com/weronikaabednarz/spring-petclinic"
                sh 'git config user.email "weronikaabednarz@gmail.com"'
                sh 'git config user.name "weronikaabednarz"'
            }
        }

        stage('Build') {
            steps {
                script {
                    try {
                        docker.build("spring-builder", "-f dockerfile_builder .")
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Błąd w trakcie budowania obrazu Docker: ${e.message}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    try {
                        docker.build("spring-tester", "-f dockerfile_tester .")
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Błąd w trakcie testowania obrazu Docker: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    try {
                        def builder_container = docker.image("spring-builder:latest").run("--detach")
                        def tester_container = docker.image("spring-tester:latest").run("--detach")
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Błąd w trakcie deployu: ${e.message}"
                    }
                }
            }
        }
        
        stage('Publish') {
            steps {
                echo "Publish stage"
                sh '''
                ls -l   # List files in the current directory for debugging purposes
                
                # Generate or copy log files to the current directory
                echo "Log content" > builder_log.txt
                echo "Log content" > tester_log.txt
                
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz builder_log.txt tester_log.txt 
                '''
            } 
        }
    }
    
   post {
        always {
            echo "Archiving artifacts"
    
            archiveArtifacts artifacts: 'artifact_*.tar.gz', fingerprint: true
            sh '''
            docker container stop $(docker ps -a -q)
            docker container rm $(docker ps -a -q)
            '''
        }
    }
}
```

Opisy dla każdego etapu skryptu:
- **Collect**
Ten etap pobiera kod źródłowy z repozytorium Git, ustawiając gałąź na "main" i korzystając z poświadczeń do uwierzytelnienia. Następnie konfiguruje nazwę użytkownika i adres e-mail dla repozytorium.

- **Build**
W tym etapie budowane są obrazy Docker, bazujące na obrazach zawierających dependencje, o nazwach "spring-builder" i "spring-tester" z wykorzystaniem odpowiednich plików Dockerfile (ich instrukcje instrukcje zdefiniowane są w plikach"dockerfile_builder" i "dockerfile_tester"). W przypadku wystąpienia błędu podczas budowania któregokolwiek z obrazów, Pipeline zostanie oznaczony jako zakończony niepowodzeniem - "FAILURE".

- **Test**
W etapie budowany jest obraz testujący "spring-tester" przy użyciu kontenera Buildera. Testy są wykonywane w kontenerze Tester. Ten etap polega na testowaniu obrazów Docker, które zostały zbudowane w poprzednim kroku. W przypadku niepowodzenia testów, Pipeline zostanie oznaczony jako zakończony niepowodzeniem - "FAILURE".

- **Deploy**
Uruchamia kontenery Docker na podstawie zbudowanych obrazów docelowych ("spring-builder:latest" i "spring-tester:latest"). Jeśli wystąpi błąd podczas wdrażania, ustawia wynik całego budowania na "FAILURE".

**Dyskusja dotycząca Wdrożenia**
1. Pakowanie do przenośnego pliku-formatu: 
Rozważając przenośność i łatwość wdrożenia aplikacji, warto rozważyć pakowanie do formatu ZIP lub JAR. Oba formaty są łatwe w użyciu i szeroko akceptowane przez różne platformy.
2. Dystrybucja jako obraz Docker: 
Rozważając izolację i spójność środowiska aplikacji, dystrybucja jako obraz Docker może być korzystna. Obraz Docker pozwala na przenośność aplikacji między różnymi środowiskami i zapewnia jednolite warunki uruchomienia.
3. Zawartość obrazu Docker: 
Obraz Docker powinien zawierać tylko to, co jest niezbędne do uruchomienia aplikacji, tj. kod aplikacji oraz jej zależności. Repozytorium, logi i artefakty z builda nie są konieczne w obrazie Docker, ponieważ te informacje mogą być przechowywane i zarządzane w inny sposób.

Proces wdrożenia docelowego zależy od kontekstu aplikacji. Program może zostać "zapakowany" do przenośnego pliku-formatu, takiego jak JAR lub ZIP, lub jako obraz Docker.
Jednakże, aby zachować elastyczność, warto uwzględnić to, które formaty będą łatwiejsze do wdrożenia w jakich środowiskach.

Proces deployu powinien obejmować uruchomienie aplikacji na kontenerze docelowym oraz ewentualne dodatkowe konfiguracje.
Jeśli kontener buildowy i docelowy są takie same, proces deployu może być uproszczony poprzez pominięcie etapu deployu i przejście od razu do publikacji.

Szczegółowy opis procesu **Deploy**:
1. Stworzenie kontenerów docelowych: W tym kroku, po poprawnym zbudowaniu obrazów Docker w etapach Build i Test, uruchamiam moje skrypty, aby tworzyć kontenery docelowe na podstawie tych obrazów. Wykorzystuję docker.image().run("--detach"), aby stworzyć nowe kontenery na podstawie obrazów "spring-builder:latest" i "spring-tester:latest".
2. Uruchomienie aplikacji w kontenerach: Po utworzeniu kontenerów, uruchamiam moją aplikację w tych kontenerach docelowych.
3. Obsługa ewentualnych błędów: Jeśli wystąpią błędy podczas procesu deployu, np. problemy z uruchomieniem kontenerów, cały proces zostanie zakończony niepowodzeniem. Rejestruję i wyświetlam informacje o błędach w konsoli Jenkins, a także przekazuję je do odpowiedniego etapu w postaci komunikatu "Błąd w trakcie deployu: ${e.message}".
4. Ostateczne czyszczenie: Po zakończeniu procesu deployu, wykonuję ostateczne czyszczenie, zatrzymując i usuwając wszystkie kontenery Docker, które zostały uruchomione w procesie deployu. Jest to ważne z punktu widzenia zarządzania zasobami i utrzymania czystego środowiska Docker.

- **Publish**
Publikuje etap, wykonując operacje związane z publikacją, takie jak generowanie lub kopiowanie plików dzienników (dzienniki są rejestrowane do plików builder_log.txt i tester_log.txt) do bieżącego katalogu. Następnie archiwizuje te pliki dzienników w pliku tar z timestampem - generowany jest wersjonowany artefakt. Artefakt jest dodawany jako pobieralny obiekt do rezultatów przejścia pipeline'u Jenkins.

- **Post**
W bloku post zawsze zostanie wykonany kod, niezależnie od wyniku poprzednich kroków. Tutaj archiwizuje się artefakty (pliki tar z dziennikami) i zatrzymuje oraz usuwa się wszystkie kontenery Docker, aby oczyścić środowisko.

W trakcie uruchomienia skryptu w etapie **Deploy** oraz **Publish** napotkałam problem z brakiem pamięci na ponowne próby poprawnego zbudowania Pipeline'a.
Rozwiązaniem było zwiększenie rozmiaru pamięci przydzielonej dla wirtualnej maszyny w ustawieniach systemu, a także znalezienie wcześniej stworzonych błędnych operacji
w odpowiadającej im lokalizacji i usunięcie ich.

### 6. Uruchomiłam utworzony **Pipeline**:
![31](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/28.jpg)

Logi konsoli po uruchomieniu skryptu zakończone sukcesem:

![32](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/29a.jpg)

![33](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/29b.jpg)

Logi wyciągnięte po procesie:

![42](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/31cd.jpg)

Dodałam Jenkinsfile do sforkowanego repozytorium:

![36](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/36.jpg)

Skonfigurowałam trigger, w taki sposób aby budował pipeline automatycznie kiedy w repozytorium zarejestrowana zostanie modyfikacja - commit do gałęzi **main**:

![37](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/32.jpg)

Wprowadziłam przykładową zmianę do skforkowanego repozytorium, a następnie wykonałam commit:

![38](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/33.jpg)

Wynik automatycznego budowania projektu **pipeline_project**:

![39](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie3/images/34.jpg)

## Laboratorium 6 - Lista kontrolna
### W ramach zadania z pipelinem CI/CD z poprzedniego laboratorium, ścieżką krytyczną wykonanego przeze mnie pipeline'u jest:

✔️ commit i manual trigger @ Jenkins

✔️ clone

✔️ build

✔️ test

✔️ deploy

✔️ publish


Pełna lista kontrolna została przeprowadzona w trakcie przebiegu sprawozdania. Podsumowanie:

✔️ Aplikacja została wybrana

✔️ Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania

✔️ Wybrany program buduje się

✔️ Przechodzą dołączone do niego testy

✔️ Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium

✔️ Stworzono diagram UML zawierający planowany pomysł na proces CI/CD

✔️ Wybrano kontener bazowy lub stworzono odpowiedni kontener wstepny (runtime dependencies)

✔️ Build został wykonany wewnątrz kontenera

✔️ Testy zostały wykonane wewnątrz kontenera

✔️ Kontener testowy jest oparty o kontener build

✔️ Logi z procesu są odkładane jako numerowany artefakt

✔️ Zdefiniowano kontener 'deploy' służący zbudowanej aplikacji do pracy

✔️ Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego

✔️ Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera

✔️ Następuje weryfikacja, że aplikacja pracuje poprawnie (smoke test)

✔️ Zdefiniowano, jaki element ma być publikowany jako artefakt

✔️ Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB

✔️ Opisano proces wersjonowania artefaktu (można użyć semantic versioning)

✔️ Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie

✔️ Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu

✔️ Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki

✔️ Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem

✔️ Sprawozdanie pozwala zidentyfikować cel podjętych kroków

✔️ Forma sprawozdania umożliwia wykonanie opisanych kroków w jednoznaczny sposób

## Laboratorium 7 - Summary
### Ścieżka krytyczna Jenkinsfile:
✔️  Przepis dostarczany z SCM

✔️  Etap Build dysponuje repozytorium i plikami Dockerfile

✔️  Etap Build tworzy obraz buildowy, np. BLDR

✔️  Etap Build (krok w etapie) lub oddzielny etap (o innej nazwie)

✔️  Etap Test przeprowadza testy

✔️  Etap Deploy przygotowuje obraz lub artefakt pod wdrożenie

✔️  Etap Deploy przeprowadza wdrożenie 

✔️  Etap Publish wysyła obraz docelowy i dodaje artefakt do historii builda

Czy "na końcu rurociągu" powstaje możliwy do wdrożenia artefakt (deployable) - proces jest skuteczny?

Tworzony jest artefakt w postaci pliku tar.gz, który zawiera logi z budowania i testowania aplikacji. Artefakt jest archiwizowany i dostępny do pobrania, co oznacza, że jest możliwy do wdrożenia.

Czy opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze bez modyfikacji (acz potencjalnie z szeregiem wymaganych parametrów, jak obraz DIND)?

Tak, opublikowane obrazy mogą być pobrane z rejestru i uruchomione w Dockerze bez konieczności modyfikacji, jeśli wszystkie etapy przebiegną pomyślnie.

Czy dołączony do jenkinsowego przejścia artefakt, gdy pobrany, ma szansę zadziałać od razu na maszynie o oczekiwanej konfiguracji docelowej?

Tak, jeśli proces przebiegnie pomyślnie, a artefakt zostanie poprawnie zbudowany i wdrożony, istnieje szansa, że po pobraniu i uruchomieniu na maszynie o oczekiwanej konfiguracji docelowej, aplikacja będzie działać poprawnie. Jednakże, zawsze istnieje ryzyko, że mogą wystąpić problemy zgodności z konfiguracją środowiska docelowego, które mogą wymagać dodatkowej konfiguracji lub poprawek. Dlatego też ważne jest, aby przetestować aplikację na docelowym środowisku i dostosować ją w razie potrzeby.

### Dodałam sprawozdanie, zrzuty ekranu oraz listing historii poleceń i niezbędne pliki.
Wykorzystane polecenia:

git add .

git commit -m "WB410023 sprawozdanie, screenshoty, listing oraz pliki"

git push origin WB410023

### Wystawiłam Pull Request do gałęzi grupowej.
