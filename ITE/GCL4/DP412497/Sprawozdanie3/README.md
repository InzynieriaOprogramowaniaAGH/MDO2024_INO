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


  * Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta
> Pierwszy projekt sprawdził poprawne działanie skryptów w Jenkins'ie

* Utwórz "prawdziwy" projekt, który:
  * klonuje nasze repozytorium
  * przechodzi na osobistą gałąź
  * buduje obrazy z dockerfiles i/lub komponuje via docker-composed


  
### Pipeline
* Definiuj pipeline korzystający z kontenerów celem realizacji kroków `build -> test`
* Może, ale nie musi, budować się na dedykowanym DIND, ale może się to dziać od razu na kontenerze CI. Należy udokumentować funkcjonalną różnicę między niniejszymi podejściami
* Docelowo, `Jenkinsfile` definiujący *pipeline* powinien być umieszczony w repozytorium. Optymalnie: w *sforkowanym* repozytorium wybranego oprogramowania

### Szczegóły
Ciąg dalszy sprawozdania
#### Wymagane składniki
*  Kontener Jenkins i DIND skonfigurowany według instrukcji dostawcy oprogramowania
*  Pliki `Dockerfile` wdrażające instancję Jenkinsa załączone w repozytorium przedmiotowym pod ścieżką i na gałęzi według opisu z poleceń README
*  Zdefiniowany wewnątrz Jenkinsa obiekt projektowy „pipeline”, realizujący następujące kroki:
  * Kontener `Builder`, który powinien bazować na obrazie zawierającym dependencje (`Dependencies`), o ile stworzenie takiego kontenera miało uzasadnienie. Obrazem tym może być np. baza pobrana z Docker Hub (jak obraz node lub 
dotnet) lub obraz stworzony samodzielnie i zarejestrowany/widoczny w DIND (jak np. obraz oparty o Fedorę, doinstalowujący niezbędne zależności, nazwany Dependencies). Jeżeli, jak często w przypadku Node, nie ma różnicy między runtimowym obrazem a obrazem z dependencjami, proszę budować się w oparciu nie o latest, ale o **świadomie wybrany tag z konkretną wersją**
  * Obraz testujący, w ramach kontenera `Tester`
    * budowany przy użyciu ww. kontenera kod, wykorzystujący w tym celu testy obecne w repozytorium programu
    * Zadbaj o dostępność logów i możliwość wnioskowania jakie testy nie przechodzą
  * `Deploy`
    *  Krok uruchamiający aplikację na kontenerze docelowym
    *  Jeżeli kontener buildowy i docelowy **wydają się być te same** - być może warto zacząć od kroku `Publish` poniżej
    *  Jeżeli to kontener buildowy ma być wdrażany - czy na pewno nie trzeba go przypadkiem posprzątać?
      *  Przeprowadź dyskusję dotyczącą tego, jak powinno wyglądać wdrożenie docelowe wybranej aplikacji. Odpowiedz (z uzasadnieniem i dowodem) na następujące kwestie:
        * czy program powinien zostać *„zapakowany”* do jakiegoś przenośnego pliku-formatu (DEB/RPM/TAR/JAR/ZIP/NUPKG)
        * czy program powinien być dystrybuowany jako obraz Docker? Jeżeli tak – czy powinien zawierać zawartość sklonowanego repozytorium, logi i artefakty z *builda*?
    *  Proszę opisać szczegółowo proces który zostanie opisany jako `Deploy`, ze względu na mnogość podejść
  * `Publish`
    * Przygotowanie wersjonowanego artefaktu, na przykład:
      * Instalator
      * NuGet/Maven/NPM/JAR
      * ZIP ze zbudowanym runtimem
    * Opracuj odpowiednią postać redystrybucyjną swojego artefaktu i/lub obrazu (przygotuj instalator i/lub pakiet, ewentualnie odpowiednio uporządkowany obraz kontenera Docker)
      * Musi powstać co najmniej jeden z tych elementów
      * Jeżeli ma powstać artefakt, dodaj go jako pobieralny obiekt do rezultatów „przejścia” *pipeline’u* Jenkins.
    * Opcjonalnie, krok `Publish` (w przypadku podania parametru) może dokonywać promocji artefaktu na zewnętrzne *registry*
#### Wskazówka
Po opracowaniu formy redystrybucyjnej, stwórz obraz runtime’owy (bez dependencji potrzebnych wyłącznie do builda!), zasilony artefaktem, zainstaluj w nim program z niego i uruchom. Jeżeli formą redystrybucyjną jest kontener, uruchom kontener – w sposób nieblokujący: pozwól pipeline’owi kontynuować po uruchomieniu, ale wykaż, że program uruchomiony w owym kontenerze działa.




# Zajęcia 06
---

## Pipeline: lista kontrolna
Oceń postęp prac na pipelinem

### Ścieżka krytyczna
Podstawowy zbiór czynności do wykonania w ramach zadania z pipelinem CI/CD. Ścieżką krytyczną jest:
- [ ] commit (lub manual trigger @ Jenkins)
- [ ] clone
- [ ] build
- [ ] test
- [ ] deploy
- [ ] publish

Poniższe czynności wykraczają ponad tę ścieżkę, ale zrealizowanie ich pozwala stworzyć pełny, udokumentowany, jednoznaczny i łatwy do utrzymania pipeline z niskim progiem wejścia dla nowych *maintainerów*.

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


Oceń postęp prac na pipelinem - proces ujęty w sposób deklaratywny

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
