# Sprawozdanie 03
# IT 412497 Daniel Per
---

## Pipeline, Jenkins, izolacja etapów
## Pipeline: lista kontrolna
## Jenkinsfile: lista kontrolna
---
Celem tych ćwiczeń było zapoznanie się z Jenkins'em i zbudownie dzięki niemu pipeline'u dla naszego programu.

---

## Wykonane zadanie - Lab 005-007
---

### Przygotowanie
* Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach
* Zapoznaj się z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/
  * Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone
  * Przygotuj obraz blueocean na podstawie obrazu Jenkinsa (czym się różnią?)
  * Uruchom Blueocean

Podpunkty instalacji Jenkinsa wykonujemy wprost z instrukcji instalacji, tzn. kolejno:

Tworzymy sieć mostkowaną w dockerze dla naszego Jenkinsa
```
docker network create jenkins
```

Pobieramy i uruchamiany DIND (Docker in Docker):
```
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```

Tworzymy obraz dla naszego Jenkins'a wraz z BlueOcean (interfejsem graficznym ułatwiającym prace z pipeline'ami),
tworząc dla niego Dockerfile'a:
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

I uruchamiając go, aby się zbudował:
```
docker build -t myjenkins-blueocean:2.440.3-1 .
```

Na koniec uruchamiamy nasz kontener z BlueOcean:
```
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.440.3-1
```

  * Zaloguj się i skonfiguruj Jenkins

Gdy nasz kontener z Jenkins'em jest uruchomiony możemy korzystać z Jenkins'a z poziomu naszego Windows'a. Przechodzimy pod adres `127.0.0.1:8080` lub `localhost:8080`. Przy pierwszym logowaniu przywita nas monit o wpisanie hasła wygenerowanego przez Jenkins'a w celach bezpieczeństwa, czy to my jesteśmy jego administratorem.
> Korzystamy z adresu localhosta dzięki przekierowaniu portu 8080 z naszej maszyny virtualnej

![ss](./ss/ss01.png)

Haslo do jenkinsa dostajemy z podanej ścieżki z pomocą komendy `cat`:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Gdy hasło będzie się zgadzać pobieramy zalecany wtyczki.

![ss](./ss/ss02.png)

Następnie możemy utworzyć profil naszego pierwszego użytkownika (admina) i się zalogować.
Teraz nasz Jenkins jest gotowy do działania.

![ss](./ss/ss03.png)


  * Zadbaj o archiwizację i zabezpieczenie logów
Powyższe instrukcje instalacji pokryły zabezpieczenie wszystkiego w odpowiednich wolumach.
  
### Uruchomienie 
* Konfiguracja wstępna i pierwsze uruchomienie
  * Utwórz projekt, który wyświetla uname
Tworzymy nowy projekt, nadajemy mu dowolną nazwę i wybieramy 'Ogólny projekt'

![ss](./ss/ss04.png)

W konfiguracji wybieramy zwykły skrypt i wpisujemy proste polecenia dla testu czy wszystko działa:

```
whoami
pwd
uname -a
hostname
env
docker images
docker pull fedora
```
> whoami: Wyświetla nazwę aktualnie zalogowanego użytkownika. \
pwd: Pokazuje obecną ścieżkę (pełną nazwę katalogu) w systemie plików. \
uname -a: Zwraca informacje o systemie. \
hostname: Wyświetla nazwę hosta systemu. \
env: Pokazuje zmienne środowiskowe systemu. \
docker images: Wyświetla listę obrazów Dockera dostępnych na lokalnej maszynie. \
docker pull fedora: Pobiera obraz systemu Fedora.

Zapisujemy i uruchamiamy nasz projekt. W trakcie działania i po jego ukończeniu możemy zajrzeć w logi aby zobaczyć co się aktualnie dzieje / co zostało już wykonane.

![ss](./ss/ss05.png)
![ss](./ss/ss06.png)

  * Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta
> Pierwszy projekt sprawdził poprawne działanie skryptów w Jenkins'ie

* Utwórz "prawdziwy" projekt, który:
  * klonuje nasze repozytorium
  * przechodzi na osobistą gałąź
  * buduje obrazy z dockerfiles i/lub komponuje via docker-composed

Tworzymy nowy projekt, tym razem typu 'pipeline'. Ponownie przechodzimy do skryptu, gdzie możemy skorzystać z przykładowego skryptu, który wygląda tak:
```
pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```
> Prosto pokazuje nam schemat w jaki należy pisać skrypt dla pipelinu w oddzielnych krokach.

Nasz krok 'Hello' możemy zamienić na 'Prepare', w którym to pobierzemy nasze repo i przejdziemy na osobistą gałąź. 

```
pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                sh 'rm -rf MDO2024_INO'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
                dir("MDO2024_INO"){
                    sh 'git checkout DP412497'
                }
            }
        }
    }
}
```
> rm -rf MDO2024_INO - służy do usunięcia katalogu jeśli taki już istnieje, aby zapobiec błędom gdy skrypt spróbuje pobrać repozytorium. \
sh 'komenda' - wywołanie komendy
dir("..."){...} - działania w danym katalogu

Następnie dodajemy krok odpowiedzialny za budowanie.

```
        stage('Build') {
            steps {
                echo 'Building'
                sh 'docker rmi irssi-builder'
                dir('MDO2024_INO/ITE/GCL4/DP412497/Sprawozdanie2'){
                    sh 'docker build -t irssi-builder -f irssi-builder.Dockerfile .'
                }
            }
        }
```
> Zadaniem jest usunięcie obrazu, aby mógł się od nowa zbudować oraz uruchomienie naszego Dockerfile'a budującego znajdującego się w naszym repo.

Następny krok będzie dla testowania. Jest analogiczny do poprzedniego z budowaniem:
```
        stage('Test') {
            steps {
                echo 'Testing'
                dir('MDO2024_INO/ITE/GCL4/DP412497/Sprawozdanie2'){
                    sh 'docker build -f irssi-tstr.Dockerfile .'
                }
            }
        }
```

Gdy wszystko jest gotowe

![ss](./ss/ss07.png)
![ss](./ss/ss08.png)
![ss](./ss/ss09.png)

  
### Pipeline
#### Build & Test
* Definiuj pipeline korzystający z kontenerów celem realizacji kroków `build -> test`
* Może, ale nie musi, budować się na dedykowanym DIND, ale może się to dziać od razu na kontenerze CI. Należy udokumentować funkcjonalną różnicę między niniejszymi podejściami
* Docelowo, `Jenkinsfile` definiujący *pipeline* powinien być umieszczony w repozytorium. Optymalnie: w *sforkowanym* repozytorium wybranego oprogramowania

Wcześniej przygotowaliśmy pipeline dla `build -> test`.
Teraz możemy przygotować plik Jenkinsfile, w którym po prostu wkleimy cały wcześniej napisany skrypt i tu go będziemy modyfikować.
Abyśmy mogli korzystać z naszego Jenkinsfile'a musimy konfigurować nasz projekt i zamienić okno skrypty na czytanie skryptu z pliku.
Wybieramy opcję `git` i uzupełniamy repo, branch'a oraz ścieżkę do pliku Jenkinsfile odpowiadającą naszemu ustawieniu

![ss](./ss/ss10.png)

Następnie ponownie uruchamiamy, aby sprawdzić czy nasz Jenkinsfile się wczytuje i wszystko działa.

![ss](./ss/ss11.png)


#### Publish
Kolejnym krokiem jest Deploy, ale w nim chcemy sprawdzić naszą aplikację, którą budujemy w kroku `Publish`, dlatego ten krok wykonamy najpierw.
W tym kroku chcemy stworzyć instalator naszego programu. Na naszy systemie fedora będzie to `rpm`. Z pomocą przychodzi nam RPM Packaging Guide z `https://rpm-packaging-guide.github.io`.
Szczegółowo opisuje wszystko krok po kroku jak stworzyć naszego `rpm`.
Bazując na tym tworzymy Dockerfile'a dla kroku publish:
```
FROM irssi-builder

RUN  dnf install -y gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools

WORKDIR /

RUN rpmdev-setuptree
RUN tar -cvzf irssi.tar.gz irssi
RUN cp irssi.tar.gz /root/rpmbuild/SOURCES/

WORKDIR /root/rpmbuild/SPECS

COPY ./irssi.spec .

RUN rpmbuild -bs irssi.spec
RUN rpmlint irssi.spec
RUN rpmlint ../SRPMS/irssi-fc39.src.rpm
RUN mkdir -p /source_rpm
RUN mv /root/rpmbuild/SRPMS/irssi-fc39.src.rpm /source_rpm
```

Oraz plik typu Spec:


#### Wymagane składniki
  * `Deploy`
    *  Krok uruchamiający aplikację na kontenerze docelowym
    *  Jeżeli kontener buildowy i docelowy **wydają się być te same** - być może warto zacząć od kroku `Publish` poniżej
    *  Jeżeli to kontener buildowy ma być wdrażany - czy na pewno nie trzeba go przypadkiem posprzątać?
      *  Przeprowadź dyskusję dotyczącą tego, jak powinno wyglądać wdrożenie docelowe wybranej aplikacji. Odpowiedz (z uzasadnieniem i dowodem) na następujące kwestie:
        * czy program powinien zostać *„zapakowany”* do jakiegoś przenośnego pliku-formatu (DEB/RPM/TAR/JAR/ZIP/NUPKG)
        * czy program powinien być dystrybuowany jako obraz Docker? Jeżeli tak – czy powinien zawierać zawartość sklonowanego repozytorium, logi i artefakty z *builda*?
    *  Proszę opisać szczegółowo proces który zostanie opisany jako `Deploy`, ze względu na mnogość podejść
  * `Publish`
    * Przygotowanie wersjonowanego artefaktu:
      * Instalator
      * NuGet/Maven/NPM/JAR
      * ZIP ze zbudowanym runtimem
    * Opracuj odpowiednią postać redystrybucyjną swojego artefaktu i/lub obrazu (przygotuj instalator i/lub pakiet, ewentualnie odpowiednio uporządkowany obraz kontenera Docker)
      * Musi powstać co najmniej jeden z tych elementów
      * Jeżeli ma powstać artefakt, dodaj go jako pobieralny obiekt do rezultatów „przejścia” *pipeline’u* Jenkins.
    * Opcjonalnie, krok `Publish` (w przypadku podania parametru) może dokonywać promocji artefaktu na zewnętrzne *registry*





### Pełna lista kontrolna
Zweryfikuj dotychczasową postać sprawozdania oraz planowane czynności względem ścieżki krytycznej oraz poniższej listy. Realizacja punktu wymaga opisania czynności, wykazania skuteczności (screen), podania poleceń i uzasadnienia decyzji dot. implementacji.

- [ ] Aplikacja została wybrana
- [ ] Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania
- [ ] Wybrany program buduje się
- [ ] Przechodzą dołączone do niego testy
- [ ] Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium
- [ ] Stworzono diagram UML zawierający planowany pomysł na proces CI/CD
- [ ] Wybrano kontener bazowy lub stworzono odpowiedni kontener wstepny (runtime dependencies)
- [ ] Build został wykonany wewnątrz kontenera
- [ ] Testy zostały wykonane wewnątrz kontenera
- [ ] Kontener testowy jest oparty o kontener build
- [ ] Logi z procesu są odkładane jako numerowany artefakt
- [ ] Zdefiniowano kontener 'deploy' służący zbudowanej aplikacji do pracy
- [ ] Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego
- [ ] Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera
- [ ] Następuje weryfikacja, że aplikacja pracuje poprawnie (*smoke test*)
- [ ] Zdefiniowano, jaki element ma być publikowany jako artefakt
- [ ] Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB
- [ ] Opisano proces wersjonowania artefaktu (można użyć *semantic versioning*)
- [ ] Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie
- [ ] Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu
- [ ] Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki
- [ ] Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem
- [ ] Sprawozdanie pozwala zidentyfikować cel podjętych kroków
- [ ] Forma sprawozdania umożliwia wykonanie opisanych kroków w jednoznaczny sposób


# Zajęcia 07
---


### Kroki Jenkinsfile
Zweryfikuj, czy definicja pipeline'u obecna w repozytorium pokrywa ścieżkę krytyczną:

- [ ] Przepis dostarczany z SCM (co załatwia nam `clone` )
- [ ] Etap `Build` dysponuje repozytorium i plikami `Dockerfile`
- [ ] Etap `Build` tworzy obraz buildowy, np. `BLDR`
- [ ] Etap `Build` (krok w etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt - **jeżeli docelowy kontener ma być odmienny**, tj. nie wywodzimy `Deploy` z obrazu `BLDR`
- [ ] Etap `Test` przeprowadza testy
- [ ] Etap `Deploy` przygotowuje **obraz lub artefakt** pod wdrożenie. W przypadku aplikacji pracującej jako kontener, powinien to być obraz z odpowiednim entrypointem. W przypadku buildu tworzącego artefakt niekoniecznie pracujący jako kontener (np. interaktywna aplikacja desktopowa), należy przesłać i uruchomić artefakt w środowisku docelowym.
- [ ] Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)
- [ ] Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda

### "Definition of done"
Proces jest skuteczny, gdy "na końcu rurociągu" powstaje możliwy do wdrożenia artefakt (*deployable*).
* Czy opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze **bez modyfikacji** (acz potencjalnie z szeregiem wymaganych parametrów, jak obraz DIND)?
* Czy dołączony do jenkinsowego przejścia artefakt, gdy pobrany, ma szansę zadziałać **od razu** na maszynie o oczekiwanej konfiguracji docelowej?


