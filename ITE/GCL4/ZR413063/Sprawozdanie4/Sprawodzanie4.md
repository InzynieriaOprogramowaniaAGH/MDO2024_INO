CEL LABORATORIUM
Celem laboratorium było przygotowanie nowej maszyny wirtualnej, na której testowane będzie oprogramowanie Ansible zainstalowane na głównej maszynie.

PRZYGOTOWANIE
Laboratorium rozpoczęłam od stworzenie nowej maszyny wirtualnej analogicznie do poprzedniej. Użyłam tego samego systemu Ubuntu.
 
Zadbałam o to by zainstalować usługę OpenSSH:
 
Zainstalowałam również tar:
```
Sudo apt-get install tar
```
 
Kolejnym krokiem było utworzenie migawki nowej maszyny wirtualnej:
 
Kolejnym krokiem było zaistalowanie zarządcy Ansible na starej maszynie wirtualnej.
```
Sudo apt-get install ansible
```
 
Następnie przystąpiłam do próby zalogowania ze starej maszyny wirtualnej do tej nowej.
Wymieniłam je kluczami
```
ssh-copy-id ansible@ansible-target
```
 
Następnie podjęłam próbę połączenia się z nową maszyną:
```
Ssh ansible@ansible-target
```
 
 
W tym momencie, jestem w stanie zalogować się do ze starej maszyny do nowej bez użycia hasła.

INWENTARYZACJA
W części inwentaryzacji zaczęłam wykonywać po kolej instrukcję:
•	Ustaliłam przeiwydalne nazwy maszyn dzięki
```
Hostnamectl
```
 
 
Obie maszyny widzą się nawzajem tylko za pomocą ich nazw hostname – sprawdziłam to poleceniami:
```
Ping ubuntuserver
Ping ansible-target
```
 
 
Następnie stworzyłam plik inwentaryzacyjny i dodałam do niego obie maszyny wirtualne:
 
Za pomocą pliku i modułu ansible wysłałam żądanie ping do obu maszyn 
```
ansible -i inventory.ini -m ping all
```
Niestety nie udało się:
 
Powstały dwa problemy – ubuntuserver połączył się z hostem z konkretnym adresem ip i nie może go znaleźć a ansible-target nie może się połączyć z żadnym hostem.
Zajęłam się pierwszym problemem, porównanłam obecny adres ip maszyny z tym, który wyświetla się w komunikacie błędu. Nie zgadzał się. Musiałam dodać nowy adres ip maszyny dodać do znanych hostów:
```
ssh zuza@172.31.7.154
```
Połączyłam się przez ssh z nazwą użytkownika oraz nowym adresem ip.
 
Jak widać, pierwszy problem zniknął:
 
Zajęłam się drugim problemem. W komunikacie błędu zauważyłam, że nazwa użytkownika maszyny ansible-target nie zgadza się. Rozwiązanim okazało się wskaznie w pliku inwentaryzacyjnym nazwy użytkownika maszyny, z którym należy się połączyć – z reguły nie logujemy się do serwera a do konta konkretnego użytkownika.
 
Po wprowadzeniu powyższych zmian udało się wysłać ping do obu maszyn:
 

ZDALNE WYWOŁYWANIE PROCEDUR
W tej części sprawozdanie miałam za zadanie stworzyć playbook ansible. Jest to zbiór powtarzalnych skryptów, które są w stanie zautomatyzować pracę nad serwerami. Za pomocą jednego skryptu można uruchomić wiele operacji na nie tylko jednym serwerze.
Stworzyłam plik, w ktyrm umieszczę skrypt playbooka:
---
- hosts: all
  tasks:
    - name: Wyślij żądanie ping do wszystkich maszyn
      ping:

    - name: Skopiuj plik inwentaryzacji na maszyny/ę Endpoints
      copy:
        src: /home/zuza/lab8/inventory.yml
        dest: /home/ansible/nowy

    - name: Ponów operację, porównaj różnice w wyjściu
      command: diff /home/ansible/nowy /home/zuza/lab8/inventory.yml
      register: diff_output
      changed_when: diff_output.stdout != ""

    - name: Wyświetl różnice
      debug:
        var: diff_output.stdout_lines

    - name: Zaktualizuj pakiety w systemie
      apt:
        upgrade: yes
        update_cache: yes
      become: yes

    - name: Zrestartuj usługi sshd i rngd
      service:
        name: "{{ item }}"
        state: restarted
      with_items:
        - sshd
      become: yes
...

Za pomocą tak napisanego skryptu byłam wstanie na raz sprawdzić wszystkie aspekty podane w instrukcji.
By uruchomić skrypt użyłam polecenia:
```
ansible-playbook -i inventory.yml playbook.yml
```
 
Jak widać większość poleceń została spełnionych bez problemu.
Aktualizacja pakietów wymaga podania hasła. Można byłony je podać w skrypcie jednak jest to skrajnie nieodpowiedzialne szczególnie wtedy, gdy inni mają dostęp do naszego playbooka.
Drugą, znacznie bezpieczniejszą opcją jest dodanie flagi do komendy uruchamiającej playbooka:
```
ansible-playbook -i inventory.yml playbook.yml --ask-become-pass
```
Udało się zaktualizować usługi na nasible-target jednak nie na ubuntuserver. Z kodu błędu wynika, że w pewnym momencie wyniknął błąd połączenia z siecią:
 
Udało się również zrestartować usługi:
 
Ansible-targetnie ma zainstalowanej usługi rngd dlatego serwer nie był w stanie jej zrestartować.
Po usunięciu z zadania do restartu usługi rngd i ponownym uruchomieniu plabooka widać, że wszystko działa jak należy:
 
Mimo błędu, udało się skopiować plik na nową maszynę:
 
 

ZARZĄDZANIE KONTENEREM
Ze względu na problemy z deployem wybranego projektu musiałam przygotować jakiś inny kontener. Do tego celu wybrałam Nginx – popularny internetowy serwer oraz proxy HTTP. 
Miałam za zadanie stworzyć playbooka ansible który między innymi uruchamia kontener z deployem i wszystkie kroki ubrać w rolę za pomocą szkieletowania. 
By ułatwić sobie pracę mój playbook będzie zaiwierał wszystkie kroki takie jak zainstalowanie nginx, budowa, uruchamianie kontenera itp.
Zaczęła od stworzenia roli:
```
ansible-galaxy init nginx_rola
```
 
Powstała taka sekcja katalogów:
 
Stworzenie roli umożliwia nam na łatwe zarządzanie kodem oraz uporządkowanie go w przejrzysty sposób.
W katalogu tasks znajduje się plik main.yml w którym umieszczę polecenia dal swojeo playbooka.
Tak wygląda mój playbook składający się z 5 zadań:
 
Napotkałam na problem w momencie budowania obrazu:
 
Postanowiłam sprawdzić czy zbudowanie obrazu normalnie przebiegnie pomyślnie. Przeszłam do katalogu gdzie znjaduje się mój Dockerfile oraz zmieniony plik startowy index.html i zbudowałam obraz:
```
docker build -f Dockerfile -t my-nginx .
```
 
Wszystko przebiegło pomyślnie:
 
Jednak nadal playbook tego nie widzi. Postanowiłam więc zacząć od uruchomienia kontenera z deployem.
Nadal z poziomu playbooka wyskakują błędy:

 Jednak udało mi się go wykonać z terminala:
```
docker run -d -p 8081:80 --name my-nginx-container3 my-nginx
```
 
Myślałam, że chociaż uda się zatrzymać kontener i go usunąć jednak nadal wyskakuje błąd:
 
Zatrzymałam i usunęłam kontener z terminala:
```
docker rm -f CONTAINER_ID
```
 

FEDORA

Kolejnypunkt instrukcji wymagał stworzenie nowej maszyny wirtualnej i zainstalowanie na niej systemu Fedora za pomocą netinst.
Z oficjalnej strony projektu pobrałam najnowszy obraz serwera Fedora Server 40 (Network Install). Następnie przeszłam do Hyper-V i zaczęłam konfigurować podstawę nowej maszyny wirtualnej.
 
W oknie manualnej instalacji większość ustawień zostawiłam domyślnych. Ustawiłam hasło roota oraz stworzyłam użytkownika.
 
Kliknęłam instaluj a następnie uruchomiłam ponownie maszynę.
Instalacja przebiegła pomyślnie:
 
Kolejnym krokiem było sprawdzenie pliku konfiguracyjnego anaconda-ks.cfg. Wyświetliłam go:
```
sudo cp /root/anaconda-ks.cfg
```
A następnie zedytowałam by zawierał potrzebne repozytoria:
```
```
Ustawiłam inną nazwę dla localhost:
```

```
Usunęłam istniejące partycje na dysku twardym:
```

```
W sekcji package upewniłam się, by instalować dockera.
Gotowy plik wyglądał tak:
 
Skopiowałam plik do katalogu głównego:
 
I przeniosłam go na główną maszynę dzięki Rsync, które jest narzędziem do synchronizacji plików i działa przez SSH.
 
 
```
sudo rsync -av anaconda-ks.cfg zuza@172.24.5.43:/home/zuza/lab8
```
Plik został pomyślnie przesłany na główną maszynę:
  

INSTALACJA NIENADZOROWA
Jest to sposób instalacji systemu, który pozwala na automatyzację i dostosowanie instalacji pod preferencja użytkownika, nie wymagający interakcji z użytkownikiem na każdym etapie. W przypadku systemu jakim jest Fedora, do tego celu można użyć odpowiednio przygotowanego pliku Kickstart – anaconda-ks.cfg. Zawiera instrukcje dotyczące podstawowych konfiguracji systemu a także indywidualne instrukcje użytkownika. Dzięki temu instalacja systemu jest niezwykle szybka i prosta a co najważniejsze- wykonuje się automatycznie.
