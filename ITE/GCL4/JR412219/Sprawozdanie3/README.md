# Zajęcia 05-07
---
### Przygotowanie
Na rzecz budowy pipelinu skorzystąłem z "To do List" z poprzedniej części laboratorium.
Po upewnieniu się, że obrazy budujący i testujący dla TDWA z zajęć 3 działa poprawnie rozpocząłem przygotowanie kontenera dind oraz bluocean. Kontener bluocean jest wariacją na temat klasycznego Jenkinsa który "ułatwia" z nim pracę co nie oznacza, że gdy go zobaczyłem chciałem z nim pracować. Po jego pierwszym uruchomieniu nie skorzystąłem z GUI blueocean do końca laboratoriów.
Kontener `dind`, czyli docker in docker jest kontenerem, który eksponuje demona dokerowego dla Jenkinsa dzięki czemu możemy z niego skorzystać w pipelinie.
By przygotować obraz dind skorzystałem z instrukcji pobrania i instalcji na stronie Jenkinsa.
Najpier należało uitworzyć sieć Jenkinsa w ramach których będą komunikować się dind i Jenkins.
Skorzystąłem z polecenia dockera:
```BASH
docker network create jenkins
```  
Następnie uruchomiłem kontener dind skopiowanym ze strony z instrukcją instalcji komendą.
```BASH
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
Zgodnie z opisem poszczególnych argumentów polecenia możemy zauważyć, że kontener zostaje podpięty do sieci jenkins, posiada nadany alias sieciowy przez który bedzie wywoływany oraz woluminy na których znajdą się pliki należące do kontenera Jenkinsa oraz configuracyjne i logi z pracy demona. Kontener zostanie również usunięty w momencie wyłączenia maszyny wirtualnej przez co trzeba pamiętać o uruchamianiu demona przy każdorazowym przystapieniu do pracy z Jenkinsem.

Następnym krokiem było przygotowanie obrazu blueocean. Tak jak wspomniałem we wstępie nigdy z niego nie skorzystałem pomimo że podobno ułatwia pracę z Jenkinsem. Nie mówię że ta nie jest ale, gdy zrozumiałem czym jest zdążyłem przyzwyczaić się do oryginalnego interfacu użytkownika Jenkinsa. Sam nie przepadam za reskinami których celem jest "upraszczanie pracy" poprzez ograniczenie dostępnych opcji.
By przygotowac obraz blueocean należało sporżadzić dockerfile o nastepującej treści również załaczony w instrukcji instalacji Jenkinsa.
```Dockerfile
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
Następnie obraz został zbudowany i uruchomiony poleceniami:
```BASH
docker build -t blueocean -f Blueocean.Dockerfile .
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
Ponownie w poleceniu uruchomienia kontenera widzimy że został on podpiety do tej samej sieci mostkowej co dind oraz zostął mu wskazany port na którym nadaje demon dockerowy. Zostały podpięte również voluminy w których Jenkins będzie mógł gromadzić swojej pliki oraz logi z pracy projektów przez to że zostały one zmapowane na voluminy w razie awarii kontenerów dind lub Jenkins na voluminach powinny pozostac pliki configuracyjne pipelinów oraz logi. 

Jenkins nadaje swoją usługę na porcie 8080. Korzystajać z polecenie `ip addr` wewnątrz interkatywnie uruchomionego kontenera Jenkinsa (`docker container exec -it <container> ./bin/bash`) ustaliłem na jakim adresie znajdę usługę Jenkinsa. Podając adres maszyny oraz port w przeglądarce w formacie *[addr]:[port]* uzyskałem dostęp do usługi Jenkinsa. Przed przejściem do przeglądarki i przypadkowym ubiciem kontenera z Jenkinsem skopiowałem do schowka początkowe hasło admina dla usługi Jenkinsa któe uzyskałem wypisując zawartość wskazanego w instrukcji konfiguracji pliku w kontenerze Jenkinsa.
```BASH
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Oczywiście powyższe polecenie musi zostać wywołane wewnątrz interaktywnie pracująceog kontenera Jenkinsa. Wrazie gdyby konfiguracja się nie powiodła lub zostało zpomniane hasło możemy usunąć zawartość katalogu na który zmapowany został volumin z plikami Jenkinsa by przywrócić Jenkinsa do stanu fabrycznego i początkowej konfiguracji.
Po wstepnym logowaniu przy pomocy uprzednio pozyskanego hasła przeprowadziłem konfigurację swojego konta które miało pełne uprawninia admina oraz znacznie przyyjazne do zapamiętania hasło.
  
### Uruchomienie 
Pierwsyzm krokiem wprowadzajacym do pracy z Jenkinsem było utworzenie pierwszego projektu który zwracał wynik polecenia `uname` oraz drugi, który zwracał błąd, gdy godzina była nieparzysta.
W przypadku pierwszego w konfiguracji projektu należało wybrać "Uruchomienie powłoki" i przekazać polecenie do wykonania czym w naszym przyypadku był `uname -a`.
Po uruchomieniu projektu uzysakłąem następujący wynik oraz potwierdzenie poprawności uruchomienia.
![Uname](../Resources/Lab6-7/image.png)
Drugi projekt był o kilka linijek dłuższy ale również skaładał się na Uruchomienie powłoki oraz wykonanie prostego skryptu Bash który porównywał oprację modulo na godzinie i wykonywał if statement na jego podstawie.

Skrypt wyglada następująco:
```BASH
if [ $(( $(date +%H) % 2 )) -eq 1 ]; then
    echo "Godzina jest nieparzysta."
    exit 1
else
    echo "Godzina jest parzysta."
fi
```
Poniżej wynik uruchomienia nieparzystej i parzystej godzinie.
  ![alt text](image.png)![alt text](image-2.png)
  Na powyyższych zrzutach widzimy jak Pipeline może zostać wysterowany zarówno rpzez polecenia i wyrażenia logiczne w Jenkinsfile ale również przez skrypty które zwracając kod błędu zakończą wykonanie pipelinu również z błędem.


Ostatnim etapem z wprowadzenia do Jenkinsa było przygotowanie "Prawdziwego projektu" który zaciąga nasze repo przedmiotowe a następnie wykonuje checkout na moją personalną gałąź i wykonuje build i test zgodnie z zawartością Dockerfilów z labu nr 3.
Z perspekwty czasu wydaje mi się że autorowi instrukcji chodziło o utworzenie pierwszego pipelinu, który będzie zdefiniowany jako Jenkinsfile lub przynajmniej konfiguracja jako opis kroków w piplinie.
Ja jednak postawiłem na proste przejście prze wywołania poleceń w terminalu. Podbnie jak w przypadku poprzednich punktów utworzyłem nowy projekt i w konfiguracji ustawiłem uruchomienie powłoki jako definicję kroku budowania. Powłoka nastepnie wykonywała serię poleceń zgodnie z treścią poniżej:
```BASH
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git Repo
cd Repo
git checkout JR412219
cd ITE/GCL4/JR412219/Workspace/Lab3/TDWA 
ls
docker build -t tdwabuild -f TDWAbuild.Dockerfile .
docker build -t tdwatest -f TDWAtest.Dockerfile .
cd ~ && rm -rf Repo
```
  Na tym etapie zrozumiałem, że godzina systemu na maszynie wirtualnej z której korzystałem i z której godzinę zaciągał docker i jego kontenery była błędna pomimo konfiguracji dla naszego regionu. Założyłem że wynikało to z faktu, że przez pewien czas maszyny nie wyłączałem a jedynie zapisywałem stan a godzina była aktualizowana przy uruchomieniu systemu. 
### Sprawozdanie (wstęp)
* Opracuj dokument z diagramami UML, opisującymi proces CI. Opisz:
  * Wymagania wstępne środowiska
  * Diagram aktywności, pokazujący kolejne etapy (collect, build, test, report)
  * Diagram wdrożeniowy, opisujący relacje między składnikami, zasobami i artefaktami
* Diagram będzie naszym wzrocem do porównania w przyszłości
  
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

#### Oczekiwana postać sprawozdania
* Sprawozdanie nie powinno być jedynie enumeracją wykonanych kroków.
* Sprawozdanie musi zawierać na wstępie opis celu wykonywanych czynności oraz streszczenie przeprowadzonego projektu.
* Każdy z kroków powinien zostać opisany (nie tylko zrzut i/lub polecenie)
* Proszę zwrócić uwagę na to, czy dany etap nie jest „self explanatory” tylko dla autora: czy zrozumie go osoba czytająca dokument pierwszy raz. Odtwarzalność przeprowadzonych operacji jest kluczowo istotna w przypadku dokumentowania procesu
* Każda podjęta decyzja musi zostać opisana, umotywowana. Na przykład jasne musi być:
  * Dlaczego wybrano taki, a nie inny obraz bazowy
  * Dlatego publikowany artefakt ma taką postać? Dlaczego ma taki format instalatora lub nie zawiera instalatora
* Napotykane problemy również należy dokumentować. Pozwala to mierzyć się z potencjalnymi trudnościami osobom, które będą implementować pipeline na podstawie sprawozdania. Z punktu widzenia zadania, nie ma sensu ani potrzeby udawać, że przebiegło ono bez problemów.
* Krótko mówiąc, sprawozdanie powinno być sformułowane w sposób, który umożliwi dotarcie do celu i identycznych rezultatów osobie, która nie brała udziału w przygotowaniu pipeline’u.