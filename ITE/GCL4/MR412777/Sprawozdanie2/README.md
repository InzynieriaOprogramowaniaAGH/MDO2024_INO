# Sprawozdanie 2

---
# Dockerfiles, kontener jako definicja etapu, dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Magdalena Rynduch ITE GCL4

Celem laboratorium było zapoznanie się z plikami Dockerfile, kontenerami, woluminami, iperf, tworzeniem sieci w Docker oraz instalacją Jenkins.

Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu

Laboratorium rozpoczęłam od poszukiwań oprogramowania, które umożliwi zrealizowanie zadań w instrukcji. Wybrałam repozytorium https://github.com/jitpack/maven-simple. 
Dysponuje ono licencją MIT. Jest to otwarta licencja oprogramowania zapewniająca użytkownikom swobodę w używaniu, modyfikowaniu oraz rozpowszechnianiu oprogramowania, zarówno w formie oryginalnej, jak i zmodyfikowanej. 
Oprogramowanie zostało wykonane w środowisku Maven. W budowie aplikacji tego typu projektów wyróżnia się osiem głównych cykli: clean, validate, compile, test, package, integration-test, verify, install oraz deploy. Na potrzeby laboratorium korzystałam z dwóch: compile (kompilującego kod źródłowy) oraz test (przeprowadzającego testy jednostkowe).
Oprogramowanie zawiera zdefiniowane i obecne w repozytorium testy (`src/test`), które można uruchomić i uzyskać jednoznaczny raport końcowy.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/049c0af2-c03a-465d-90ad-6c015242a303)

W skorzystania z projektu konieczna byla instalacja Maven. W tym celu posłużyłam się poleceniem `apt install maven`. Instalacja wykonywana była z poziomu katalogu stworzonego z myślą o innym repozytorium, z którego ostatecznie zrezygnowałam. Ścieżka nie ma to wpływu na przebieg instalacji.

![sudo apt mvn](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/24add425-9591-42d4-943e-8139148106c2)

Utworzyłam katalog `maven-app` i sklonowałam do niego wybrane repozytorium.

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/90f208da-a2cb-4234-b1ea-3dcd0860f027)

Skompilowałam plikację za pomocą `mvn compile`.

![mvn compile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ecfd0259-80bd-4e8c-b94d-01ec3d1e9025)
![mvn compile 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/85f95e08-d37d-4cbb-b364-108c77b3ec69)

Przeprowadziłam testy za pomocą `mvn test`. Wynik testów był pozytywny.

![mvn test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c57c8798-dd8f-4eb3-a9c2-5903799abda6)
![mvn test 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/65202f67-070b-4be3-a962-5abb69942e1b)

Uruchomiłam kontener w trybie interaktywnym za pomocą `docker run -it`. Uruchomiłam osobny terminal i wyświetliłam w nim szczegóły działającego procesu.

![docker run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ff095d0c-96b4-4488-84c1-a97b3da877b5)

Zaopatrzyłam kontener w wymagania wstępne. Konieczna była aktualizacja pakietów systemowych, instalacja maven oraz gita. Posłużyły do tego komendy: `apt-get update`, `apt-get install maven` oraz `apt-get install git`. 

![docker apt-get update](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7e0e5b4e-5468-499f-b409-489ff687cf72)

![docker apt-get mvn](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/372693fd-6705-43c8-a475-f7f07d7adcba)
![docker apt-get mvn 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1a081758-a4ab-4da6-8486-01532b05cb53)

![docker apt-get git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/d8dba4dc-c8ec-42aa-a21c-3bd9006472dd)
![docker apt-get git 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a5693abe-3f9d-496d-bf7f-065617d29437)

Sklonowałam repozytorium do kontenera za pomocą `git clone`.

![docker git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0af24cf1-bcc5-49d3-88a2-85ff17eb8026)

Zbudowałam w kontenerze projekt przy pomocy `mvn compile`.

![docker mvn compile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a3f4fde1-00e1-4d23-bc8f-c6081a38e7fa)

Wykonałam testy w kontenerze przy pomocy `mvn test`. Uzyskany wynik był pozytywny.

![docker mvn test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e2da83ee-b0a9-4a21-a18c-fa28f0a51307)
![docker mvn test 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/63f1706e-e83b-4889-b8be-dc5b8c84edb6)

Stworzyłam dwa pliki `Dockerfile` automatyzujące wykonane powyżej kroki. Pliki zostały umieszczone w folderze `Sprawozdanie2`. 
`Dockerfile.build` jest odpowiedzialny za wszystkie kroki aż do `mvn compile`. 
`Dockerfile.test` bazuje na `Dockerfile.build` i wykonywać testy.

Pliki `Dockerfile` umieściłam w folderze `~/maven-app/dockerfiles` i korzystając z nich stworzyłam obrazy `build_image` oraz `test_image`. W tym celu korzystałam z polecenia `docker build`

![dockerfile images](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f24d20e7-a7c5-45af-8954-7841bd40e30b)

W celu sprawdzenia poprawności działania, uruchomiłam kontener z obrazu `test_image` i sprawdziłam jego zawartość. Znajdowało się w nim sklonowane repozytorium `maven-simple`. W katalogu głównym projektu powstał folder `target`, co świadczy o tym że zaszła kompilacja. Klonowanie ani kompilacja nie mogłyby zajść, gdyby nie uprzednio poprawnie zainstalowane zależności. Oznacza to, że polecenia z pliku `Dockerfile` są wykonywane prawidłowo.

Etap instalacji, klonowania oraz kompilacji znajdowały się w pliku `Dockerfile.build`, zaś obraz `test_image` korzysta z `Dockerfile.test`. Stąd można wywnioskować, że jeden pliki `Dockerfile` w poprawny sposób do siebie nawiązują.

![dockerfile run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a1067186-8170-4725-987c-f7af6c10acb4)

Przygotowałam woluminy wejściowy i wyjściowm `volume-in` oraz `volume-out` za pomocą `docker volume create`.

![docker volume create](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/de6df96d-2e89-47d4-811c-7cc9e488d144)

Podłączyłam woluminy do kontenera i go uruchomiłam.

![docker volume run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/64553d6c-4f72-492a-8d51-e737b104fc90)

Zainstalowałam w kontenerze niezbędne pakiety z wyjątkiem gita.

![docker apt-get update](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1c7c76e3-7850-4274-8898-2e2311217c51)

![docker apt-get install maven](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/192f70ea-8b61-4ad9-9115-7b92432425c7)
![docker apt-get install maven 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6574398d-00f4-4b2d-8142-4f228a2b65a9)

Aby umieścić repozytorium w kontenerze bez instalacji w nim gita, można posłużyć się woluminem wejściowym `input`. Sprawdziłam jego początkową zawartość poleceniem `ls` i był pusty. Otworzyłam nowe okno teminalu, skopiowałam repozytorium z maszyny lokalnej (uprzednio sklonowane z githuba) do woluminu za pomocą `cp -r`. Przy ponownym sprawdzeniu zawartości `input`, znajdowało się tam już skopiowane repozytorium.

![docker cp](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0c67e490-13f1-48c4-9996-17a3a25c7315)

Skopiowałam repozytorium do katalogu `/app` i uruchomiłam compile.

![cp app dir](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6ee6c67a-646e-4e20-8b06-3ba7795e55bd)

![docker mvn compile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/bdcc1eb9-ce55-44f3-9047-2ffb1cae84fb)

Powstałe pliki w wyniku kompilacji (`/target`) skopiowałam na wolumin wyjściowy `/output`.

![cp target](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a24998a5-9cf3-4a30-8dfc-760f64bdcddf)
![docker volume out](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/10b56dda-e157-4bb8-b904-6d416a1c728c)

Całą operację wykonałam analogicznie drugi raz, ale z klonowaniem na wolumin wejściowy wewnątrz kontenera. Najpierw zainstalowałam Gita za pomocą `apt-get install git` a następnie sklonowałam repozytorium korzystając z `git clone`.

![docker apt-get install git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b81d2c67-6bee-46ea-b2b3-89b8e1b5a8a7)
![docker apt-get install git 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c38232e6-8554-41cc-80b4-c3ad2f936acf)
![docker git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/8ac944f9-3e80-4e94-8a3a-38e75043370b)

Istnieje sposób aby zautomatyzować operacje na woluminach w procesie budowania obrazu Dockera `docker build`. Można to zrobić korzystając z instrukcji `RUN --mount`. Umożliwia ona tworzenie woluminu do kontenera podczas wykonywania polecenia RUN w pliku Dockerfile.
W tym przypadku plik `Dockerfile` mogłoby zawierać polecenie:
`RUN --mount=type=volume,source=volume-in,target=/app git clone https://github.com/jitpack/maven-simple /app`

Następnie zapoznałam się z dokumentacją `https://iperf.fr/`. Zainstalowałam `iPerf3` wewnątrz dwóch kontenerów.

![docker iperf install](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e230c7e8-48ff-4e5e-98b4-58b6cb2178a5)
![docker iperf install 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6301618f-c0d0-4a70-91c3-2f52ce022ba1)

Pracowałam na dwóch otwartych terminalach jednocześnie. W jednym z kontenerów uruchomiłam serwer iperf, a w drugim client iperf.

![docker iperf -c -s](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e947e9ef-8589-4652-a4c2-a81c097a66de)

Wykonałam ten krok ponownie, ale wykorzystując własną sieć mostkową Docker.
Stworzyłam sieć i dodałam do niej istniejące kontenery.

![network create](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/4e4db9aa-b143-427b-bf44-220bed97e362)

Wyświetliłam szczegóły stworzonej sieci.

![network inspect](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/2d4732d0-4768-4666-97bc-59bd56c76b0d)

Zbadałam połączenie pomiędzy kontenerami. W tym celu doinstalowałam ping na serwerze i kliencie przy pomocy polecenia `apt-get install -y iputils-ping`.

![docker iperf3 v2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/4b2932b0-ab52-4681-a948-64600f8b2c34)
![ping install server](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/4c14a782-40da-40e6-b8ae-33832fb8b3ef)
![ping install client](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c3928c75-a2f9-4b69-a57f-52cb4c352de4)
![ping](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1669c38d-8bb6-4680-b727-4cabf14c14c8)

Z pomiarów wynika, że komunikacja między kontenerami w sieci Docker jest sprawna. Sieć Docker została poprawnie skonfigurowana, ponieważ dpowiedzi są otrzymywane z obu kontenerów. Czasy odpowiedzi są niskie, co oznacza, że połączenie jest szybkie i stabilne.

Następnie przeszłam do wykonałam połączenia do kontenera spoza kontenera. Rozpoczęłam od instalacji iPerf3 na maszynie.

![iperf install](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fe856505-2328-4f94-87d9-d5412a9a2acd)

![iperf host container](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/2f69bd6a-8d8d-44e1-a0ac-2d6387e7d591)

Wyniki pokazują wysoką przepustowość komunikacji między hostem a kontenerem. Połączenie było stabilne i nie doszło do żadnej utraty pakietów ani konieczności ponownego przesyłu danych.

Następnie, po zapoznaniu się z dokumentacją `https://www.jenkins.io/doc/book/installing/docker/`, przeszłam do skonteneryzowanej instancji Jenkins z pomocnikiem DIND. 

Pobrałam oficjalny obraz Jenkinsa z Docker Hub za pomocą `docker pull`.
![jenkins pull](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/5255e2f6-2215-40e3-a854-5b18ae9ba97e)

Uruchomiłam Jenkinsa w kontenerze z DIND za pomocą `docker run` oraz wyświetliłam hasło inicjalizacyjne Jenkinsa za pomocą `docker exec`. W celu wyświetlenia UI Jenkinsa konieczna była znajomość adresu ip, więc sprawdziłam go poleceniem `ifconfig`.

![jenkins install ](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fbd0e036-18f4-4780-b081-9491f25a433c)

Wyświetliłam działające kontenery, wśród których znajdował się jenkins.

![jenkins ps](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7b9592a0-a649-42bd-9c88-5dd163e42ec1)

Znalazłam stronę w przeglądarce po adresie IP i odpowiednim portcie. Wprowadziłam wyświetlone wcześniej hasło.

![jenkins install 2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ba123506-a131-4cb2-9d45-e4c32463a893)

Zainstalowałam sugerowane wtyczki i podążałam według instrukcji na stronie. Wprowadziłam dane administratora i pominęłam konfigurację bazowgo adresu URL. Po zakończonej konfiguracji wyświetliła się strona główna po zalogowaniu.

![jenkins install 7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7ee3057f-d171-4349-ad40-a684da6beca7)

Zadania zrealizowane w ramach laboratorium opierały się na praktycznym zastosowaniu plików Dockerfile, kontenerów, woluminów, narzędzia iperf oraz sieci w Docker. Pliki Dockerfile są niezbędnym narzędziem do budowania obrazów Docker. Jeden plik może być odpowiedzialny zarówno za całość jaki i za konkretny etap w tworzeniu oprogramowania. Kontenery Docker zapewniają izolację aplikacji i jej zależności co zwiększa skalowalność i elastyczność aplikacji. Woluminy w Docker umożliwiają przechowywanie danych poza kontenerem, co zabezpiecza przed utratą danych w przypadku zatrzymania lub usunięcia kontenera. Narzędzie iperf pozwala na wykonywanie pomiarów przepustowości między hostami lub kontenerami w Docker. Docker umożliwia tworzenie sieci zapewniających kontrolę nad komunikacją między kontenerami.
