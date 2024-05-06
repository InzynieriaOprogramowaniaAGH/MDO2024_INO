# Sprawozdanie 3

## Maksymilian Kubiczek INO CL2

## Cel ćwiczeń:

Celem tej grupy labaratorium jest zdobycie niezbędnej wiedzy na temat pipeline'ów - z czego się składają, po co z nich korzystamy oraz zbudujemy nasz pierwszy działający pipeline.
Poniżej znajdziemy listę kroków poruszonych podczas wykonywania poszczególnych instrukcji.

## Streszczenie wykonanych kroków

**[X] Aplikacja została wybrana**

Mój wybór padł na minimalistyczny framework do tworzenia aplikacji webowych w Node.js - express.
Taki, a nie innych wybór, ponieważ repozytorium to posiada dobrze napisaną dokumentacje, nie wymaga wielu preinstalowych narzędzi czy bibliotek oraz jest proste w obsłudze. 
Link do repozytorium:

    https://github.com/expressjs/express

**[X] Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania**

Repozytorium działa na otwartej licencji MIT, dzięki czemu możemy swobodnie edytować kod:
Link do pliku LICENSE:

    https://github.com/expressjs/express/blob/master/LICENSE

**[X] Wybrany program buduje się**

Pracę z naszym repozytorium rozpoczynamy od próby zbudowania aplikacji lokalnie na naszej maszynie wirtualnej. W tym celu wykonujemy następujące kroki:

Klonowanie repozytorium:

    git clone https://github.com/expressjs/express.git

![git clone](./Screenshots/git_clone.png)

Pobieramy dependencję projektu

    npm install express

![npm install express](./Screenshots/npm_install_express.png)

Istotna jest konieczność posiadania Node.js w wersji 0.10 lub nowszej.

**[X] Przechodzą dołączone do niego testy**

Testy uruchamiamy za pomocą komendy menadżera plików Node.js npm:

    npm test

![npm test](./Screenshots/npm_test.png)

Finalnie możemy uruchomić aplikację wykonując kilka następujących po sobie komend:

    express ./tmp/foo && cd ./tmp/foo

W tym momencie tworzymy hierarchie pików naszej aplikacji podając główny folder z którego będziemy uruchamiać aplikację.

Następnie poprzez ```npm install``` zaciągamy wymagane dependencje, by teraz finalnie w katalogu głównym (w tym przypadku to katalog ./tmp/foo) wykonać polecenie

    DEBUG=foo:* npm start

![npm start](./Screenshots/express.png)

Dodajemy tutaj wzmiankę o zmiennej środowiskowej, aby mieć dostęp do logów debugowania

Poniżej zaprezentowano zrzut ekranu przeglądarki z aplikacją
**[X] Wybrano kontener bazowy lub stworzono odpowiedni kontener wstępny (runtime dependencies)**

Drugą próbą budowy i uruchomienia aplikacji przeprowadzimy przy pomocy Dockera i kontenerów. Jako kontener bazowy będziemy korzystać z obrazu Node'a.

**[X] Build został wykonany wewnątrz kontenera**

Build przeprowadzamy tak samo jak poprzednio, z różnicą taką, że finałem zbudowania naszego projektu będzie gotowy obraz dockera. Do jego stowrzenia korzystamy z Dockerfil'a (Builder.dockerfile):

    FROM node:latest

    #Cloning
    RUN git clone https://github.com/expressjs/express.git

    WORKDIR express

    # RUN npm install express

    RUN npm install -g express-generator@4

    RUN express ./tmp/foo

    WORKDIR tmp/foo

    RUN npm install


Następnie budujemy kontener posługując się poniższą komendą:

    docker build -t build-app -f builder.dockerfile .

![builder](./Screenshots/builder.png)

**[X] Testy zostały wykonane wewnątrz kontenera**
**[X] Kontener testowy jest oparty o kontener build**

Kolejne dwa kroki łączymy tworząc kontener testowy który będzie bazować na kontenerze buildowym.
Kroki poczynione w tym punkcie znajdują się poniżej w Dockerfil'u (Tester.dockerfile):

    FROM build-app

    WORKDIR /express/tmp/foo

    RUN npm install

    RUN npm test --watch

Dzięki opcji --watch możemy zobaczyć czy poszczególne testy przechodzą poprawnie i czy nie mamy jakiś błędów w programie.
Następnie budujemy kontener posługując się poniższą komendą:

    docker build -t build-test -f tester.dockerfile .

![tester](./Screenshots/tester.png)

**[X] Zdefiniowano kontener 'deploy' służący zbudowanej aplikacji do pracy**

Jako trzeci kontener będziemy tworzyć kontener do deploy'u aplikacji, będzie on się różnić od poprzednich faktem, że poza samym zbudowaniem kontenera będziemy go uruchamiać (Dockerfile będzie zawierać entry point do aplikacji - będzie on mógł pozostać uruchomiony)
Poniżej znajduje się zawartość trzeciego pliku .dockerfile:

    FROM build-app

    WORKDIR express/tmp/foo

    CMD ["npm", "start"]


Teraz powtarzamy proces budowania kontenera tym razem do deploy:

    docker build -t deploy-app -f deploy.dockerfile .

![deploy](./Screenshots/deploy.png)

By potem móc uruchamiać program wraz z uruchomieniem kontenera ```docker run deploy-app```.
Finalnie ponownie dostajemy uruchomioną naszą aplikację do której możemy dotrzeć poprze port 3000.

---

## W tym miejscu rozpoczynamy pracę już w Jenkinsie

Pierwszym krokiem będzie stworzenie 2 kontenerów: Jenkinsa i Dind'a - oba są wymagane do poprawnego działania pipeline'u.

Podczas procesu tworzenia posiłkowałem się instrukcją zamieszczoną pod poniższym adresem URL:

    https://www.jenkins.io/doc/book/installing/docker/

Dlatego też utworzyłem obraz Blueocean - na podstawie obrazu Jenkinsa oraz Dind - jest to obraz umożliwiający uruchomienie kontenerów Docker wewnątrz kontenera Docker.

Sprawdzenie stanu obrazu **Blueocean**:

    docker ps

![docker ps](./Screenshots/docker_ps.png)

Teraz logujemy się na Jenkinsa oraz wstępnie jego konfigurujemy.

![Jenkins](./Screenshots/jenkins.png)

---
### Tworzenie pipeline

- Tworzenie projektu

- Przejście na prywatną gałąź

- budowanie obrazów z dockerfiles

---

W tym celu tworzę pipeline, w którym definiuję dwa etapy: 'git clone' oraz 'build'. W pierwszym etapie sprawdzam istnienie katalogu MDO2024_INO. Jeśli istnieje, usuwam go, a jeśli nie, zwracany jest ```true```, co oznacza sukces nawet w przypadku braku katalogu. Następnie przechodzimy do określonego katalogu w repozytorium za pomocą 'dir' i przechodzę na osobistą gałąź. W etapie 'build' ponownie wchodzę do katalogu 'MDO2024_INO/INO/GCL2/MK412502/Sprawozdanie3' i buduję obraz Dockera o nazwie 'build-app' z użyciem pliku 'builder.Dockerfile', który służy do budowy aplikacji.



**[X] Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki**

Pliki Dockerfile oraz Jenkinsfile są załączone w folderze ze sprawozdaniem.
