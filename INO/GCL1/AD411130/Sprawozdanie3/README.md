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

Kolejnym miniprojektem jaki należało wykonać

![](zrzuty_ekranu/5.png)

![](zrzuty_ekranu/6.png)

![](zrzuty_ekranu/7.png)

![](zrzuty_ekranu/8.png)

![](zrzuty_ekranu/9.png)

![](zrzuty_ekranu/10.png)

![](zrzuty_ekranu/11.png)

![](zrzuty_ekranu/12.png)

![](zrzuty_ekranu/13.png)

![](zrzuty_ekranu/14.png)

![](zrzuty_ekranu/15.png)

![](zrzuty_ekranu/16.png)

![](zrzuty_ekranu/17.png)

![](zrzuty_ekranu/18.png)






