# Sprawozdanie 3 - Hubert Kopczyński 411077

## Wstęp - Pipeline, Jenkins, izolacja etapów

### Przygotowanie

Przed rozpoczęciem pracy z Jenkinsem, należało upewnić się, że kontenery używane do budowania i testowania aplikacji, które zostały stworzone w ramach jednych z poprzednich zajęć, są w pełni funkcjonalne. Aby to sprawdzić wykonałem następujące kroki:

* Przeszedłem do folderu **lab_03** na mojej maszynie wirtualnej, w którym utworzone były Dockerfile automatyzujące budowanie i testowanie aplikacji **node-js-dummy-test** i zbudowałem na ich podstawie obrazy Docker'a:

![node-app-build](images/node-js-build.png)

![node-app-test](images/node-js-test.png)

Widać na powyższych zrzutach, że obrazy zbudowały się poprawanie więc mogłem przejść dalej.

Uruchomienie Docker'a, który eksponuje środowisko zagnieżdżone oraz przygotowanie obrazu blueocean na podstawie obrazu Jenkins'a opisałem w ramach poprzedniego sprawozdania więc ten podpunkt pominąłem, sprawdziłem jedynie, czy kontenery *docker:dind* oraz *jenkins-blueocean* działają poprawnie:

![dind, blueocean](images/dind-blueocean.png)

Obraz Jenkinsa to standardowy obraz Docker zawierający Jenkins CI, który jest otwartoźródłowym narzędziem automatyzacji o szerokim zakresie zastosowań, ale głównie skoncentrowanym na automatyzacji budowania i testowania oprogramowania. Interfejs użytkownika w klasycznym obrazie Jenkinsa jest bardziej techniczny i może być mniej intuicyjny dla nowych użytkowników. Zawiera on wszystkie funkcjonalności Jenkinsa.

Blue Ocean to plugin do Jenkinsa, który dostarcza nowoczesny interfejs użytkownika, zaprojektowany by ułatwić i usprawnić proces CI/CD, szczególnie dla nowych użytkowników lub mniej technicznych osób. Blue Ocean automatycznie grupuje informacje związane z budową i testami w bardziej czytelne, wizualne reprezentacje, takie jak pipeline'y czy grafy. Umożliwia też łatwiejsze zarządzanie i wizualizację procesów ciągłej integracji i dostarczania.

### Uruchomienie 

Bedąc na głównej stronie Jenkins'a, wybrałem opcję *Nowy projekt*, który nazwałem "Dispaly Uname" a następnie ustawiłem go jako *Ogólny projekt*. Ukazała się wtedy strona do konfiguracji, na niej udałem się do miejca *Kroki budowania*, i dodałem krok budowania *Uruchom powłokę*. Dodałem tam jedynie treść `uname -a`. Konfigurację zapisałem, uruchomiłem build i przeszedłem do logów konsoli w których zobaczyłem:

![uname](images/uname.png)

Następnie należało utworzyć projekt, który zwraca błąd, gdy godzina jest nieparzysta. Utworzyłem projekt tak samo jak poprzedni i wykonałem go jako skrypt bash. Pobiera on aktualną godzinę a następnie sprawdza, czy jest podzielna przez 2, jeśli nie jest, skrypt kończy się błędem `exit 1`, co powoduje, że Jenkins oznaczy build jako nieudany. Skrypt wyglądał w ten sposób:

```
#!/bin/bash

HOUR=$(date +%H)

if [ $((HOUR % 2)) -ne 0 ]; then
  echo "Obecna godzina to $HOUR, czyli nieparzysta."
  exit 1
else
  echo "Obecna godzina to $HOUR, czyli parzysta."
fi
```

Wynik logów z konsoli w momencie, gdy godzina była parzysta i gdy godzina była nieparzysta:

![even hour](images/hour.png)

![odd hour](images/hour_odd.png)

Kolejną rzeczą do zrobienia było utworzenie "prawdziwego projektu", które będzie klonował repozytorium przedmiotowe, przechodził na osobistą gałąź i budował obrazy z Dockerfiles.

Na głównej stronie Jenkins'a ponownie utworzyłem nowy projekt który tym razem był typu *Pipeline*. W konfiguracji projektu przewinąłem do sekcji **Pipeline** a definicję pozostawiłem jako **Pipeline script**. Pipeline będzie zawierał dwa etapy - klonujący repozytorium i budujący obraz Dockerfile. W pierwszej sekcji usuwany będzie katalog *MDO2024_INO* jeśli już taki istnieje, jeśli nie istnieje to zwracana będzie wartość *true*. Następnie klonowane jest repozytorium przedmiotowe z mojej osobistej gałęzi *HK411077*.

W sekcji drugiej budowany jest jedynie obraz z Dockerfile zawierającego build mojej wybranej aplikacji *node-js-dummy-test*. Cały skrypt jest następujący:

```
pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Klonowanie repozytrium'
                sh 'rm -r MDO2024_INO || true'
                git branch: 'HK411077', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Budowanie obrazu builda'
                    sh 'docker build -f ./INO/GCL1/HK411077/Sprawozdanie2/build.Dockerfile -t node-app-build .'
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    echo 'Budowanie obrazu testu'
                    sh 'docker build -f ./INO/GCL1/HK411077/Sprawozdanie2/test.Dockerfile -t node-app-test .'
                }
            }
        }
    }
}
```

Wynik uruchomienia tego projektu:

![first pipeline](images/first_pipeline.png)

Przykładowe logi (z klonowania repozytorium i budowania obrazów):

![klonowanie](images/example_log.png)

![build](images/build.png)

![test](images/test.png)

### Diagramy UML

#### Wymagania wstępne środowiska:
- Sprzętowe:
  - Środowisko wirtualne z dostępem do internetu
  - Pamięć ram i przestrzeni dyskowej umożliwająca obsługę kontenerów DIND i Jenkins
- Oprogramowanie:
  - System operacyjny Ubuntu Server
  - Kontener Jenkins z zainstalowanym pluginem Blue Ocean i DIND skonfigurowany według instrukcji dostawcy oprogramowania
  - Node.js i npm do zarządzania zależnościami projektu
- Siecowie:
  - Dostęp do repozytorium kodu na GitHub'ie

#### Diagram aktywności

![diagram aktywności](images/diagram_aktywnosci.png)

#### Diagram wdrożeniowy

![diagram wdrożeniowy](images/diagram_wdrozeniowy.png)

### Pipeline

W ramach pipeline będę korzystać z kontenerów Docker do izolacji poszczególnych etapów: budowania, testowania, wdrażania i publikowania. Pierwszy etap nie korzysta z konteru Docker, bezpośrednio klonowane jest w nim repozytorium przedmiotowe z GitHub. Pierwsze 2 etay zostały już przeze mnie opisane wcześniej w sprawozdaniu. Trzeci 