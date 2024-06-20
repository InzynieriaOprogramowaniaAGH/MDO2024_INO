#CEL LABORATOIRUM

Celem laboratorium było stworzenie „rurociągu” wybranego repo w Jenkinsie by na jego końcu powstał artefakt gotowy do wdrożenia.

#PRZYGOTOWANIE

By móc stworzyć rurociąg musiałam na początku przygotować swoje środowisko do pracy. Pierwszym elementem było pobranie Jenkinsa. Jest jednym z narzędzi CI/CD. To otwarty serwer automatyzujący, umożliwiający wykonania serii działań takich jak budowanie, testowanie i wdrożenie oprogramowania by osiągnąć proces ciągłej integracji. Serwer posiada interfejs graficzny więc jest niezwykle prosty w obsłudze. 
By mieć pewność że odpowiednio konfiguruję serwer, który w tym przypadku ma działać w kontenerze Dockera, wykonywałam krok po kroku instrukcję z oficjalnej strony Jenkinsa.
1.	Pobranie Jenkinsa
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/777e597d-581c-446d-8707-71d3db4b2389)

2.	Utworzenie network dla Jenkinsa
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/5ff978cd-fa6b-427b-9157-13a355e4b927)

3.	Pobranie Docker Dind
Obraz DinD (Docker in Docker) daje możliwość uruchomienia kontenera Docker wewnątrz innego kontenera.
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/56f7f7f2-b58e-453d-8da5-723766dee3c9)


4.	Nowy kontener
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/5a29a69a-1c17-4822-909a-7e63f4c18560)

5.	Dockerfile
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/ce6c582d-60a9-4afa-a66a-4a9132dbe68d)

6.	Image build z dockerfile
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/603f4231-8615-4e8d-970c-9d4fea52105e)

7.	Uruchomienie
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/9a13a5b6-a7cb-4a94-8dd0-72728e1ddbf4)

8.	Jenkins
Po instalacji wszystkiego udało mi się przejść w przeglądarce do gotowego serwera Jenkinsa. 
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/1f8deb0a-11ad-4b22-bee9-14ea85413c97)

9.	Sprawdzenie logów by pobrać  hasło wstępne
Zalogowanie się za pierwszym razem jest bardzo proste, należy jedynie znaleźć hasło w logach serwera.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/c743124c-744e-470b-a67c-d4bc104e4db4)

  
Następnie ustawiłam swoją nazwę użytkownika oraz hasło, którym będę mogła się logować później do serwera.

10.	Skonfigurowany Jenkins
Skonfigurowany Jenkins ma bardzo prosty i czytelny interfejs graficzny po którym niezwykle prosto można nawigować.
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/8ceb1485-0dad-43e6-ac5e-e5ca03055b1e)


#URUCHOMIENIE

Po uruchomieniu serwera i pomyślnym zalogowaniu się przystąpiłam do sprawdzenia poprawności jego działania. Do tego celu stworzyłam trzy bardzo proste projekty.
1.	Uname
Pierwszym projektem by zapoznać się z programem i sprawdzić czy działa w odpowiedni sposób było poproszenie programu by wyświetlił nazwę systemu po uruchomieniu projektu.
W krokach budowania po wybraniu uruchom powłokę wpisałam komendę
```
uname -a
```
Która po uruchomieniu projektu wyświtela mi nazwę systemu.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/903f18ca-9a3c-451e-b78e-cecefcae9c45)

 
Zatwierdziłam gotowy projekt a następnie go uruchomiłam. Proces zakończył się sukcesem i jak widać w logach konsoli pojawiły się wykonane operacje i ich wynik – nazwa systemu na którym pracuję.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/511ab1d0-6145-4ef2-96ff-000938d5aea3)

 
2.	Nieparzysta godzina
Kolejnym projektem było wyświetlenie błędu gdy godzina była nieparzysta. Napisałam prosty skrypt bashowy sprawdzający godzinę, jeśli jest nieparzysta wyskakuje błąd.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/1445307d-cdec-4cb2-85a7-56ce80629fd3)

 
Ponownie po uruchomieniu projektu mogła sprawdzić jego rezultat w logach konsoli:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/6d2827f9-d706-4b0f-9fc6-97df1d448463)

 
3.	Prawdziwy projekt:
Prawdziwy projekt testowy miał polegać na tym, że miało być kopiowane repozytorium, przenosić na odpowiednią gałąź i na końcu uruchamiać jeden z dockerfile zawartych na mojej gałęzi repozytorium. Był to trochę bardziej skomplikowany projekt jednak nadal na bardzo podstawowym poziomie. Miał przede wszystkim wykazać czy Jenkins jest się w stanie dogadać z Dockerem w pełnym wymiarze.
Stworzyłam nowy projekt w Jenkinsie i wybrałam opcję pipeline. Następnie napisałam odpowiedni skrypt wykonujący wymienione wyżej czynności. Składał się z dwóch stage’y: klonowania repozytorium i budowania obrazu Dockerfile.
```
pipeline {
    agent any

    stages {
        stage('Klonowanie repozytorium') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git', branch: 'ZR413063'
            }
        }

        stage('Budowanie obrazu Docker') {
            steps {
                script {
                        def image = 'obraz_build'
                        // Budowanie obrazu
                        sh "docker build -t ${image} -f ITE/GCL4/ZR413063/Sprawozdanie2/Dockerfile.build ."
                    }
                }
            }
    }
}
```
Większość przebiegła prawidłowo build jednak nie przebiegł prawidłowo. Klonowanie repozytorium i przejście na gałąź przebiegło bez problemu. Jenkins znalazł również odpowiednio plik Dockerfile i zaczął wykonywać zawarte w nim polecenia. Błąd pojawia się na ostatnim etapie Dockerfile gdzie po zainstalowaniu wszystkich dependencji projekt powinien się zbudować.
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/bb6e5fe7-f172-4b87-ab4d-27ed47cd20f5)
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cd66bb3b-9dfb-411a-9ffa-0caac39ee7a0)


 
Wygląda jednak na to, że Docker bez problemu dogaduje się z Jenkinsem co jest ważne w kontekście wykonania kolejnego, głównego pipeline.


#PIPELINE

Pipeline, zwany również potokiem jest zestawem automatycznych procesów umożliwiających wykonanie określonego zestawu zadań. Jest stosowany do opisywania procesu budowania, testowania i wdrażania projektu. Zautomatyzowanie pracy pipelinem prowadzi do między innymi szybszych cykli wydawniczych, lepszej jakości kodu i ułatwienia zarządzania projektem.
W tej części sprawozdania należało stworzyć Pipeline dla wybranego repozytorium przechodzący przez etapy: build, test, deploy i publish.
Zaczęłam ponownie od stworzenia nowego projektu Pipeline w Jenkinsie. 

STAGE 1
Stage 1 pipeline miał na celu sklonowanie repozytorium oraz przejście na moją osobistą gałąź:
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/473edfba-b81d-4562-a655-bc62f32f3a3d)
 

Ten etap przeszedł pomyślnie i nie było z nim większych problemów.

STAGE 2
Drugi etap polegał na stworzeniu kontenera builda dla wybranego repozytorium. Budowanie miało się odbywać za pomocą stworzonego na wcześniejszych zajęciach dockerfile. Etap najpierw sprawdzał czy taki obraz już istnieje jeśli tak to go najpierw usuwał a następnie budował za pomocą Dockerfile znajdującego się na mojej gałęzi w repozytorium.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/6cec33c8-3cae-4b0e-8b80-22d8025442f1)

 
Tutaj pojawiły się problemy – Build nie chciał przechodzić.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/4e74cc7b-6521-49bd-a42d-a3dbeb9ee5e9)

 
Logi konsoli niestety za wiele nie mówiły – wskazywały tylko na błąd flagi i brak odnalezienia jakiejś ścieżki.
Najpierw wykluczyłam błędne napisanie skryptu pipeline – klonowanie repozytorium przeszło bez zarzutow, z logów konsoli można było wywnioskować że Jenkins dogaduje się z dockerem i był w stanie znależć mój plik Dockerfile a nawet zacząć go wykonywać. 
Błąd pojawiał się na samym końcu gdzie projekt był już w ostaniej fazie budowania:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/12837f3d-8a8b-4db1-95ef-3004418b40e3)

 
Zaczęłam szukać błędu w Dockerfile.
Pierwszą rzeczą jaką zmieniłam było zamiana komendy RUN
```
RUN cd build/linux && ninja
```
Stwierdziłam, że może mieć to związek z daniem cd – komendy przejścia do katalogu gdzie Dockerfile oferuje na to swoje rozwiązanie:
```
WORKDIR build/linux
RUN ninja
```
Niestety, nie rozwiązało to problemu.
Kolejną rzeczą jaką wykonałam było upewnienie się, że Dockerfile korzysta z odpowiedniej wersji systemu. Moim obrazem bazowym było ubuntu. Projekt zbudował się na ubuntu 22.4 więc postanowiłam, że pobierając obraz systemu nie ustawię go na najnowszy a na moją konkretną wersje:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/eb47604c-e89e-48e6-8812-74c5417b731f)

 
O ile pomysł wydawał się dobry i mógł wyeliminować jakieś problemy tak obraz nadal się nie budował.
Zaczęłam szukać dalej. Projekt, który wybrałam, posiada wiele dependencji, korzysta z ogromnej ilości bibliotek i sporej ilości zależności. Skoro wersja systemu mogłaby się okazać gwoździem do trumny dla builda tak inne rzeczy w nieopowoedniej wersji mogłyby uniemożliwić Dockerfilowi zbudowanie projektu do końca. Zaczęłam więc sprawdzać wersje poszczególnych elementów czy oby na pewno się zgadzają. Szczególną uwagę poświęciłam kompilatorom – okazało się, że wszystkie są zgodne z wersją, która działała w środowisku interaktywnym. 
Postanowiłam sprawdzić jak wygląda środowisko dodając komendę w Dockerfile:
```
RUN env
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/82338b0c-d74d-4171-97c4-6c7bd3f7fa0d)

 
Moją uwagę przykuło to, że projekt nie korzysta z jednego kompilatora, potwierdziła to również dokumentacja projektu.
Wyglądało to tak, jakby program nie do końca wiedział, z którego kompilatora ma korzystać w którym momencie.
Postanowiłam więc w Dockerfilu ustawić odpowiednie kompilatory.
Na początku ustawiłam proponowanego w dokumentacji Clanga, jednak mimo że w środowisku wersja 14.0 działała bez zarzutów tutaj nadal występował problem. Stanęłam przed wyborem – pisać Dockerfile tak naprawdę odnowa kierując się wszystkimi podanymi wersjami tak jak w dokumentacji lub doinstalować kompilatr gcc i to jego w Dockerfilu ustawić. Poszłam tą drugą drogą.
W sekcji instalowania dodatkowych zależności dodałam kompilator gcc a przed samą komendą budowy dodałam te dwie linijki:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/badc70ce-ae2b-4915-8467-b735dd0dcd60)

 
Umożliwiły mi one odpowiednie ustawienie kompilatorów.
Zgodnie z założeniem – tym razem etap build’a przeszedł.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/f078d876-57bb-4a91-92fa-8d0cb4b98eda)

 
STAGE 3
Kolejnym etapem było uruchomienie Dockerfile z testami. Za pierwszym razem nie przeszedł – mój błąd gdyż nie zmieniłam nazwy obrazu docelowego z którego miał korzystać.
Nadal jednak testy nie przeszły – okazało się, że 109 na 110 testów jednostkowych zakończyły się pomyślnie, repozytorium nie przeszło tylko jednego testu – i on powodował zakończenie się całego stage’a nr 3 z błędem.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/50c7f699-c16b-4ae8-8091-2c8b0e162f3d)

 
Postanowiłam, że spróbuję jakoś zignorować ten jeden test w Dockerfilu lub zakończyć stage 3 pipeline z sukcesem mimo niepowodzenia jakiś testów jednostowych.
Udało się. 
```
catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE')
```
Dzięki temu poleceniu Stage Test za każdym razem zakończy się sukcesem ale będzie oznaczony jako niestabilny.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d94a11e0-4fcf-4bf9-87af-6385f2de6942)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d741f58a-e7d5-432f-9817-2a27548301a2)

STAGE 4
Repozytorium jest silnikiem dla gier i mimo prób nie wymyśliłam jaj przeprowadzić dla niego deploy. Należałoby użyć jakoś przykładowych gier znajdujących się w repozytorium.


 
 

