# Sprawozdanie 4
# Cel sprawozdania: Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

## Instalacja zarządcy Ansible
Ansible jest narzędziem wykorzystywanym do automatyzacji procesów administracyjnych, orkiestracji oraz zarządzania konfiguracją. 
1. Utowrzenie nowej maszyny wirtualnej o takim samym systemie operacyjnym jak maszyna, na której do tej pory pracowano - Ubuntu 22.04
   - zgodnie z instrukcją nadanie nazwy użytkownika ```bash ansible``` oraz hostname na ``` bash ansible-target```
     ![img](images/1.png)
   - stworzona maszyna oraz jej właściwości
     ![img](images/3.png)
     ![img](images/4.png)
   - zrobienie migawki maszyny
      ![img](images/2.png)
2. Zainstalowanie oprogramowania Ansible ze strony ```bash https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu ``` 
   na głównej maszynie (nie nowo utworzonej)
   ```bash
   $ sudo apt update
   $ sudo apt install software-properties-common
   $ sudo add-apt-repository --yes --update ppa:ansible/ansible
   $ sudo apt install ansible
   ```
  - sprawdzenie czy dobrze zainstalowało się oprogramowanie
    ![img](images/5.png)
3. Zainstalowanie programu tar oraz serwera OpenSSH (sshd)
  - Użycie poniższych komend:
    ``` bash
    sudo apt install openssh-server
    sudo apt install tar
    ```
  - Sprawdzenie poprawności instalacji:
    ``` bash
    which tar
    dpkg -l | grep openssh-server
    ```
  - Sprawdzenie czy SSH jest włączone
    ``` bash
    sudo systemctl status ssh
    ```
    ![img](images/6.png)
4. Wymiana kluczy SSH między dwoma maszynami, tak aby logowanie ssh ansible@ansible-target nie wymagało podania hasła.
  - Wygenerowanie nowych kluczy
    ```bash
    ssh-keygen
    ```
  - sprawdzenie IP nowej maszyny za pomocą polecenia ```bash ifconfig ``` 
  - Wymiana kluczy
      
    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub ansible@10.0.2.15
    ```
    ```bash -i ``` ścieżka do klucza publicznego + docelowy adres użytkownika i ip docelowe
    ![img](images/7.png)
    - Sprawdzenie, czy można połączyć się z maszyną bez konieczności podawania hasła
      `` bash shh ansible@10.0.2.2 ``
    ![img](images/8.png)
  - Ponowienie dwóch poprzednich kroków, jednak z inną nazwą użytkownika oraz IP
    ![img](images/9.png)

## Inwentaryzacja
1. Zmiana haseł na przewidywane nazwy, jeżeli są one inne niż powinny
      ``` bash hostnamectl set-hostname nazwa-hosta ```
      ![img](images/10.png)
   
3. Wprowadzenie nazwy DNS tak aby było możliwe wywoływaniie maszyn za pomocą nazw, a nie tylko adresów IP
        - Wejście do folderu /etc/hosts
        - ustawienie nazwy maszyny dla danego adresu IP
   
      ![img](images/11.png)
4. Sprawdzenie czy maszyny łączą się po nazwie
      ![img](images/12.png)
   
       - można również użyć polecenie ```bash ping ``` co również pokazuje prawidłowe połączenie
   
      ![img](images/13.png)
6. Stworzenie pliku inwentaryzacji
   - Stworzenie pliku inwentaryzacji na podstawie dokumentacji https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html
     - stworzenie folderu ansible_quickstart ```bash mkdir ansible_quickstart```
      - w stworzonym folderze stworzenie pliku inventory.ini
        ```bash
        cd ansible_quickstart
        touch inventory.ini
        nano inventory.ini
        ```
      - dodanie nowej grupy hostów [myhosts]
        
        ![img](images/14.png)
        
      - wyświetlenie maszyn zdefioniowanych w pliku (sprawdzenie)
        ```bash
        ansible-inventory -i inventory.ini --list
        ```
        ![img](images/15.png)
      - weryfikacja
        ```bash
        ansible MaszynyDocelowe -m ping inventory.ini
        ```
        ![img](images/16.png)
7. Umieszczenie w pliku inwentaryzacji sekcji Orchestrators oraz Endpoints
   - treść pliku
     ```bash
     [Orchestrators]
     orchestrator ansible_host=127.0.0.1 ansible_user=aleksandra_o ansible_ssh_private_key_file=/home/aleksandra_o/.ssh/id_rsa

     [Endpoints]
     01 ansible_host=10.0.2.2 ansible_user=ansible ansible_ssh_private_key_file=/home/aleksandra_o/.ssh/id_rsa

     [all:children]
     Orchestrators
     Endpoints
     ```
8. Wysłanie żądania ```bash ping``` do wszytskich maszyn
    ![img](images/17.png)

# Zdalne wywołanie procedur

Stworzenie playbooka Ansible na podstawie dokumentacji https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html
1. Wysłanie żądania ```bash ping ``` do wszystkich maszyn
   ```bash
   - name: Ping all hosts
     hosts: all
     become: false
     tasks:
    - name: Ping all hosts
      ping:
      ```
2. Skopiowanie pliku inwentaryzacji na maszynę ```bash Endpoints ``` + ponowienie operacji
   ``` bash
   - name: Copy inventory file to endpoints and compare
     hosts: Endpoints
     become: false
     tasks:
    - name: Copy inventory file to endpoints - first run
      copy:
        src: inventory.ini
        dest: /home/ansible/inventory_first.ini

    - name: Copy inventory file to endpoints - second run
      copy:
        src: inventory.ini
        dest: /home/ansible/inventory_second.ini

    - name: Check differences after second copy
      shell: diff /home/ansible/inventory_first.ini /home/ansible/inventory_second.ini || true
      register: diff_output

    - name: Display diff output
      debug:
        var: diff_output.stdout_lines
   ```
      - skopiowanie pliku 'inventory.ini' do ścieżki '/home/ansible/inventory_first.ini' z maszyny Orchestratora na maszynę Endpoint
      - skopiowanie pliku inwentaryzacji, nadanie nazwy inventory_second.ini i porównanie poleceniem ```bash diff ``` , ```bash || true``` zapewnia, że playbook nie zakończy się niepowodzeniem, jeśli zostaną znalezione różnice, wynik z diff przechowywany         w zmiennej 'diff_output'
3. Aktualizacja pakietów w systemie
      ```bash
      - name: Update packages and restart services
        hosts: Endpoints
        become: true
        tasks:
       - name: Update package repositories
         apt:
           update_cache: yes
         register: update_output
   
       - name: Display update output
         debug:
           msg: "{{ update_output }}"
      ```
      - aktualizacja lokalnej bazy pakietów: 'bash update_cache:yes'
        
4. Zrestartowanie usług sshd i rngd
      ```bash
      - name: Restart sshd service using systemd
         systemd:
           name: sshd
           state: restarted
   
       - name: Restart rngd service
         service:
           name: rng-tools
           state: restarted
      ```
   Wykonanie playbook'a poleceniem:
      ```bash
      ansible-playbook -i inventory.ini --ask-become-pass playbook.yml
      ```
      
   BŁĘDY
      Podczas wykonania polecenia wyskoczył błąd ```bash Could not find the requested servce rng-tools: host ```
      ![img](images/18.png)
      Rozwiązaniem było zainstalowanie rngd. Należy użyć poleceń:
      ```bash
      instalacja rngd
      sudo apt update
      sudo apt install rng-tools
      ```
      ![img](images/19.png)

      - ok=10: 10 zadań zakończonych sukcesem.
      - changed=2: 2 zadania zakończyły się zmianami.
      - unreachable=0: Żaden host nie jest nieosiągalny.
      - failed=0: Żadne zadanie nie zakończyło się niepowodzeniem.
      - skipped=0: Żadne zadanie nie zostało pominięte.
      - rescued=0: Żadne zadanie nie wymagało ratowania.
      - ignored=0: Żadne zadanie nie zostało zignorowane.
     
   5. Wyłączenie sshd
      - wyłączenie sshd za pomocą polecenia: ```bash sudo systemctl stop shd```
        
      Otrzymanie błędu:
      
      ![img](images/20.png)
      
      - włączenie sshd i wyłączenie kabla sieciowego
      ![img](images/21.png)

      Otrzymane błędy
      ![img](images/22.png)

# Zarządzanie kontenerem
- Stworzenie drugiego playbooka, który pobiera z DockerHuba stworzony na poprzednich zajęciach obraz, a następnie uruchamia go i eksponuje na port 3000 na Endpoincie
   ```bash
   - name: Run 'Hot and Cold' game
     hosts: Endpoints
     become: no
     tasks:
    - name: Download game image from DockerHub
      docker_image:
        name: alexssandrr/react-hot-cold:latest
        source: pull
    - name: Run the game
      docker_container:
        name: react-hot-cold
        image: alexssandrr/react-hot-cold:latest
        ports:
          - "3000:3000"
        state: started
   ```
  - Pobranie Dockera na Endpoincie
     ```bash
     sudo snap install docker
     ```
     ![img](images/23.png)
  - Sprawdzenie czy gra znajduje się na porcie 3000 Endpointa
    ![img](images/24.png)
  - Zatrzymanie i usunięcie kontenera
    ![img](images/25.png)
  
## Pliki odpowiedzi dla wdrożeń nienadzorowanych
CEL: Celem labolatoriów jest utworzenie źródła instalacji nienadzorowanej dla systemu operacyjnego hostującego nasze oprogramowanie oraz przeprowadzenie instalacji systemu, który po uruchomieniu rozpocznie hostowanie naszego programu.

1. Zainstalowanie programu Fedora stosując instalator sieciowy netinst ze strony: https://mirroronet.pl/pub/mirrors/fedora/linux/releases/  Wybrałam Fedora 39.
![img](images/26.png)
- instalacja maszyny (krok po kroku pokazane w Sprawozdaniu1) oraz podstawowe informacje
  ![img](images/27.png)
2. Znalezienie pliku anaconda-ks.cfg
  ```bash
  sudo cat /root/anaconda-ks.cfg
  ```
3. Edycja pliku
   ```bash nano /root/anaconda-ks.cfg ```
   - Dodanie wzmianek na temat potrzebnych repozytoriów
     ```bash
     url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-39&arch=x86_64
     repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f39&arch=x86_64
     ```
     - Ustawienie hostname na alekandra_o
      ```bash
      network --hostname=aleksandra_o
      ```
      - zapewnienie formatowania całości dysku
        ```bash
        #Format
        clearpart --all
        ```
      - W sekcji '%packages' dodanie 'docker-ce' co zapewni, że od razu po instalacji system Fedora był gotowy do użycia z Docker CE bez konieczności ręcznej instalacji po pierwszym uruchomieniu systemu
        ```bash
        %packages
        @^server-product-environment
        docker-ce
        %end
        ```
      - Stworzenie w sekcji '%post' mechanizmu umożliwiającego pobranie i uruchomienie kontenera. Dodanie użytkowników 'root' oraz 'aleksandra_o' do grupy 'docker'
     ```bash
     %post
     usermod -aG docker root
     usermod -aG docker aleksandra_o
     sudo -u aleksandra_o systemctl enable docker
     sudo -u aleksandra_o systemctl start docker
     sudo -u aleksandra_o docker pull alexsssandrr/react-hot-cold:latest
     sudo -u aleksandra_o docker run -p 3000:3000 alexssandrr/react-hot-cold:latest
     %end
     ```
     - Dodanie reboot (ponowne uruchomienie)
       ```bash
       reboot
       ```
      ![img](images/28.png)
   - Wyeksportowanie folderu z plikiem kickstart na lokalnego hosta
     ``` bash
     python -m http.server
     ```
      ![img](images/29.png)

