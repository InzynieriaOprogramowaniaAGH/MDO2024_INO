# CEL LABORATORIUM
Celem laboratorium było przygotowanie nowej maszyny wirtualnej, na której testowane będzie oprogramowanie Ansible zainstalowane na głównej maszynie.

# PRZYGOTOWANIE
Laboratorium rozpoczęłam od stworzenie nowej maszyny wirtualnej analogicznie do poprzedniej. Użyłam tego samego systemu Ubuntu.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/4cdbff8c-68c7-42df-87c4-d99a778872ca)

 
Zadbałam o to by zainstalować usługę OpenSSH:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/341a8d2e-85cb-40aa-8286-f7daf893ccc6)

 
Zainstalowałam również tar:
```
Sudo apt-get install tar
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/f0ee70cf-63cc-47fc-ace9-d2521e47e0a8)

 
Kolejnym krokiem było utworzenie migawki nowej maszyny wirtualnej:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/69949ed0-2cb9-4642-aa4c-dcd0f331ec50)

 
Kolejnym krokiem było zaistalowanie zarządcy Ansible na starej maszynie wirtualnej.
```
Sudo apt-get install ansible
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d64debf4-a8d7-445c-a282-9de511771e50)

 
Następnie przystąpiłam do próby zalogowania ze starej maszyny wirtualnej do tej nowej.
Wymieniłam je kluczami
```
ssh-copy-id ansible@ansible-target
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/227e20fa-cf32-43e3-9f1e-89256024c54e)

 
Następnie podjęłam próbę połączenia się z nową maszyną:
```
Ssh ansible@ansible-target
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e2a9dc08-0fce-43aa-9472-491612411dd3)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/034608ad-536e-457a-9e5f-043d403d377f)

 
 
W tym momencie, jestem w stanie zalogować się do ze starej maszyny do nowej bez użycia hasła.

# INWENTARYZACJA
W części inwentaryzacji zaczęłam wykonywać po kolej instrukcję:
•	Ustaliłam przeiwydalne nazwy maszyn dzięki
```
Hostnamectl
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e30ce945-7794-44cd-be27-140d293e8f33)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/73df5d43-e6e7-4c9f-8ced-3426228a6a49)

 
 
Obie maszyny widzą się nawzajem tylko za pomocą ich nazw hostname – sprawdziłam to poleceniami:
```
Ping ubuntuserver
Ping ansible-target
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cc0401e7-8361-420a-a857-572a9e11e722)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cefeb7e9-3874-4964-8013-72407c901e05)

 
 
Następnie stworzyłam plik inwentaryzacyjny i dodałam do niego obie maszyny wirtualne:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/0df4c8d9-e410-4c6f-8c99-076183bd7b52)

 
Za pomocą pliku i modułu ansible wysłałam żądanie ping do obu maszyn 
```
ansible -i inventory.ini -m ping all
```
Niestety nie udało się:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/db2bf498-7a66-4361-a326-9fd918882375)

 
Powstały dwa problemy – ubuntuserver połączył się z hostem z konkretnym adresem ip i nie może go znaleźć a ansible-target nie może się połączyć z żadnym hostem.
Zajęłam się pierwszym problemem, porównanłam obecny adres ip maszyny z tym, który wyświetla się w komunikacie błędu. Nie zgadzał się. Musiałam dodać nowy adres ip maszyny dodać do znanych hostów:
```
ssh zuza@172.31.7.154
```
Połączyłam się przez ssh z nazwą użytkownika oraz nowym adresem ip.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e6b14389-5a35-4e47-8f05-599e48585441)

 
Jak widać, pierwszy problem zniknął:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/6e8fd1ef-9f95-4747-ae5c-e9c26ef7d5f3)

 
Zajęłam się drugim problemem. W komunikacie błędu zauważyłam, że nazwa użytkownika maszyny ansible-target nie zgadza się. Rozwiązaniem okazało się wskaznie w pliku inwentaryzacyjnym nazwy użytkownika maszyny, z którym należy się połączyć – z reguły nie logujemy się do serwera a do konta konkretnego użytkownika.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/29b0e7f4-274b-4893-9c57-db2b0651044c)

 
Po wprowadzeniu powyższych zmian udało się wysłać ping do obu maszyn:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/4e71eb3a-85a4-4294-89aa-53f12e239c82)

 

# ZDALNE WYWOŁYWANIE PROCEDUR
W tej części sprawozdanie miałam za zadanie stworzyć playbook ansible. Jest to zbiór powtarzalnych skryptów, które są w stanie zautomatyzować pracę nad serwerami. Za pomocą jednego skryptu można uruchomić wiele operacji na nie tylko jednym serwerze.
Stworzyłam plik, w którym umieszczę skrypt playbooka:
```
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
```
Za pomocą tak napisanego skryptu byłam wstanie na raz sprawdzić wszystkie aspekty podane w instrukcji.
By uruchomić skrypt użyłam polecenia:
```
ansible-playbook -i inventory.yml playbook.yml
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/876f976e-be3f-47a9-b1c4-c56778e08c5a)

 
Jak widać większość poleceń została wykonana bez problemu.
Aktualizacja pakietów wymaga podania hasła. Można byłoby je podać w skrypcie jednak jest to skrajnie nieodpowiedzialne szczególnie wtedy, gdy inni mają dostęp do naszego playbooka.
Drugą, znacznie bezpieczniejszą opcją jest dodanie flagi do komendy uruchamiającej playbooka:
```
ansible-playbook -i inventory.yml playbook.yml --ask-become-pass
```
Udało się zaktualizować usługi na asible-target jednak nie na ubuntuserver. Z kodu błędu wynika, że w pewnym momencie wyniknął błąd połączenia z siecią:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/f6b1f57d-ac20-4e9f-9d63-00bc3c28d80d)

 
Udało się również zrestartować usługi:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/951178df-5ccf-4338-87f3-c7472b624ac5)

 
Ansible-target nie ma zainstalowanej usługi rngd dlatego serwer nie był w stanie jej zrestartować.
Po usunięciu z zadania do restartu usługi rngd i ponownym uruchomieniu plabooka widać, że wszystko działa jak należy:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/8dd35427-d954-44c2-9386-0069916aaf5e)

 
Mimo błędu, udało się skopiować plik na nową maszynę:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/0ea4a4f5-4fdb-433a-b764-654c5359c547)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/049768c0-daca-4c55-b15d-792e2620473b)

 
 

# ZARZĄDZANIE KONTENEREM
Ze względu na problemy z deployem wybranego projektu musiałam przygotować jakiś inny kontener. Do tego celu wybrałam Nginx – popularny internetowy serwer oraz proxy HTTP. 
Miałam za zadanie stworzyć playbooka ansible który między innymi uruchamia kontener z deployem i wszystkie kroki ubrać w rolę za pomocą szkieletowania. 
By ułatwić sobie pracę mój playbook będzie zawierał wszystkie kroki takie jak zainstalowanie nginx, budowa, uruchamianie kontenera itp.
Zaczęła od stworzenia roli:
```
ansible-galaxy init nginx_rola
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/7c16423c-6882-49f6-bfc4-50d02035c5ad)

 
Powstała taka sekcja katalogów:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/9f5369f7-eaba-4f12-951f-86ca14129338)

 
Stworzenie roli umożliwia nam łatwe zarządzanie kodem oraz uporządkowanie go w przejrzysty sposób.
W katalogu tasks znajduje się plik main.yml w którym umieszczę polecenia dla swojeo playbooka.
Tak wygląda mój playbook składający się z 5 zadań:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/be0ee313-cf30-41fe-93fd-18b143c6f573)

 
Napotkałam na problem w momencie budowania obrazu:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/a0f185e3-85bd-4904-aac1-47397792d558)

 
Postanowiłam sprawdzić czy zbudowanie obrazu normalnie przebiegnie pomyślnie. Przeszłam do katalogu gdzie znajduje się mój Dockerfile oraz zmieniony plik startowy index.html i zbudowałam obraz:
```
docker build -f Dockerfile -t my-nginx .
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/cd0bea38-af90-4113-acb1-058f7759ea5b)

 
Wszystko przebiegło pomyślnie:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/851ab411-526b-418f-a959-78533c109bd0)

 
Jednak nadal playbook tego nie widzi. Postanowiłam więc zacząć od uruchomienia kontenera z deployem.
Nadal z poziomu playbooka wyskakują błędy.

 Jednak udało mi się go wykonać z terminala:
```
docker run -d -p 8081:80 --name my-nginx-container3 my-nginx
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/3b5b60a6-9817-403b-885d-80905289f52f)

 
Myślałam, że chociaż uda się zatrzymać kontener i go usunąć jednak nadal wyskakuje błąd:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/6ac6c762-af60-4aea-b1e9-788176632b4c)

 
Zatrzymałam i usunęłam kontener z terminala:
```
docker rm -f CONTAINER_ID
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/da44641d-790d-4812-8bec-8c14990d36c4)

 

# FEDORA

Kolejny punkt instrukcji wymagał stworzenie nowej maszyny wirtualnej i zainstalowanie na niej systemu Fedora za pomocą netinst.
Z oficjalnej strony projektu pobrałam najnowszy obraz serwera Fedora Server 40 (Network Install). Następnie przeszłam do Hyper-V i zaczęłam konfigurować podstawę nowej maszyny wirtualnej.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/2e9ec4dd-9074-41b8-92ba-916588f637a3)

 
W oknie manualnej instalacji większość ustawień zostawiłam domyślnych. Ustawiłam hasło roota oraz stworzyłam użytkownika.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e430ee4c-2a66-49c2-af0e-d0d1ae89a47a)

 
Kliknęłam instaluj a następnie uruchomiłam ponownie maszynę.
Instalacja przebiegła pomyślnie:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/f5359a1b-f337-4ef7-bc67-38f4b2d33598)

 
Kolejnym krokiem było sprawdzenie pliku konfiguracyjnego anaconda-ks.cfg. Wyświetliłam go:
```
sudo cp /root/anaconda-ks.cfg
```
A następnie zedytowałam by zawierał potrzebne repozytoria:
```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64
```
Ustawiłam inną nazwę dla localhost:
```
network --bootproto=dhcp --hostname=zuzru
```
Usunęłam istniejące partycje na dysku twardym:
```
clearpart --all
```
W sekcji package upewniłam się, by instalować dockera.
Gotowy plik wyglądał tak:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/e2f1f66e-6b37-44dd-946d-2259a76058a8)

 
Skopiowałam plik do katalogu głównego:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/c332de2a-b501-40bb-ad12-16b3c2375300)

 
I przeniosłam go na główną maszynę dzięki Rsync, które jest narzędziem do synchronizacji plików i działa przez SSH.
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/d1fa9364-4a9d-4ca1-97bb-c0bd2bc70619)
 ![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/29ca83e0-e027-469f-b8a9-b24b68d03d39)

 
```
sudo rsync -av anaconda-ks.cfg zuza@172.24.5.43:/home/zuza/lab8
```
Plik został pomyślnie przesłany na główną maszynę:
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/95193381/7ba61aa3-c01e-431c-ae00-1eea8237676c)

  

# INSTALACJA NIENADZOROWA
Jest to sposób instalacji systemu, który pozwala na automatyzację i dostosowanie instalacji pod preferencja użytkownika, nie wymagając interakcji z użytkownikiem na każdym etapie. W przypadku systemu jakim jest Fedora, do tego celu można użyć odpowiednio przygotowanego pliku Kickstart – anaconda-ks.cfg. Zawiera instrukcje dotyczące podstawowych konfiguracji systemu a także indywidualne instrukcje użytkownika. Dzięki temu instalacja systemu jest niezwykle szybka i prosta a co najważniejsze- wykonuje się automatycznie.
