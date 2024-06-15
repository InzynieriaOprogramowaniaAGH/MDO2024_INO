## Sprawozdanie 4
# Cel sprawozdania: Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

# Instalacja zarządcy Ansible
Ansible jest narzędziem wykorzystywanym do automatyzacji procesów administracyjnych, orkiestracji oraz zarządzania konfiguracją. 
1. Utowrzenie nowej maszyny wirtualnej o takim samym systemie operacyjnym jak maszyna, na której do tej pory pracowano - Ubuntu 22.04
   - zgodnie z instrukcją nadanie nazwy użytkownika ```bash ansible``` oraz hostname na ``` bash ansible-target```
     1.png
   - stworzona maszyna oraz jej właściwości
     3.png
     4.png
   - zrobienie migawki maszyny
     2.png
2. Zainstalowanie oprogramowania Ansible ze strony ```bash https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu ``` 
   na głównej maszynie (nie nowo utworzonej)
   ```bash
   $ sudo apt update
   $ sudo apt install software-properties-common
   $ sudo add-apt-repository --yes --update ppa:ansible/ansible
   $ sudo apt install ansible
   ```
  - sprawdzenie czy dobrze zainstalowało się oprogramowanie
    5.png
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
    6.png
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
    7.png
    - Sprawdzenie, czy można połączyć się z maszyną bez konieczności podawania hasła
      `` bash shh ansible@10.0.2.2 ``
    8.png
  - Ponowienie dwóch poprzednich kroków, jednak z inną nazwą użytkownika oraz IP
    9.png

    # Inwentaryzacja
    1. Zmiana haseł na przewidywane nazwy, jeżeli są one inne niż powinny
      ``` bash hostnamectl set-hostname nazwa-hosta ```
      10.png
    2. Wprowadzenie nazwy DNS tak aby było możliwe wywoływaniie maszyn za pomocą nazw, a nie tylko adresów IP
        - Wejście do folderu /etc/hosts
        - ustawienie nazwy maszyny dla danego adresu IP
      11.png
    3. Sprawdzenie czy maszyny łączą się po nazwie
      12.png
       - można również użyć polecenie ```bash ping ``` co również pokazuje prawidłowe połączenie
       13.png
    4. Stworzenie pliku inwentaryzacji
       - Stworzenie pliku inwentaryzacji na podstawie dokumentacji https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html
         - stworzenie folderu ansible_quickstart ```bash mkdir ansible_quickstart```
         - w stworzonym folderze stworzenie pliku inventory.ini
           ```bash
           cd ansible_quickstart
           touch inventory.ini
           nano inventory.ini
            ```
          - dodanie nowej grupy hostów [myhosts]
         14.png
         - wyświetlenie maszyn zdefioniowanych w pliku (sprawdzenie)
           ```bash
           ansible-inventory -i inventory.ini --list
           ```
         15.png
         - weryfikacja
           ```bash
           ansible MaszynyDocelowe -m ping inventory.ini
           ```
        16.png
      5. Umieszczenie w pliku inwentaryzacji sekcji Orchestrators oraz Endpoints
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
      6. Wysłanie żądania ```bash ping``` do wszytskich maszyn
    17.png

# Zdalne wywołanie procedur
           
