# Sprawozdanie 3 - Konrad Rezler
## Pipeline, Jenkins, izolacja etapów
### Wstęp i  opracowanie diagramów

Pipeline to zautomatyzowany proces dostarczania oprogramowania, który obejmuje etapy od tworzenia kodu przez testowanie i budowanie aż po wdrażanie i monitorowanie aplikacji, zapewniając szybkie i powtarzalne wdrożenia przy minimalnym ryzyku błędów. Dzięki pipeline deweloperzy mogą efektywnie integrować, testować i wdrażać zmiany, co przyspiesza cykle dostarczania oprogramowania i poprawia jakość produktu

Jenkins to popularne otwartoźródłowe narzędzie do automatyzacji procesów CI/CD (continuous integration and continuous delivery), umożliwiające tworzenie i zarządzanie pipeline'ami dostarczania oprogramowania poprzez integrację z różnymi narzędziami deweloperskimi i środowiskami chmurowymi, co pomaga zautomatyzować budowanie, testowanie i wdrażanie aplikacji. Dzięki swojej elastyczności i ogromnej społeczności użytkowników Jenkins jest powszechnie wykorzystywany do ułatwienia iteracyjnego procesu dostarczania oprogramowania i przyspieszenia cykli wdrożeń.

Wybór repozytorium dla którego nastąpiła izolacja procesów padł na wykorzystywane we wcześniejszych zajęciach Irssi. Wspomniana aplikacja zawiera licencję "GNU GENERAL PUBLIC LICENSE Version 2, June 1991" potwierdzającą możliwość swobodnego obrotu kodem.

Na potrzeby wizualizacji wykonanych przeze mnie działań wykonałem następujące diagramy:
- Diagram wdrożenia:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/Diagram wdrożenia.png">
</p>

- Diagram komunikacji:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/Diagram komunikacji.png">
</p>

### Przygotowanie
Korzystając z dockerfiles stworzonych na poprzednich zajęciach upewniłem się, że na pewno działają kontenery budujące i testujące:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/0.1. Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach.png">
</p>

<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/0.2. Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach.png">
</p>

Następnie korzystając z instrukcji zamieszczonej w dokumentacji Jenkinsa uruchomiłem obraz dockera eksponujący środowisko zagnieżdzone:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/1. Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone.png">
</p>

Korzystając z kontenera wykonanego w ramach poprzedniego sprawozdania uruchomiłem `Blueocean`, czyli zestaw wtyczek dla Jenkinsa, które oferują nowoczesny interfejs użytkownika zorientowany na zadania, wizualizację pipeline'ów oraz dodatkowe narzędzia do zarządzania procesem CI/CD. Jest to bardziej intuicyjne i przyjazne dla użytkownika narzędzie w porównaniu z podstawowym interfejsem Jenkinsa. Obraz Jenkinsa to natomiast podstawowa instalacja Jenkinsa dostępna w formie gotowego do użycia obrazu, który można uruchomić na kontenerze Docker lub serwerze.
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/3. Uruchom Blueocean.png">
</p>

### Uruchomienie
W celu realizacji zajęć utworzyłem moje dwa pierwsze proste projekty:
- Pierwszy projekt wyświetla uname
  - polecenie projektu:
    ```
     uname -a
    ```
  - wyświetlany rezultat:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/5. uruchomienie projektu.png">
</p>

- Drugi projekt w zależności od tego czy godzina jest parzysta lub nieparzysta zwraca odpowiedni wynik
  - polecenie projektu:
    ```
    #!/bin/bash
    godzina=$(date +%H)
    echo $godzina
    if ((godzina % 2 != 0)); then
	    echo "Błąd, niepatrzysta godzina"
     exit 1
    else 
	   echo "parzysta godzina"
     exit 0
    fi
    ```
  - wyświetlane rezultaty dla godziny parzystej i nieparzystej:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/7.1. Zwrócenie sukcesu bo godzina parzysta.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/7.2. Zwrócenie niesukcesu bo godzina nieparzysta.png">
</p>

Następnie przeszedłem do utworzenia "prawdziwego projektu", który: 
- klonuje nasze repozytorium
- przechodzi na osobistą gałąź
- buduje obrazy z dockerfiles.

Aby móc korzystać z wybranego przeze mnie repozytorium dodałem do projektu odpowiedni credential, w którym zamieściłem jako hasło github token, by móc swobodnie łączyć się z repozytorium
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/8. Dodawanie credentiali do prawdziwego projektu.png">
</p>
Następnie zamieściłem link do repozytorium i określiłem branch:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/9. Ustawienie brancha na projekcie.png">
</p>
Realizowane polecenie umożliwia budowe obrazów stworzonych w ramach poprzednich zajęć i prezentuje się następująco:

```
cd ITE/GCL4/KR409837/Sprawozdanie2/Dockerfiles/irssi
docker build -t fedora-build-image -f ./build/Dockerfile .
```

Dzięki powyższym krokom uzyskałem następujący rezultat:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/10. Buduje obrazy z dockefiles.png">
</p>

### Prawdziwy "prawdziwy projekt"
W dalszej części zajęć przeszedłem do stworzenia kolejnego projektu, w którym stworzyłem Pipeline. Jednakże przed przystąpieniem do tego wykonałem jeszcze kilka innych kroków począwszy od utworzenia forka na wybranym przeze mnie repozytorium, aby móc wykonać build:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/11. W celu zrobienia builda forkuje repo .png">
</p>
oraz sklonowałem na swoją maszynę wirtualną repozytorium do którego ręcznie przekopiowałem foldery zawierające plik Dokcefile odpowiadający za build lub test
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/12. klonuje repo .png">
</p>

Aby móc swobodnie pullować pobrałem w Jenkinsie credentialsId:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie3/images/14. pobranie credentialsid.png">
</p>

oraz na przyszłość utworzyłem w folderze z projektem plik `cleanup.sh`, służący do zatrzymywania i usuwania wszystkich kontenerów. Jego treść prezentuje się następująco:
```
#!/bin/bash

if [ "$(docker ps -a -q)" ]; then
  docker container stop -f $(docker ps -a -q)
  docker container rm -f $(docker ps -a -q)
fi
```
Następnie utworzyłym plik 'Jenkinsfile', którego ostateczna treść jest następująca: 
```
pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Pull') {
            steps {
                echo "Pullowanie repo"
                git branch: 'master', credentialsId: 'bfd3d51b-874c-4e9b-b867-26d457d62113', url: 'https://github.com/krezler21/irssi'
            }
        }
        
        stage('Build') {
            steps {
                echo "Budowa projektu"
                sh '''
                    docker build -t irssi-build:latest -f ./budowa/Dockerfile .

                    docker run --name build_container irssi-build:latest

                    docker cp build_container:/irssi/build ./artifacts
                    docker logs build_container > ./artifacts/log_build.txt
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo "Testowanie projektu"
                sh '''
                    docker build -t irssi-test:latest -f ./test/Dockerfile .

                    docker run --name test_container irssi-test:latest

                    docker logs test_container > ./artifacts/log_test.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploy projektu"
                sh '''
                
                docker build -t irssi-deploy:latest -f ./deploy/Dockerfile .
                docker run -p 3000:3000 -d --rm --name deploy_container irssi-deploy:latest
                '''
            }
        }

        stage('Publish') {
            steps {
                echo "Publikacja projektu"
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz artifacts
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                NUMBER='''+ env.BUILD_NUMBER +'''
                docker tag irssi-deploy:latest krezler21/irssi_fork:latest
                docker push krezler21/irssi_fork:latest
                docker logout

                '''
            } 
        }

    }

     post{
        always{
            echo "Archiving artifacts"

            archiveArtifacts artifacts: 'artifact_*.tar.gz', fingerprint: true
            sh '''
            chmod +x cleanup.sh
            ./cleanup.sh
            '''
        }

     }
}
```
Pragnę teraz przejść do omówienia poszczególnych fragmentów tego pliku:
- `stage Pull` - etap ten jest odpowiedzialny za pobranie repozytorium z systemu kontroli wersji Git. Wykorzystuje on plugin Git w Jenkinsie, aby skonfigurować parametry, takie jak gałąź (master), identyfikator poświadczeń (bfd3d51b-874c-4e9b-b867-26d457d62113), oraz adres URL repozytorium (https://github.com/krezler21/irssi). Następnie wykonuje pull najnowszej wersji kodu źródłowego z gałęzi master z tego repozytorium.
- `stage Build` - etap ten ma za zadanie budowe projektu, uruchamiając polecenia Docker'a w celu zbudowania obrazu oraz kopiowania wygenerowanych artefaktów oraz za zapisywanie logów z działania tego kontenera do pliku "log_build.txt".
- `stage Test` - etap ten jest odpowiedzialny za przeprowadzenie testów projektu oraz za zapisywanie logów z działania tego kontenera do pliku "log_test.txt".
- `stage Deploy` - w celu realizacji tego etapu utworzyłem plik Dockerfile w nowym katalogu "deploy", który zawiera następującą treść:
```
FROM danger89/cmake:latest

COPY ./artifacts/ .

CMD ninja -C ./build
```

