# Sprawozdanie 02
# IT 412497 Daniel Per
---

## Dockerfiles, kontener jako definicja etapu
## Dodatkowa terminologia w konteneryzacji, instancja Jenkins
---
Celem tych ćwiczeń było lepsze zapoznanie się i zrozumienie wykorzystywania kontenerów w projektach.

---

## Wykonane zadania - Lab 3
---
### Wybór oprogramowania na zajęcia
* Znajdź repozytorium z kodem dowolnego oprogramowania, które:
	* dysponuje otwartą licencją
	* jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt ```make build``` oraz ```make test```. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...
	* Zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)
Odpowiednie repozytoria z kodem oprogramowania które spełnia warunki otrzymaliśmy od prowadzącego.
Są to następujące: 
 - https://github.com/devenes/node-js-dummy-test
 - https://github.com/irssi/irssi

* Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności)
Klonujemy oba repozytoria korzystając z:
```
git clone https://gihthub.com/nazwa/repozytorium
```

![ss](./ss/ss01.png)

Następnie przeprowadzamy build programów. 
> Do build'a programów musimy znajdować się w katalogu z danym projektem
Pierwszy budujemy za pomocą 
```
npm install
```
![ss](./ss/ss02.png)

> Niestety moduł dla npm nie jest zainstalowany więc musimy go doinstalować: ```sudo dnf install nodejs``` i spróbować ponownie

![ss](./ss/ss03.png)

Jak widać teraz wszystko zadziałało.

Następnie budujemy drugi program dzięki:
```
meson Build
```

![ss](./ss/ss04.png)

> Tak samo musimy doinstalować odpowiednie moduły. 
> ```sudo dnf install meson```
> Oraz dodatkowo: gcc, glib2-devel, utf8proc*, ncurses*, perl-Ext* oraz ninja*

Gdy wszystkie moduły są już doinstalowane możemy przystąpić do budowy.
```
meson Build
ninja -C /home/DanPer/DevOps/MDO2024_INO/ITE/GCL4/DP412497/Zadanie2/RepTest/irssi/Build
```
> `ninja -C /home/... ` zostało nam przedstawione do wykorzystania po udanym wykonaniu `meson Build`

![ss](./ss/ss05.png)


* Uruchom testy jednostkowe dołączone do repozytorium
Dla obu programów uruchamiamy testy (zaczynając z poziomu katalogu projektu):
```
npm test
```

![ss](./ss/ss06.png)

```
cd Build
ninja test
```

![ss](./ss/ss07.png)

### Przeprowadzenie buildu w kontenerze
### 1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np ```ubuntu``` dla aplikacji C lub ```node``` dla Node.js
#### Dla programu `node-js-dummy-test`

* uruchom kontener
* podłącz do niego TTY celem rozpoczęcia interaktywnej pracy

```
docker run -it node bash
```
> Jeśli nie posiadamy obrazu 'node' zostanie automatycznie pobrany jego :latest obraz.

* zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)
> Podstawowy obraz node posiada w sobie zainstalowane wszystkie podstawowe moduły potrzebne do pracy na projekcie jak i samego git'a.

* sklonuj repozytorium
```
git clone https://github.com/devenes/node-js-dummy-test
```
![ss](./ss/ss08.png)

* uruchom *build*

```
cd node-js-dummy-test
npm install
```

![ss](./ss/ss09.png)

* uruchom testy

```
npm test
```

![ss](./ss/ss10.png)

Jak widać wszystko bezproblemowo działa w kontenerze.

#### Dla programu `irssi`

* uruchom kontener
* podłącz do niego TTY celem rozpoczęcia interaktywnej pracy

```
docker run -it fedora bash
```
> Jeśli nie posiadamy obrazu 'fedora' zostanie automatycznie pobrany jego :latest obraz.

* zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)

Potrzebujemy doinstalować wszystkie wymagane moduły, czyli wszystkie których potrzebowaliśmy doinstalować,
gdy pracowaliśmy na projekcie przed kontenerami, a nawet więcej, gdyż obraz fedory nie posiada w sobie git'a

```
dnf -y install git gcc meson glib2-devel utf8proc* ncurses* perl-Ext* ninja*
```
> -y zaakceptuje automatycznie wszystkie zapytania w trakcie instalacji.

* sklonuj repozytorium

```
git clone https://github.com/irssi/irssi
```

![ss](./ss/ss11.png)

* uruchom *build*

```
cd irssi
meson Build
ninja -C /irssi/Build
```

![ss](./ss/ss12.png)

* uruchom testy

```
cd Build
ninja test
```

![ss](./ss/ss13.png)

Jak widać dla drugiego projektu także wszystko zadziałało poprawnie.

### 2. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
#### Dla programu `node-js-dummy-test`

* Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*
Plik node-builder.Dockerfile : 
```
FROM node
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR node-js-dummy-test
RUN npm install
```
> FROM node - korzystamy z obrazu node

> RUN git clone ... - klonujemy repozytorium

> WORKDIR node-js-dummy-test - ustawiamy katalog 'node-js-dummy-test' jako katalog roboczy

> RUN npm install - budujemy nasz program

> Polecenie RUN w Dockerfilu wywołuje komendy w trakcie budowania kontenera

* Kontener drugi ma bazować na pierwszym i wykonywać testy
```
FROM node-builder - korzystamy z naszego poprzedniego kontenera
RUN npm test - wykonujemy testy
```

#### Dla programu `irssi`

* Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*

```
FROM fedora
RUN dnf -y update && \
    dnf -y install meson ninja* git gcc glib2-devel utf8proc* ncurses* perl-Ext*
RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build
RUN ninja -C /irssi/Build
```

> FROM fedora - korzystamy z obrazu fedory

> RUN dnf -y ... - instalujemy wszystkie potrzebne moduły

> RUN git clone ... - klonujemy repozytorium

> WORKDIR /irssi - ustawiamy katalog 'irssi' jako katalog roboczy

> RUN meson Build

> RUN ninja -C /irssi/Build - budujemy nasz program

> Polecenie RUN w Dockerfilu wywołuje komendy w trakcie budowania kontenera

* Kontener drugi ma bazować na pierwszym i wykonywać testy

```
FROM irssi-builder
WORKDIR /irssi/Build
RUN ninja test
```

### 3. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?

Uruchamiamy nasze Dockerfile'e

```
sudo docker build -t irssi-builder -f irssi-builder.Dockerfile .
sudo docker build -f irssi-tstr.Dockerfile .
```

![ss](./ss/ss14.png)

![ss](./ss/ss15.png)

Jak widać wszystko jest wykonywane w trakcie budowania kontenerów zgodnie z oczekiwanym rezultatem.

> Obraz jest tylko szablonem do odczytu zawierający odpowiednie moduły i biblioteki.
> Kontener jest to działająca instancja zbudowana z obrazu.


> W takim kontenerze nic nie pracuje, ponieważ kończy swoje działania zaraz po starcie gdyż nie ma napisanego żadnego działania.



## Wykonane zadania - Lab 4
---

### Zachowywanie stanu
* Zapoznaj się z dokumentacją https://docs.docker.com/storage/volumes/
* Przygotuj woluminy wejściowy i wyjściowy, o dowolnych nazwach, i podłącz je do kontenera bazowego, z którego rozpoczynano poprzednio pracę

> To zadanie zostaje przeprowadzane w wykorzystaniu repozytorium irssi z poprzedniego zadania.

Przygotowujemy dwa woluminy oraz sprawdzamy czy zostały utworzone na liście dzięki: 

```
docker volume create V_input
docker volume create V_output
docker volume list
```

![ss](./ss/ss17.png)


* Uruchom kontener, zainstaluj niezbędne wymagania wstępne (jeżeli istnieją), ale *bez gita*

```
docker run -d --name fedora_gitless -v V_input:/input -v V_output:/output fedora
```
> Uruchamiając nasz kontener dodajemy -v V_input:/input -v V_output:/output co podłącza woluminy (V_input, V_output) do kontenera, w postaci katalogów (w tym przypadku input, output) w ścieżce głównej w katalogu vol. Jak widać na poniższym screen'ie, nasz kontener posiada na liście oba te foldery.

![ss](./ss/ss18.png)

Następnie instalujemy wymagania wstępne, ale pomijając git'a. Korzystamy z wiedzy z poprzedniego przygotowania środowiska dla repozytorium irssi

```
dnf -y update
dnf -y install meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*
```

* Sklonuj repozytorium na wolumin wejściowy (opisz dokładnie, jak zostało to zrobione)

Aby sklonować repozytorium na wolumin wejściowy jest kilka metod. My posłużyliśmy się metodą, w której klonujemy repo na zewnątrz, a następnie kopiujemy je do wybranego woluminu (odpowiadającemu mu katalogowi w kontenerze)korzystając z `docker cp`, kopiując je ścieżką bezpośrednio do woluminu podpętego w naszym kontenerze.

Najpierw klonujemy repo na zewnątrz w naszym systemie do osobnego katalogu:

```
git clone https://github.com/irssi/irssi
```

Następnie nasze repozytorium kopiujemy do środka kontenera do katalogu odpowiedzialnego za 

```
docker cp katalog/repo/. fedora_gitless:/vol/input
```

> `fedora_gitless` to nazwa naszego kontenera, `:/vol/input` oznacza nasz katalog który jest naszym przypiętym woluminem

![ss](./ss/ss19.png)

* Uruchom build w kontenerze - rozważ skopiowanie repozytorium do wewnątrz kontenera

Dla bezpieczeństwa kopiujemy repozytorium z naszego /input do nowego katalogu `irs`.
Następnie uruchamiamy builda w katalogu repozytorium.

```
cp -r input/. irs/
cd irs/irssi
meson Build
ninja -C /vol/irs/irssi/Build
```

![ss](./ss/ss20.png)

* Zapisz powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.

Kopiujemy nasze zbudowane pliki na wolumin wyjściowy, czyli cały powstały katalog `Build` do naszego katalogu `output`

```
cp -r irs/irssi/Build output/
```

![ss](./ss/ss21.png)

* Pamiętaj udokumentować wyniki.

> Wyniki dokumentowane na bieżąco.

* Ponów operację, ale klonowanie na wolumin wejściowy przeprowadź wewnątrz kontenera (użyj gita w kontenerze)

Do wykonania tego podpunktu instalujemy git'a i uruchamiamy git clone do folderu `input`

```
dnf install -y git
git clone https://github.com/irssi/irssi
```

> Oczywiście repozytorium irssi już jest na woluminie, więc drugi raz nie możemy go sklonować. Ale dla pewności że wszystko działa usuwamy katalog i klonujemy ponownie

```
rm -rf irssi
git clone https://github.com/irssi/irssi
```

![ss](./ss/ss22.png)

* Przedyskutuj możliwość wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`. (podpowiedź: `RUN --mount`)

> Powyższe kroki możnaby było dość prosto zautomatyzować i wykonać za pomocą pliku `Dockerfile`.

> Jedyną rzeczą która mogłaby być problematyczna byłyby woluminy. W Dockerfilu nie możemy tak samo ich stworzyć i podłączyć. I tutaj z pomocą przychodzi `RUN --mount`, który montuje katalogi z zewnątrz do wybranego katalogu wewnątrz kontenera.



### Eksponowanie portu
* Zapoznaj się z dokumentacją https://iperf.fr/
* Uruchom wewnątrz kontenera serwer iperf (iperf3)

Uruchamiamy czysty kontener fedory i instalujemy na nim moduł iperf3

```
docker run -it fedora_iperf_server fedora
.
dnf install -y iperf3
```

A następnie uruchamiamy serwer iperf3 dzięki:

```
iperf3 -s
```

> -s to oznaczenie, że to jest serwer

Zapisujemy adres IP tego kontenera, aby móc się potem połączyć


* Połącz się z nim z drugiego kontenera, zbadaj ruch

Tworzymy kolejny kontener, taki sam jak powyżej

```
docker run -it fedora_iperf_client fedora
.
dnf install -y iperf3
```

Następnie łączymy się z serwerem dzięki:

```
iperf3 -c <IP_ADDRESS> 5201
```

> `<IP_ADDRESS>` jest adresem IP kontenera serwera, a `5201` jego domyślnym portem. -c oznacza client'a.

![ss](./ss/ss23.png)

> Jak widać client połączył się z serwerem bez problemów i ruch między nimi jest stabilny.

* Zapoznaj się z dokumentacją `network create` : https://docs.docker.com/engine/reference/commandline/network_create/
* Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową. Spróbuj użyć rozwiązywania nazw

Korzystając z możliwości docker'a tworzymy własną dedykowaną sieć mostkową dzięki:

```
docker network create fsiec-mostek
```

Następnie uruchamiamy kontener dla serwera, ale z naszą siecią:

```
docker run --network fsiec_mostek -it --name fedora_iperf_server fedora
```

I ponownie startujemy server:

```
iperf3 -s
```

Dzięki naszej sieci możemy połączyć się z serwerem korzystając z nazwy sieci, zamiast adresu IP:

```
iperf3 -c <NETWORK_NAME> 5201
```

* Połącz się spoza kontenera (z hosta i spoza hosta)

Łączymy się z serwerem z naszego hosta, tak samo jak w poprzednim przypadku, korzystając z odpowiedniego adresu IP

```
iperf3 -c <IP_ADDRESS> 5201
```


![ss](./ss/ss24.png)

> Tak samo możemy połączyć się spoza hosta, ale po udostępnieniu portu. (Dodanie `-p 5201:5201` podczas tworzenia kontenera servera)


* Przedstaw przepustowość komunikacji lub problem z jej zmierzeniem (wyciągnij log z kontenera, woluminy mogą pomóc)

Logi z kontenera serwerowego wyciągamy dzięki dockerowi:

```
docker logs fedora_iperf_server
```

![ss](./ss/ss25.png)
