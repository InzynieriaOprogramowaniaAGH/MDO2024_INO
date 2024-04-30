# Sprawozdanie 3

---
# Pipeline, Jenkins, izolacja etapów

## Magdalena Rynduch ITE GCL4

Celem laboratorium było zapoznanie się z tworzeniem Pipeline’ów w Jenkinsie i umieszczenie w nim etapów w ramach procesu CI/CD.

Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu

Do zrealizowania laboratorium posłużyłam się oprogramowaniem, z którego korzystałam na poprzednich zajęciach. Dysponuje ono licencją MIT. 
Jest to otwarta licencja oprogramowania zapewniająca użytkownikom swobodę w używaniu, modyfikowaniu oraz rozpowszechnianiu oprogramowania, 
zarówno w formie oryginalnej, jak i zmodyfikowanej. Oprogramowanie zostało wykonane w środowisku Maven. W budowie aplikacji tego typu wyróżnia 
się operacje takie jak np. compile (kompilującą kod źródłowy) oraz test (przeprowadzającą testy jednostkowe). Oprogramowanie zawiera zdefiniowane 
i obecne w repozytorium testy (src/test), które można uruchomić i uzyskać jednoznaczny raport końcowy.
Link do repozytorium: https://github.com/jitpack/maven-simple 

Laboratorium rozpoczęłam od instalacji Jenkinsa z pomocnikiem DIND.
Ściągnęłam obraz dockera za pomocą `docker image pull docker:dind`, a następnie go uruchomiłam. (eksponuje środowisko zagnieżdżone)

![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/2a75c0f4-50a9-4bc0-b1e1-da03d6f5b56f)

W celu zbudowania obrazu Blueocean, stworzyłam plik `Dockerfile` i umieściłam w nim odpowiednią zawartość z oficjalnej strony. 

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c7233dc2-1e86-402c-95ca-0adc4bd0c892)

Następnie uruchomiłam zbudowany obraz.

![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/483bf5c4-ebcf-4845-b387-2cdc73fbf333)

Kolejnym krokiem była konfiguracja i rejestracja w Jenkins przy pomocy UI. W tym celu otworzyłam przeglądarkę i wpisałam adres url składający się 
z adresu ip maszyny wirtualnej oraz nasłuchiwanego portu :8080.

![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e2ffdd9c-6554-4b69-8a1d-59eff1512afb)

Hasło administratorskie wyświetliłam wykonując `cat` wewnątrz działającego kontenera i wskazując adres pliku `/var/Jenkins_home/secrets/initialAdminPassword`. 
Następnie wprowadziłam je na stronie metodą „kopiuj wklej”.

![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/24e6a92a-8b6e-4562-a30a-d78294e44621)

Zainstalowałam sugerowane wtyczki i podążałam według instrukcji na stronie. Wprowadziłam dane administratora i pominęłam konfigurację bazowgo adresu URL. Po 
zakończonej konfiguracji wyświetliła się strona główna po zalogowaniu. 
 
![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/59bd7d55-5b3c-4b94-b215-ee2e1ac96d73)

Korzystając z UI przeszłam do tworzenia pierwszych projektów.

Przeszłam do sekcji `Nowy projekt`i podążałam za instrukcją. Podałam nazwę projektu `projekt1` i wybrałam typ `Ogólny projekt`. Skonfigurowałam projekt tak 
aby wyświetlał wszystkie dostępne informacje o systemie. W tym celu dodałam krok budowania, który uruchamia powłokę i wykonuje komendę `uname -a`.

![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1fcc78a9-6430-4b46-907a-41da1f231d30)

Rezultat działania `pojekt1`:
 
![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/03ee92e9-3722-48ac-bd47-eaf4a63a0f74)

`Projekt2` stworzyłam w sposób analogiczny i skonfigurowałam tak aby zwracał błąd, gdy godzina jest nieparzysta.

![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/807f5aa4-3d90-4c24-9d63-6d1545dca07a)

Rezultat `Projekt2` dla godziny nieparzystej.

![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/da765c2a-c6aa-470e-870d-ffcebfa55c81)

Rezultat `Projekt2` dla godziny parzystej.

![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/dcb428a5-2624-45fc-a386-de514f8943de)

Godziny wykonania zadań widoczne są w `Historii zadań` w głównym widoku projektu. Porównując otrzymane wyniki z godzinami kiedy zadania zostały wykonane, można 
wywnioskować, że projekt działa prawidłowo.

![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b1aaad2c-85d6-41a5-981e-4b3dda1828a7)

Następnie stworzyłam główny projekt typu `Pipeline` o nazwie `projekt3`. Jego zadaniem było sklonowanie repozytorium przedmiotu, przejście na osobistą gałąź, zbudowanie 
obrazów z Dockerfiles utworzonych w ramach poprzednich laboratoriów, przeprowadzenie wdrożenia, przygotowanie artefaktu oraz dodanie go do historii builda.
Kroki te realizowane są w ramach ścieżki krytycznej czynności CI/CD:
•	 clone
•	 build
•	 test
•	 deploy
•	 publish

Ostateczny szkielet pipeline'u:
```
pipeline {
    agent any
     stages {
        stage('Clone') {
            steps {
                script { ... }
                dir('MDO2024_INO') {
                    script {
                        ...
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {...}
            }
        }
        stage('Test') {
            steps {
                script {...}
            }
        }
        stage('Deploy') {
             steps {
                script {...}
            }
        }
        stage('Publish') 
             steps {
                script {...}
            }
        }
    }
}
```

Po stworzeniu projektu przeszłam do zakładki `Configure` i w sekcji Pipeline definiowałam kroki.
Etap `Clone` rozpoczyna się od usunięcia repozytorium w folderze `MDO2024_INO`, jeżeli takie istniało. Następnie klonowane jest repozytorium z uwzględnieniem osobistej gałęzi
(`MR412777`), ponieważ tam znajdują się pliki Dockerfile potrzebne do zbudowania obrazów.

```
                    sh 'rm -rf MDO2024_INO'
                
                    sh 'git clone -b MR412777 https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO'
```

Wykonanie fork własnej kopii repozytorium umożliwiłoby bardziej niezależną pracę nad projektem, jednak nie było ono konieczne w tym przypadku.

Następnie z poziomu katalogu `MDO2024_INO` sprawdzana jest obecna gałąź i jeżeli nie jest to `MR412777` to wykonuje na nią checkout.

```
                dir('MDO2024_INO') {
                    script {
                        
                        def currentBranch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                        
                        if (currentBranch != 'MR412777') {
                            sh 'git checkout MR412777'
                        }
                        
                    }
                }
```

Etap `Build` odpowiada za stworzenie obrazu `build_image`  kompilującego program. Jeżeli taki obraz (powstały w wyniku poprzedniego uruchomienia projektu) już 
istnieje to go usuwa i tworzy nowy z pliku `Dockerfile.build`.

```
                    def output = sh(script: 'docker images', returnStdout: true).trim()
                    
                    def buildImageExists = output.contains('build_image')
                    
                    if (buildImageExists) {
                        
                        sh 'docker rmi build_image'
                        
                    }
                    
                    docker.build('build_image', "-f /var/jenkins_home/workspace/projekt3@2/MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie3/Dockerfile.build .")

```

Etap napisania odpowiedniego pipeline’u dla `Build` wiązał się w występowaniem różnych błędów. Jeden z problemów dotyczył kompilacji kodu źródłowego w Maven. 
Wystąpił konflikt kompilatora Java z docelowymi wersjami, które uznał za przestarzałe.

![13d](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9e380d2e-8196-4de0-a9d3-15dd6f9fe122)

W repozytorium w pliku `pom.xml` znajduje się fragment, który konfiguruje plugin Mavena `maven-compiler-plugin` tak aby kompilował kod źródłowy Javy na poziomie 
wersji 1.7, generując kod bajtowy zgodny z Javą 7.

![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/89a319cd-cc29-4057-960e-250f3bfd58ba)

Problem można by było rozwiązać modyfikując powyższy fragment kodu, jednak nie jest to możliwe ze względu na brak uprawnień do wprowadzania zmian w repozytorium.

Błąd nie występował na poprzenich laboratoriach. Oznacza to, że na kontenery powstałe bezpośrednio na maszynie wirtualnej oraz na DIND mogą różnić się między
sobą domyślnie instalowanymi wersjami Java. Dlatego też zmiany w samej konfiguracji mogłyby poskutkować brakiem kompatybilności w drugą stronę. 
Najbardziej uniwersalnym rozwiązaniem jest zatem dokładniejsze dostosowanie środowiska wewnątrz obrazu. Sprawdziłam, więc jaka wersja Java była automatycznie instalowana 
wewnątrz kontenera tworzonego z poziomu maszyny wirtualnej.

![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9d2a7203-5c34-461e-8a4f-eabdda1c0a27)

Okazało się, że była to Java 11, dlatego w pliku `Dockerfile.build` uwzględniłam instalację tej wersji.
Porównanie zawartości `Dockerfile.build` przed i po.

![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c80f4c3d-83ee-452b-874f-2ad5d08e5f47)

W trakcie pracy pojawił się również inny niespodziewany błąd ze strony Jenkins’a. W przypadku jednego z uruchomień projektu z niewiadomych przyczyn klonowanie 
repozytorium zajmowało znacznie więcej czasu. Krok, który zazwyczaj kończył się po ok. 1 min, trwał ponad 10 min do momentu aż nie wymusiłam zatrzymania.  

![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/04ab0dbd-e552-4247-9ce7-15634f5af0bb)

Gdy ponownie uruchomiłam projekt, kroki tworzenia obrazów nie powiodły się.

![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7aebe7ea-d779-4161-a6e1-2b945037550b)

Przyczyną okazała się zmiana nazw katalogów w przypadku wymuszania przerywania wykonywania zadań.

![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c3680044-380c-4ca9-ba7d-0083594a5051)

Funkcję katalogu `projekt3` zaczął pełnić nowo powstały katalog `projekt3@2`. Po wymuszeniu zatrzymania zadania stary katalog nie został usunięty, lecz jego 
zawartością stał się pusty folder.

![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/16b413ba-943b-4da1-8f58-cfce02e914b4)

Błąd występował, ponieważ etap budowania obrazów wskazywał na złą ścieżkę lokalizacji plików Dockerfile. Wystarczyła zmiana w definicji ścieżki z `projekt3`na 
`projekt3@2` aby rozwiązać problem.

![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e152764f-0295-44b3-a06d-6af5dbc99209)
 
Etap `Test` odpowiada za stworzenie obrazu `test_image`. Jeżeli taki obraz (powstały w wyniku poprzedniego uruchomienia projektu) już istnieje to go usuwa i 
tworzy nowy z pliku `Dockerfile.test`. Obraz ten buduje się w oparciu o obraz powstały w poprzednim kroku i wykonuje testy. Jego wynik potwierdza czy obraz `build_image` 
został zbudowany prawidłowo.

```
                    def output = sh(script: 'docker images', returnStdout: true).trim()
                    
                    def testImageExists = output.contains('test_image')
                    
                    if (testImageExists) {
                        
                        sh 'docker rmi test_image'
                        
                    }
                    
                    docker.build('test_image', "-f /var/jenkins_home/workspace/projekt3@2/MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie2/Dockerfile.test .")

```

Na etapie `Deploy` obraz przygotowywany jest pod wdrożenie. Uruchamiany jest kontener docelowy z obrazu `image_build`. W tym przypadku kontener buildowy nadaje się do
wykonania deploya, ponieważ zapewnia spójnośc i powtarzalność procesu w wyizolowanym środowisku. Wewnątrz kontenera wykonywane są testy 
weryfikujące, czy aplikacja pracuje poprawnie. Następnie tworzone są artefakty za pomocą `mvn deploy` z odpowiednim parametrem DaltDeploymentRepository wskazującym 
na lokalizację, w jakiej ma zostać umieszczony artefakt.

```
                    def container = sh(returnStdout: true, script: 'docker run -itd --name app build_image').trim()
            
                    sleep time: 10, unit: 'SECONDS'
                    
                    sh "docker exec app sh -c 'cd maven-simple && mvn test'"
            
                    sh "docker exec app sh -c 'cd maven-simple && mvn deploy -DaltDeploymentRepository=myRepo::default::file:/maven-simple/artifact'"
```
 
Ostatnim krokiem w pipeline’ie jest `Publish`. Artefakty są tutaj kopiowane z kontenera i umieszczane w numerowanych folderach. Są one wersjonowane na podstawie czasu
w jakim zostały wykonane. Nazwy zawierają w sobie datę oraz dokładną godzinę stworzenia katalogu. 

```
                    def currentDate = new Date().format('yyyyMMdd-HHmmss')
                    
                    def targetDirectory = "artifact_${currentDate}"
                    
                    sh "mkdir -p artifacts/${targetDirectory}"
        
                    sh "docker cp app:/maven-simple/artifact /var/jenkins_home/workspace/projekt3@2/artifacts/${targetDirectory}"
        
                    sh "docker stop app || true" 
                    
                    sh "docker rm app || true"
                    
                    archiveArtifacts "artifacts/${targetDirectory}/**/*"
```

Artefakty są załączane jako rezultaty w Jenkinsie z możliwością pobrania ze strony.

![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/a77547a6-52fe-48ce-bb7d-916d505c751d)

Artefakt składa się z plików różnego typu. Najbardziej charakterystycznymi w kontekście projektów Java są pliki `.jar`, ponieważ zawierają skompilowany kod aplikacji lub biblioteki, 
które mogą być wykorzystywane przez inne projekty. Pozostałe pliki (`.xml`, `.pom`) są używane m.in. do zarządzania projektem oraz do weryfikacji integralności plików.
