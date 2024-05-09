# Sprawozdanie 3
Szymon Krzykwa
Inżynieria Obliczeniowa gr 2

## Cel laboratorium

Celem tych laboratoriów było zapoznanie się z Jenkisnem oraz jego wykorzystaniem.

## Wykonanie

### 1. Przygotowanie

Przed przystąpieniem do główmej części ćwiczenia należało uzyskać dostęp do Jenkinsa. Dokonywaliśmy tego poprzez wpisanie hasła administratora z kontenera Jenkinsa. Przy pomocy:

docker exec -it <id kontenera z Jenkinsem> cat /var/jenkins_home/secrets/initialAdminPassword

na ekranie terminala pokazuje nam się wymagane hasło, ktore następnie należy wprowadzić i przechodzimy do konfiguracji użytkownika. Po wszystkim na ekranie powinno pokaza nam się głowne menu Jenkinsa. 

![](./screeny/jenkins.png)

### 2. Pierwsze uruchomienie

Na początek zostaliśmy poproszeniu o utworzenie dwóch prostych projektów, które miały nas zaznajomić z działaniem wewnątrz Jenkinsa. Jako pierwszy stworzyliśmy projekt uname, który miał na celu wyświetlenie informacji o używanym przez nas systemie. W konfiguracji projektu podaliśmy jedynie jedną linijkę kodu:

    uname -a

Po jego uruchomieniu w logach konsoli otrzymaliśmy wypis:

![](./screeny/uname.png)

Drugim z wymaganych projektów było napisanie kodu, który w przypadku występowania godziny nieparzystej zwracał błąd. Kod dla tego problemu prezentował się następująco:

    #!/bin/bash
    current_hour=$(date +%H)

    if [ $((current_hour % 2)) -eq 1 ]; then
        echo "Error: Current hour is odd"
        exit 1
    else
        echo "Current hour is even"
    fi

Wypis z konsoli:

![](./screeny/czas.png)

Po wykonananiu powyższych projektów przeszlismy do wykonania "prawdziwego" projektu, który klonuje nasze repozytorium, przechodzi na dedykowaną gałąź i wykonuje builda naszej aplikacji. W konfiguracji projektu w zakładce repozytorium podałem wszystkie odpowiednie informacje:

![](./screeny/git.png)

Następnie w powłoce wykonałem przejście do odpwiedniego katalogu i zbudowałem obraz.

    cd INO/GCL2/SK412907/Sprawozdanie2
    docker build -f node-builder.Dockerfile .

Końcówka wypisu z konsoli potwierdzająca porpawne wykonanie zadania:

![](./screeny/git-konsola.png)

### 3. Część główna - Pipeline

#### Diagramy UML, opisujące proces CI.

Poproszono nas o wykonanie diagramów UML. Pierwszym z nich jest diagram czynności, który pokazuje przebieg działania naszego pipeline'u i co powinno zajść na każdym etapie jego wykonywania. Drugim jest diagram wdrożenia przedstawiający strukturę oraz relacje pomiędzy poszczególnymi elementami.

Diagram czynności:

Diagram wdrożenia:

#### Pipeline

Pipeline składa się z pięciu główych części, które teraz będę po koleji opisywał. Zanim jednak do tego przejdę należy wspomnieć o dyrektywie agent oraz zmiennej środowiskowej CREDS. Znajdują się one na samym początku naszego pipeline'a i odpowiadają kolejna za powiadomienie pipeline'u o tym, że może skorzystać z dowolnego wolnego agenta oraz przypisanie credential'i pochodzących z DockerHub'a do zmiennej, która będzie wykorzystywana na późniejszym etapie.

    agent any
    environment {
        CREDS=credentials('szk-dockerhub')
    }

##### Steps

Etap 'Clone' odpowiada za przygotowanie naszego projektu. Na początku sprawdzamy czy klonowane repozytorium zostało już wcześniej skopiowane. Jeśli tak usuwamy poprzedni katalog. Następnie przechodzimy do klonowania. Dodatkowo na tym etapie utowrzyłem już sieć, która będzie używana do końca pipeline'u. Na koniec przechodzę do swojej gałęzi i na tym kończy się pierwszy etap.

    stage('Clone') {
                    steps {
                        script {
                            sh "rm -rf MDO2024_INO || true"
                            sh "git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git MDO2024_INO"
                            sh "docker network create node || true"
                            dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2") {
                                sh "git checkout SK412907"
                            }
                        }
                    }
                }

Drugi etap to 'Build'. Składa się on jedynie z utworzenia obrazu na podstawie Dockerfile'a znajdującego się wewnątrz repozytorium. Ważne jest, aby podać dokładną ścieżkę gdzie znajduje się ten plik.

    stage('Build') {
                    steps {
                        dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                            sh "docker build -t node-builder -f ./node-builder.Dockerfile ."
                        }
                    }
                }

Następnie mamy 'Test', który wykonuje testy przypisane dla danej aplikacji. Podobnie jak w poprzednim etapie podajemy ścieżkę gdzie znajduje się Dockerfile'a. 

    stage('Test') {
                    steps {
                        dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                            sh "docker build -t node-test -f ./node-test.Dockerfile ."
                        } 
                    }
                }

'Deploy' uruchamia naszą aplikację. Najpierw buduje obraz opraty na pliku Dockerfile, a następnie sprawdza czy istnieje kontener oparty na własnie utworzonym obrazie. Tworzymy kontener na podstawie stworzonego obrazu, przypisujemy go do wcześniej stworzonej sieci i popinamy pod port 3000 na naszej maszynie i do portu 3000 naszego kontenera.

    stage('Deploy') {
                steps {
                    dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                        sh "docker build -t szkrzykwa/node-jenkins -f ./node-deploy.Dockerfile ."
                        sh "docker rm -f node-jenkins || true "
                        sh "docker run --name node-jenkins --rm -d -p 3000:3000 --network=node szkrzykwa/node-jenkins"
                    }
                }
            }

Na koniec mamy etap 'Publish', który odpowiada za wysłanie "publikacje" naszych wyczynów. Najpierw sprawdzamy czy istnieje obraz curlimages/curl i w przypadku już jego istnienia usuwamy go. Następnie przechodzimy do zmiennej response, która będzie zawierać wynik żądania HTTP wykonywanego przez kontener. Podany jako wartość kod uruchamia kontener przy pomocy obrazu curlimages/curl:latest, przypisuje go do sieci node i wykonuje żądanie HTTP GET pod adresem http://node-jenkins:3000. Następnie sprawdzane jest czy w zmiennej response znajduje się zapis "To Do App" (jest to pierwsza linijka z zapisu html mojej aplikacji). Jeśli jest to prawda wykorzystuję zmienną CREDS z początku Pipeline'a i wykonuje push mojego obrazu na DockerHuba. 

    stage('Publish') {
                steps {
                    sh "docker rmi curlimages/curl || true"
                    script {
                        def response = sh script: "docker run --network=node --rm curlimages/curl:latest -L -v http://node-jenkins:3000", returnStdout: true
                        if (response.contains("To Do App")) {
                                
                                sh "echo $CREDS_PSW | docker login -u szkrzykwa --password-stdin" 
                    
                            sh 'docker push szkrzykwa/node-jenkins'
                        } else {
                            error "Response does not contain To Do App!"
                        }
                    }
                }
            }

Na koniec mamy część końcową naszego pipeline'u, która odpowiada za wylogowanie nas z Docker'a:

    post {
            always {
                sh "docker logout"
            }
        }

Cały Pipeline:

    pipeline {
        agent any
        environment {
            CREDS=credentials('szk-dockerhub')
        }
        stages {
            stage('Clone') {
                steps {
                    script {
                        sh "rm -rf MDO2024_INO || true"
                        sh "git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git MDO2024_INO"
                        sh "docker network create node || true"
                        dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2") {
                            sh "git checkout SK412907"
                        }
                    }
                }
            }
            stage('Build') {
                steps {
                    dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                        sh "docker build -t node-builder -f ./node-builder.Dockerfile ."
                    }
                }
            }
            stage('Test') {
                steps {
                    dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                        sh "docker build -t node-test -f ./node-test.Dockerfile ."
                    } 
                }
            }
            stage('Deploy') {
                steps {
                    dir ("MDO2024_INO/INO/GCL2/SK412907/Sprawozdanie2"){
                        sh "docker build -t szkrzykwa/node-jenkins -f ./node-deploy.Dockerfile ."
                        sh "docker rm -f node-jenkins || true "
                        sh "docker run --name node-jenkins --rm -d -p 3000:3000 --network=node szkrzykwa/node-jenkins"
                    }
                }
            }
            stage('Publish') {
                steps {
                    sh "docker rmi curlimages/curl || true"
                    script {
                        def response = sh script: "docker run --network=node --rm curlimages/curl:latest -L -v http://node-jenkins:3000", returnStdout: true
                        if (response.contains("To Do App")) {
                                
                                sh "echo $CREDS_PSW | docker login -u szkrzykwa --password-stdin" 
                    
                            sh 'docker push szkrzykwa/node-jenkins'
                        } else {
                            error "Response does not contain To Do App!"
                        }
                    }
                }
            }
        }
        post {
            always {
                sh "docker logout"
            }
        }
    }

Uruchamiamy nasz Pipeline z nadzieją, że wszystkie etapy zakończą się pomyślnie, a wygląda to tak:

![](./screeny/pipeline.png)

Końcówka logów konsoli:

![](./screeny/zwyciestwo.png)

Wchodząc teraz na mój profil na DockerHub'ie można zauważyć wykonany przeze mnie obraz:

![](./screeny/dockerhub.png)

### 4. "Definition of Done"

Na koniec zostały nam zadane dwa pytania dotyczące stworoznego przez nas obrazu.
