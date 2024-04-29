***Disclaimer***
Sprawozdanie robiłem zdalnie, na wyjeździe. Z jakiegoś powodu Win11 na moim laptopie nie lubi Ubuntu ponieważ:
- VirtualBox nie otworzy spakowanej VM bo nie
- Nie utworzy nowego Ubuntu bo nie
- VMware też nie utworzy nowego Ubuntu bo nie

Dlatego użyłem Fedory 40 i w tym sprawozdaniu komendy mogą się różnić od tych zawartych w poprzednich.

# Sprawozdanie 3

## Instalacja Jenkinsa
Jenkins jest narzędziem do automatyzacji procesów ciągłej integracji (CI), oraz ciągłej dostawy (CD). Pozwala na zdefiniowanie zadań (job'ów), opisujące w jaki sposób zbudować, przetestować, a następnie wdrożyć napisany program. Stworzymy plik Jenkinsfile, będący Pipeline, który można przechowywać wraz z aplikacją jako back-up. Jest wiele opcji instalacji Jenkinsa, ale my wykorzystamy wersję skonteneryzowaną w Dockerze. W tym celu wykorzystam instrukcje z [tej strony](https://www.jenkins.io/doc/book/installing/docker/).

#### Instalacja dind
Najpierw należy utworzyć sieć mostkową w Dockerze, używając komendy:
```
sudo docker network create jenkins
```
Aby móc wykonywać docker'owe komendy w Jenkinsie, należy pobrać i uruchomić obraz 'Docker:dind':

```
docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2
```
#### Instalacja Jenkins
Tworzymy plik Dockerfile z następującą treścią:
```
FROM jenkins/jenkins:2.440.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```
Następnie budujemy go:
```
sudo docker build -t myjenkins-blueocean:2.440.3-1 .
```
Uruchamiamy kontener z Jenkins komendą:
```
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.440.3-1
```

![sc1](scrnshts/1.png)

Wspomniany w komendach i Dockerfile **Blue Ocean** jest pluginem zapewniającym znacznie bardziej przystępne dla użytkownika budowanie pipelinów.

 #### Pierwsze uruchomienie
 Łączymy się z Jenkinsem z zewnątrz maszyny wirtualnej wchodząc na [localhost:8080](http://localhost:8080/). Wita nas ekran proszący o hasło administratora:

 ![sc2](scrnshts/2.png)

Ponieważ Jenkins został uruchomiony w kontenerze, nie znajduje się w podanej ścieżce (która nie istnieje), a w logach swojego kontenera. Jest ono tam wyszczególnione, oraz łatwe do znalezienia. Należy użyć:
```
sudo docker logs <containerId>
```
Po wklejeniu hasła, użytkownik zostaje zapytany o doinstalowanie wtyczek, rozszerzające funkcjonalność Jenkinsa. Jako niedoświadczony użytkownik, wybrałem wyróżnioną opcję "Zainstaluj sugerowane wtyczki"

![sc3](scrnshts/3.png)

Po zainstalowaniu wtyczek, można utworzyć pierwszego administratora. Jest to krok który można pominąć, korzystając z opcji "Kontynuuj jako administrator".

![sc4](scrnshts/4.png)

Finalną opcją konfiguracyjną jest customowy URL Jenkinsa. Ja zostawiłem go tak jak jest.

### Tworzenie Pipeline

Po zakończeniu konfiguracji, zostajemy powitani przez stronę startową w pięknym ponglishu (będzie go więcej). Tworzymy pierwszego job'a typu *Pipeline*.

![sc5](scrnshts/5.png)

Jest wiele opcji konfiguracyjnych, których szczegóły można wyświetlić klikając pytajnik obok nich. Mnie interesuje tylko okienko skryptu, znajdujące się na samym dole strony. Na sam początek przeniosłem build oraz test do pipeline, wykorzystując prosty skrypy w języku Groovy. Pierwszy krok polega na sklonowaniu przedmiotowego repozytorium, a dokładniej mojej gałęzi. Ponieważ wybrałem **Irssi**, wykorzystam utworzone wcześniej pliki Dockerfile. W następnych krokach zdefiniowałem build oraz test.
```
pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: 'AP412695', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'    
            }
        }
        stage('Build') {
            steps {
                dir('AP412695/Sprawozdanie2') {
                    sh 'docker build -t irssi-builder -f ./irssi-builder.Dockerfile .'
                }
            }
        }
        stage('Test'){
            steps{
                dir('AP412695/Sprawozdanie2'){
                    sh 'docker build -t irssi-test -f irssi-tester.Dockerfile .'
                }
            }
        }
    }
}
```

![sc6](scrnshts/6.png)

~~Piękno mobilnego internetu~~

 #### Deploy i publish

Do tego momentu pipeline implementuje kroki build i test. Teraz należy przeprowadzić deploy, czyli uruchomienie aplikacji w kontenerze docelowym. Postanowiłem do tego wykorzystać menadżer pakietów **dnf**, używany na systemach takich jak Fedora czy CentOS, oraz istniejący tam system instalacji, deinstalacji i zarządzania pakietami **rpm**. RPM instaluje, za zgodą użytkownika, wszystkie potrzebne dependencje do uruchomienia programu zawartego w danym pakiecie. Jest to bardzo wygodny i w pełni zautomatyzowany proces, idealny dla użytkownika końcowego, czyli klienta. Jest kilka sposobów utworzenia pakietu **.rpm**. Moim pierwszym pomysłem było wykorzystanie skompilowanych już plików binarnych z poprzednich kroków, jednakże finalna operacja *ninja install* nadal potrzebowała wszystkich developerskich bibliotek, więc postanowiłem zmienić podejście. cp