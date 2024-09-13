# Sprawozdanie z projektu zaliczeniowego

## Bartosz Kępczyński

### Przebieg ćwiczeń:

Początkowo znaleziono repozytorium aplikacji open source, zgodne z przedstawionymi wymaganiami. Wybraną aplikcają jest redis.

Wyciąg z licencji:

![](licencja.png)

Sklonowano repozytorium aplikacji, następnie skompilowano ją i przetestowano.

Testy aplikacji:

![](testy.png)

Działanie aplikacji:

![](serwer-lokalnie.png)
![](klient-lokalnie.png)

Następnie uruchomiono ją w kontenerze i sprawdzono nasłuchiwanie na porcie, oraz komunikację.

![](kontener-działanie.png)
![](kontener-słuchanie.png)
![](kontener-komunikacja.png)

Najlepszym rozwiązaniem procesu wdrożeiowego dle tego programu będzie dystrybucja jako obraz docker. Jest on łatwo pobieralny i przenośny. Taki obraz powinien działać samodzielnie, nie wymagać pobierania dodatkowyych zależności, oraz nie powinno być w nim narzędzi deweloperskich.

Zestawiono instalację jenkinsa DIND, w tym celu również dodano użytkownika jenkins do grupy docker mającej to samo ID co grupa docker na hoście i stworzono pipeline dla projektu.

- Etap Build tworzy obraz, który instaluje wszystkie potrzebne zależności, a następnie przeprowadza testy.

![](budowa.png)
![](budowa-testy.png)
![](pipeline-build.png)

Dockerfile obrazu budującego został załączony razem ze sprawozdaniem.

- Etap Test korzysta z utworzonego wcześniej obrazu i buduje kontener do testowania.

![](testy-jenkins.png)
![](pipeline-test.png)

- Etap deploy buduje obraz wdrożeniowy.

Treść dockerfile do obrazu wdrożeniowego:

![](deploy.png)
![](pipeline-deploy.png)

Dockerfile obrazu wdrożeniowego został załączony razem ze sprawozdaniem.

-Etap publish wysyła obraz wdrożeniowy na repozytorium dockerhub.

![](pipeline-publish.png)

Gotowy obraz nie wymaga pobieranbia dodatkowych dependencji:

![](obraz.png)