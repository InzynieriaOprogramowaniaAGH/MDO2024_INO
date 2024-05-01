# Sprawozdanie nr 3
---
## Cel ćwiczenia:
 ## Celem ćwiczenia było 

---

## Streszczenie laboratorium:

###  something

---

## Jenkins

Jenkins – serwer typu open source służący do automatyzacji związanej z tworzeniem oprogramowania. W szczególności ułatwia budowanie, testowanie i wdrażanie aplikacji, czyli umożliwia rozwój oprogramowania w trybie ciągłej integracji i ciągłego dostarczania. 

Tworzymy sieć Jenkins:

![](zrzuty_ekranu/sudo_docker_jenkins.png)

Następnie zgodnie z dokumentacją uzupełniamy uruchomienie z konkretnymi parametrami a natępnie Dockerfile również zgodnie z dokumentacją. 

![](zrzuty_ekranu/run1_jenkins.png)


Budowanie Jenkins:

![](zrzuty_ekranu/myjenkins.png)



![](zrzuty_ekranu/1.png)


Udowadniam że kontener się uruchomił i jest w użyciu na podstawie statusu:

![](zrzuty_ekranu/container.png)

Sprawdzam adres wirtualnej maszyny co będzie mi potrzebne do utworzenia dedykowanego portu w VM dla Jenkins. 

![](zrzuty_ekranu/ipa.png)


Udało się połączyć w przeglądarce z Jenkins:

![](zrzuty_ekranu/mamyto.png)


Panel główny Jenkins uruchomiony z adresu: localhost:8080:

![](zrzuty_ekranu/2.png)


W ramach wstępnej konfiguracji Jenkinsa spróbuję uruchomić zgodnie z poleceniem dwa przykładowe projekty:

- projekt, który wyświetla uname
- projekt, który zwraca błąd, gdy... godzina jest nieparzysta

Według interfejsu Jenkinsa wystarczy utworzyć projekt tak, jak wskazuje to panel w lewym rogu. Ja dla przykładu i praktyki stworzyłem jednoscenowy pipeline który wykonuje docelowe polecenie/funkcję.

W pierwszym przypadku scena o nazwie 'Display OS Name'  wywołuje polecenie 'uname -a'. która wyświetla informacje o systemie - jego pełną nazwę.

![](zrzuty_ekranu/3.png)

Po wykonaniu widzimy, że pole wyświetlające uruchamianie programu jest zielone, co oznacza że obyło się bez żadnych kodów błędu. Program uruchomił się poprawnie i zakończył po niecałej sekundzie.

![](zrzuty_ekranu/4.png)

Obserwując Logi jakie zwraca pierwszy program widzimy informacje szcegółowe o wersji Linux na Ubuntu.

![](zrzuty_ekranu/8.png)

Kolejnym miniprojektem jaki należało wykonać było zwrócenie informacje, czy godzina jest parzysta, czy nieparzysta. W momencie, kiedy jest nieparzysta ma zwracać błąd a zarazem okienko z uruchamianiem programu ma zaświecić się na czerwono. 

Na początku program definiuje obecną godzinę jako liczbę całkowitą Integer. Jeżeli liczba spełnia warunek parzystości to program zwraca pozytywną wiadomosc, a w przeciwnym wypadku zwraca błąd.

![](zrzuty_ekranu/5.png)

Zgodnie z tym co zostało zaimplementowane osiągnięto oczekiwane wyniki. Dla godzin nieparzystych zwrócono błąd co widać na załączonym obrazku:

![](zrzuty_ekranu/6.png)

Konsola wyjściowa dla drugiego miniprojektu:

![](zrzuty_ekranu/7.png)

---
Tym samym wykazałem że Jenkins działa poprawnie, utworzone kontenery się uruchomiły we właściwy sposób, sprawdziłem czy działa wyświetlanie konsoli wyjściowej oraz logów .

---

## Pipeline Build -> Test

Problem z jakim borykałem się jeszcze na poprzednich laboratoriach było to, że wewnątrz kontenera nie byłem w stanie poprawnie uruchomić testów. Komenda 'npm test' próbowała się dostać do 'jest' którego tak naprawdę nie było. Nie dało się tego odczytać. Próbowałem również używać pełnej ścieżki do 'package.json' natomiast npm nie był w stanie odczytać poprawnie tej ścieżki, co było dość zaskakujące. 

![](zrzuty_ekranu/9.png)

W takim wypadku postanowiłem zmodyfikować lekko kod budowania (Dockerfile) i testowania. Na początku spróbowałem do pliku 'test.Dockerfile' dorzucić instalację 'jest' poprzez 'npm'.To z kolei nie przechodziło z racji tego że instalacja 'jest' wymagała zasobów pochodzących od zasobów których jak sie okazało NIE POSIADAM. 

Zatem jest to jasna wiadomość, że trzeba powrócic do builda i COŚ poprawić.

Okazuje się, że 'npm install' w konkretnej wersji npm nie buduje wszystkich zależnośći i muszę skorzystać z 'npm run build' co tak samo muszę poprzedzić instalacją 'babel client' który mi pozwoli ten build wykonać. 


![](zrzuty_ekranu/10.png)

Kolejny problem z jakim się napotkałem to zbyt mała ilość miejsca na partycji. Okazuje się, że domyślnie spośród całości przydzielonego dysku do użytku przydzielona jest tylko połowa, co widać poniżej:

![](zrzuty_ekranu/11.png)

Przez to skończyło mi się miejsce na wykonywanie projektów. Musiałem przejść do procesu rozszerzenia miejsca.

![](zrzuty_ekranu/12.png)

Według znalezionego poradnika należało użyć poniższych komend aby pozwolić na użycie 100% zasobów dysku przydzielonego dla Ubuntu. 

![](zrzuty_ekranu/13.png)

![](zrzuty_ekranu/14.png)

Oprócz rozszerzenia pamięci należało także przydzielić tą pamięć do partycji i tak jak widać na poniższym obrazku udało to się zrobic i teraz mamy 16GB wolnego miejsca czyli tyle ile wcześniej nie byliśmy w stanie wykorzystać. 

![](zrzuty_ekranu/15.png)

Poniżej znajduje się wkonany przeze mnie pipeline definiujący wykonanie etapów clone, build oraz clone. 

Etap 'clone' jest wygenerowany przez odpowiedni skrypt w Jenkins, definiuje przejście na osobistą gałąź, sklonowanie repozytorium. 
Kolejnym etapem jest wykonanie budowania obrazu. Dodaję tu odpowiedni tag obrazu w celu poprawnego rozróżenia. Wskazuję także odpowiednią ścieżkę do buildera.
Podobnie sprawa wygląda z testowaniem programu.

Wszystkie pliku Dockerfile są dołączone do sprawozdania nr 3. 

![](zrzuty_ekranu/pipeline1.png)

Poprawne uruchomienie buildera.

![](zrzuty_ekranu/16.png)

Poprawne uruchomienie testera.

![](zrzuty_ekranu/17.png)

Stage View dla pipeline związanego z powyższym etapem. 

![](zrzuty_ekranu/18.png)













