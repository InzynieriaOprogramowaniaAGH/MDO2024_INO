# Sprawozdanie 3
Maciej Radecki 410206
## Cel ćwiczenia

## 1. Konfiguracja Jenkinsa
Po zainstalowaniu Jenkinsa na podczas wykonywania poprzedniej instrukcji, należało po otwarciu linku http://localhost:8080 wpisać w odpowiednie okno hasło administratora. 
![](../Screeny/3.1.1.1.png)
Hasło to odnalazłem dzięki zamieszczonej ścieżce do poliku na owej stronie, której screen znajduje się powyżej. Następnie przeszedłem do dalszej konfiguracji, niestety zapomniałem udokumentować tych kroków, ale po wpisaniu hasła administratora pojawił się wybór dwóch opcji dostosowania Jenkinsa. Wybrałem opcje "Zainstaluj sugerowane wtyczki" lub coś brzmiącego w tym stylu, w każdym razie zainstalowałem sugerowane przez system opcje. Następnie musiałem podać swoje dane do logowania oraz ustawiłem URL Jenkinsa jako http://localhost:8080/. Po czym moim oczom ukazał się obraz taki jak na poniższym zdjęciu.
![](../Screeny/3.1.1.2.png)
## 2. Pierwsze projekty w Jenkinsie
Na samym początku utowrzyłem nowy projekt o nazwie "uname". Podczas tworzenia użyłem opcji "Ogólny projekt"
![](../Screeny/3.1.2.1.png)
Następnie należało wybrać opcje uruchomienia powłoki również tak jak na screenie ponieżej.
![](../Screeny/3.1.2.2.png)
W oknie tekstowym który się pojawił po wybraniu powyższej opcji wpisałem ```uname``` 
![](../Screeny/3.1.2.3.png)
Tak utworzony projekt zostal zapisany, nastepnie uruchomiony. Logi konsoli tego projektu znajdują się poniżej.
![](../Screeny/3.1.2.4.png)
Następnym projektem było zadanie które działa prawidłowo w przypadku gdy godzina jest parzysta, natomiast w przeciwnym przypadku nie będzie działać. W celu wykonanie tego zadania w ten sam sposób utworzyłem nowy projekt, jednak w powłoce został umieszczony odpowiedni kod który ma zrealizować zadanie.
![](../Screeny/3.1.2.5.png)
Po uruchomieniu programu sprawdzone zostały logi przy różnych godzinach.
![](../Screeny/3.1.2.6.png)
![](../Screeny/3.1.2.7.png)
Poniżej screeny dotyczące przypadku godziny nieparzystej.
![](../Screeny/3.1.2.8.png)
![](../Screeny/3.1.2.9.png)
Ostatnim "prostym" zadaniem do wykonania było utworzenie projektu, tak aby następowało kloniwanie repoztorium, przechodzenie na odpowiednią gałąź, czyli MR410206 oraz budowanie obrazów z dockerfiles. Jak poprzednio został utworzony nowy projekt, ponownie z opcją "ogólny projekt", natomiast w tym przypadku została bygrana opcja "Git" która została uzupełniona dokładnie tak jak na poniższym zdjęciu.
![](../Screeny/3.1.2.10.png)
Powłoka została uzupełniona o poniższy kod.
![](../Screeny/3.1.2.11.png)
Po zapisaniu projektu i uruchomieniu otrzymano poniższe logi.
![](../Screeny/3.1.2.12.png)
## 3. Indywidualny projekt