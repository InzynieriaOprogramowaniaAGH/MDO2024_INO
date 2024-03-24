*Maciej Dziura*
*IO 409926*

**CEL PROJEKTU**


**WYKONANE KROKI**
**WYBÓR OPROGRAMOWANIA NA ZAJĘCIA**

**1. Znalezienie repozytorium z kodem dowolnego oprogramowania, które:**
- dysponuje otwartą licencją
- jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt make build oraz make test. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...
- Zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)

https://github.com/dmaciej409926/simple-nodejs.git

**2. Sklonowanie niniejszego repozytorium, przeprowadzenie buildu proramu (doinstalowanie wymaganych zależności).**


**3. Uruchomienie testów jednostkowych dołączonych do repozytorium**

**WYKONANE KROKI**
**PRZEPROWADZENIE BUILDU W KONTENERZE**

**1. Wykonanie buildu i testów wewnątrz wybranego kontenera bazowego (Tj. wybór "wystarczającego" kontenera, np ubuntu dla aplikacji C lub node dla Node.js)**

- Uruchomienie kontenera:

- Podłączenie do niego TTY celem rozpoczęcia interaktywnej pracy

- Zaopatrzenie kontenera w wymagania wstępne (jeżeli proces budowania nie robi tego sam)

- Sklonowanie repozytorium

- Uruchomienie build

- Uruchomienie testów

**2. Stworzenie dwóch plików Dockerfile automatyzujących kroki powyżej, z uwzględnieniem następujących kwestii**

- Kontener pierwszy ma przeprowadzać wszystkie kroki aż do builda

- Kontener drugi ma bazować na pierwszym i wykonywać testy

**3. Wykazanie, że kontener wdraża się i pracuje poprawnie. Pamiętając o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?**

