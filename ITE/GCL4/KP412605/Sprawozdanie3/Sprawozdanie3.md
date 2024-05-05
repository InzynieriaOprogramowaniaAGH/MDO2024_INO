# Sprawozdanie3
## Karol Przydział 412605

## Laboratoria 5-7

Celem powyższych laboratoriów było wykorzystanie Jenkinsa do automatyzacji procesów build oraz test danego projektu.

W tym celu naszym zadaniem jest utworzenie pipeline'a, aby wykonać na nim schemat budowania, testowania oraz wdrażania aplikacji.

Projekt rozpoczynamy od uruchomienia obrazu dockera. Krok ten był już wykonywany na poprzednich laboratoriach:

![obraz](obraz.png)

### Skrypty

Kolejny krok po uruchomieniu obrazu opiera się już na działaniu bezpośrednio w Jenkinsie.

W tym celu tworzymy pierwszy projekt, który będzie zwracał uname.
Przechodzimy więc do opcji nowy projekt:

![nowyprojekt](nowyprojekt.png)

Następnie wybieramy opcję uruchomienia powłoki i uzupełniamy ją następująco:

![uzupelnienie](unametworzenie.png)

Wynikiem tego są logi konsoli, które przedstawiają się następująco:

![unamewlaczenie](unamewlaczenie.png)

Kolejny etap dotyczy stworzenia projektu sprawdzającego, czy godzina jest parzysta. Jeśli jest nieparzysta program zwraca błąd.

Treść skryptu jest następująca:
```
FROM fedora

#!/bin/bash

hour=$(date +%H)

if [ $((hour % 2)) -eq 1 ]; then
    echo "Błąd: Godzina jest nieparzysta."
    exit 1
else
    echo "Godzina jest parzysta."
    exit 0
fi
```

Z kolei wynik konsoli przedstawia się następująco:

![skryptgodzina](skryptgodzina.png)


### Tworzenie "prawdziwego" projektu, który będzie klonował repozytorium, przechodził na osobistą gałąź i budował obraz dockerfiles.

Rozpoczynam od utworzenia projektu o nazwie "projektgit".

W sekcji `Repozytorium kodu` wybieram opcję `Git`, a następnie wklejam link do repozytorium. Jednak ze względu na to, że repozytorium jest prywatne muszę skonfigurować `Credentials`.
W związku z tym, używam swojego loginu do platformy GitHub wraz z hasłem Personal Access Token.

![git1](git1.png)

Kolejno ustawiam siebie jako użytkownika w Credentials, oraz gałąź, na którą chcę się przełączyć.

![git2](git2.png)

Wynik w historii zadań:

![git3](git3.png)

Logi konsoli:

![git4](git4.png)

Jak widzimy skrypt działa prawidłowo.

### Edycja "prawdziwego" projektu, w celu budowania obrazów Dockerfile.

Rozpoczynam od edycji skryptu, który wcześniej dodałem:

![gitskrypt3](gitskrypt3.png)

Efektem tego jest prawidłowe działanie skryptu.

![gitskrypt1](gitskrypt1.png)
![gitskrypt4](gitskrypt4.png)
![gitskrypt5](gitskrypt5.png)

### Dokument wraz z diagramami UML.

Pracę wykonuję na środowisku CI/CD określonym jako Jenkins. Korzystam z kodu źródłowego pobranego z repozytorium `spring-petclinic`. W pobranym repozytorium znajduje się również dodany przeze mnie plik `Dockerfile-builder` oraz `Dockerfile-tester` wraz z plikiem `Jenkinsfile`.

Diagram aktywności.

Diagram ten przedstawia kolejne etapy - rozpoczynając od Prepare i kończąc na Publish wraz z archiwizowaniem artefaktów.

![diagramaktywnosci](diagramaktywnosci.png)

Diagram wdrożeniowy pokazujący zależności.

![diagramwdrozenia](diagramWdrozenia.png)

### Definiowanie Pipeline'a.

#### W przypadku definiowania Pipeline'a mamy dwie opcje - możemy uruchomić go bezpośrednio w kontenerze bądź korzystając z Docker-in-Docker (DIND).

- Budowanie na kontenerze - jest to metoda wydajniejsza ze względu na fakt, iż nie pojawia się dodatkowa warstwa kontenera wewnętrznego. Jednak w kwestii zarówno bezpieczeństwa jak i zarządzania zasobami może okazać się niewystarzające.

- Docker-in-Docker (DIND) - w tym przypadku sytuacja jest nieco inna. DIND zapewnia dużo większe bezpieczeństwo, ponieważ uruchamianie bezpośrednio w kontenerze powoduje, że Docker może uzyskać dostęp do zasobów systemowych hosta. Ponadto, w przypadku Docker-in-Docker można zarządzać zasobami każdego kontenera niezależnie od siebie, co może być trudne w przypadku budowy bezpośrednio na kontenerze, ponieważ tam Docker ma dostęp do wszystkich zasobów hosta.

Wybór między DIND a budowaniem bezpośrednio w kontenerze zależy jednak od nas i tego jakie mamy wymagania oraz preferencje. Musimy wtedy sugerować się wieloma kwestiami, między innymi zasobami, bezpieczeństwem ale także wydajnością.


### Rozpoczynam fork repozytorium.

![springpetclinic1](springpetclinic1.png)
![springpetclinic2](fork2.png)

Repozytorium, które sforkowałem pojawia się na moim GitHubie.

![fork3](fork3.png)

`Repozytorium określa, że wstępne wymagania to minimum wersja 17 Javy oraz Gradle/Maven.`

### Sprawdzam czy licencja umożliwi mi działanie na repozytorium w kontekście zajęć.

![licencja2](licencja2.png)
![licencja](licencja.png)

### Tworzę pliki Dockerfile-builder oraz Dockerfile-tester, które następnie dodaje do sforkowanego repozytorium.

Zawartość poszczególnych plików:

Dockerfile-builder:

```
FROM gradle:latest

WORKDIR /app

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/spring-projects/spring-petclinic


WORKDIR /app/spring-petclinic
```
Dockerfile-tester:
```
FROM spring-builder:latest

RUN ./gradlew build -x test
```

Kod z poziomu GitHuba:

![builder](builder.png)
![tester](tester.png)

### Tworzę nowy projekt Pipeline.

![pipeline1](pipeline1.png)

Następnie modyfikuję `Build Triggers`.

![pipelineteraz](pipelineteraz.png)

Ostatecznie piszę skrypt pipeline.

![pipeline2](pipeline2.png)

Opis każdego z etapów wraz ze screenami.

- Collect - Ten etap polega na pobieraniu źródeł kodu lub artefaktów z repozytorium kodu lub innych źródeł.
Może to obejmować pobieranie kodu ze systemu kontroli wersji, takiego jak między innymi Git.

![collect](collect.png)

- Build - W tym etapie kod jest kompilowany, budowany lub pakowany w gotowe artefakty, które mogą być uruchamiane lub wdrażane.
Etap budowania jest często wykonywany za pomocą narzędzi takich jak Maven, Gradle, Make, Docker.

![build](build.png)

- Test - Etap testowania polega na automatycznym lub manualnym wykonywaniu testów na zbudowanych artefaktach w celu zweryfikowania, czy spełniają one określone wymagania jakościowe i funkcjonalne.

![test](test.png)

- Publish - W tym etapie zbudowane i przetestowane artefakty są publikowane w repozytorium artefaktów, gdzie są dostępne dla innych członków zespołu lub systemów wdrażania.

- Deploy - Etap ten polega na wdrożeniu zbudowanych i przetestowanych artefaktów do środowiska produkcyjnego, testowego lub innego środowiska docelowego.

![publish1](publish1.png)
![publish2](publish2.png)

### Uruchamiam utworzony Pipeline.

![stage1](stage1.png)

Logi konsoli po włączeniu skryptu.

![logikonsoli1](logistage1.png)

Następnie dodaję plik Jenkinsfile do sforkowanego repozytorium.

![jenkinsfile](jenkinsfile.png)

Zmieniam ustawienia Pipeline'a tak, żeby uruchamiał się automatycznie w momencie, kiedy nastąpią zmiany w gałęzi main.

![koncowka1](koncowka1.png)

Po wprowadzeniu zmian dodaję przykładową modyfikację do pliku Dockerfile-builder.

![konowka2](koncowka2.png)

Wynikiem tego jest automatyczne budowanie projektu, co jest pokazane na poniższym screenie.

![stageview](stageviewfinal.png)

#### Czy opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze bez modyfikacji (acz potencjalnie z szeregiem wymaganych parametrów, jak obraz DIND)?

Tak, opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze bez modyfikacji. Musimy jednak pamiętać ze etapy muszą się wykonać, a w przypadku wykorzystania DIND możemy potrzebować więcej danych.

#### Czy dołączony do jenkinsowego przejścia artefakt, gdy pobrany, ma szansę zadziałać od razu na maszynie o oczekiwanej konfiguracji docelowej?

Tak, jednak jego działanie zależy od kilku czynników. Należy upewnić się, że wszystkie zależności są zachowane a konfiguracja maszyny jest taka sama jak konfiguracja środowiska. W innym przypadku mogą pojawić się błedy, które trzeba poprawiać.