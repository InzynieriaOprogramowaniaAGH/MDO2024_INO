# Sprawozdanie z laboratorium 5, 6 i 7

## Bartosz Kępczyński

### Cel ćwiczeń:

Celem wykonanych ćwiczeń jest zapoznanie się z Jenkinsem, pipelinem i definicją etapów.

## Wstęp:

### Wstępne wymagania środowiska:

- Jenkins
- Docker (w tym przypadku DIND)
- Git (repozytorium kodu)
- Dockerfile (do testowania i testowania)
- Jenkinsfile (definniuje kroki pipelinu, w tym przypadku tworzymy go poprzez blueocean)
- Połączenie sieciowe
- Rejestr Docker
- Uprawnienia dostępu do repozytorium i rejestru

Diagram aktywności:

```plantuml
@startuml
start
:Zbierz kod źródłowy;
:Ściągnij kod z Gita;
:Zbuduj obraz Dockera;
:Zbuduj wewnątrz kontenera;

:Przetestuj kod;
:Zbuduj obraz do testowania;
:Przeprowadź testy w kontenerze;

:Pokaż wyniki;
:Zachowaj artefakt;
:Wypchnij obraz do rejestru Docker;
end
@enduml
```

Diagram wdrożeniowy:

```plantuml
@startuml
node "Jenkins Server" {
    [Jenkins Pipeline] --> [Docker Daemon]
}

node "Docker Daemon" {
    [Build Container]
    [Test Container]
    [App Container]
}

node "Git Repository" {
    [Source Code]
}

node "Docker Registry" {
    [Docker Image]
}

[Jenkins Pipeline] --> [Source Code] : Ściąga
[Jenkins Pipeline] --> [Build Container] : Buduje
[Build Container] --> [App Container] : Wytwarza
[Test Container] --> [App Container] : Testuje
[App Container] --> [Docker Image] : Wypycha
[Docker Image] --> [Docker Registry] : Wypycha
@enduml
```

### Przebieg ćwiczeń:

Początkowo pobrano i zaistalowano Jenkinsa poprzez Dockera. Jenkinsa skonfigurowano, korzystając z wygenerowanego hasła pierwszego administratora. Zainstalowano  sugerowane wtyczki i obraz Blueocean.

![](zrzut1.png)
![](zrzut2.png)

w odróżnieniu od klasycznego interfejsu, Blueocean znacznie upraszcza pracę.   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

![](zrzut3.png)

Po konfiguracji Jenkinsa przygotowano dwa proste projekty testowe, jeden, który zwraca uname, a drugi który nie buduje się poprawnie, kiedy godzina jest nieparzysta.

![](zrzut4.png)
![](zrzut5.png)

Następnie utworzono projekt klonujący wybrane repozytorium, przechodzy na osobną gałąź i budujący obrazy z dockerfiles.

Ścieżkę krytyczną pipelineu lekko zmodyfikowano, etap build podzielono na etapy build image (budujący obraz), oraz build project (budujący aplikację).

Etap Build Image buduje obraz Dockera z Dockerfile.build i oznacza go odpowiednim numerem builda.

![](zrzut6.png)

Z powodu problemów z budową obrazu w celu uproszczenia eliminacji błędów wprowadzono także etap Verify Image, który weryfikuje, czy obrazy zostały poprawnie utworzone.

![](zrzut7.png)

Etap Build Project zajmuje się budowaniem projektu, a etap Test uruchamia testy.

![](zrzut8.png)
![](zrzut9.png)

Ponieważ projekt pracuje jako kontener etap Deploy przygotowuje obraz pod wdrożenie.

![](zrzut10.png)

Etap Publish wysyła gotowy artefakt do rejestru w Dockerhubie.

![](zrzut11.png)

Do sprawozdania dołączony jest również pełny plik jenkinsfile pipelineu.

## Wnioski:

Pipeliny Jenkins umożliwiają prostą automatyzację wdrażania obrazów Docker.

Podczas realizacji ćwiczenia największy problem sprawiło zapewnienie uprawnień dostępu dla Jenkinsa, jak i jego instalacja umożliwiająca korzystanie z dockera, która musiała zostać przeprowadzona kilka razy.

Dzięki temu narzędzu, jeżeli repozytorium zawiera Jenkinsfile, można go łatwo zbudować i przeprowadzić testy.