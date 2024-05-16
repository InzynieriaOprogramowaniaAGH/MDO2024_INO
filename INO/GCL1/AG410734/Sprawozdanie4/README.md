# Sprawozdanie 4
**Cel sprawozdania** : 
## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible

W pierwszej kolejności utworzyłam nową maszynę wirtualną z takim samym systemem operacyjnym, jak maszyna na której pracuję. System operacyjny to Ubuntu 20.04 LTS.

Nadałam nazwę użytkownika `ansible` i hostname `ansible-target`:

  ![](screeny/1.png)

Utworzona maszyna: 

  ![](screeny/2.png)

Podstawowe informacje o maszynie:

  ![](screeny/3.png)

Z repozytorium dystrybucji https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu zainstalowałam oprogramowanie Ansible przy użyciu komend:

```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```

  ![](screeny/4.png)

W Ubuntu zazwyczaj domyślnie jest już zainstalowany tar i OpenSSH, ale żeby się upewnić możemy wpisać polecenia:

```
which tar
dpkg -l | grep openssh-server
```
Żeby sprawdzić czy serwer SSH jest uruchomiony należey wpisać:

```
sudo systemctl status ssh
```

Żeby włączyć:

```
sudo systemctl start ssh
```
**Wymiana kluczy ssh**
Aby wygenerować klucz ssh należy użyć polecenia (szczegółowo generowanie klucza opisałam w Sprawozdaniu 1):

```
ssh-keygen 
```

W celu wymiany kluczy używam polecenia:

```
ssh-copy-id -i ~/.ssh/id_rsa.pub ansible@192.168.1.104
```
Gdzie po parametrze `-i` podaję ścieżkę do klucza publicznego, a nastęnie adres docelowy użytkownika i ip docelowe.

Aby sprawdzić, czy klucz prawidłowo się przekopiował, można użyć polecenia na maszynie docelowej:

```
cat ~/.ssh/authorized_keys
```
Klucz prawidłowo się przekopiował:

  ![](screeny/5.png)

Sprawdzam czy mogę się połączyć z maszyną bez konieczności podawania hasła poleceniem: 

```
ssh ansible@192.168.1.104
```

Połączenie z maszyną przebiega bez konieczności podawania hasła:

  ![](screeny/6.png)

To samo robię w drugą stronę, żeby maszyny widziały się nawzajem bez konieczności podawania hasła w jakąkolwiek stronę.

Kopiowanie klucza:

![](screeny/7.png)

Połączenie bez konieczności podawania hasła:

![](screeny/8.png)

### Inwentaryzacja

Moje dwie maszyny mają już nadane przewidywalne nazwy:

![](screeny/9.png)

![](screeny/10.png)

Jednak gdyby tak nie było można to zrobić poleceniem:

```
hostnamectl set-hostname nowa-nazwa-hosta
```
Aby ustawić nazwy DNS dla maszyn wirtualnych, bez konieczności łączenia sie po IP, wchodzę do folderu `/etc/hosts` i ustawiam nazwę maszyny dla danego adresu IP:

W agnieszka@agnieszka wpisuję:

![](screeny/11.png)

W ansible@ansible-target wpisuję:

![](screeny/12.png)

Sprawdzam czy maszyny widzą się nawzajem po nazwie DNS:

![](screeny/13.png)

![](screeny/14.png)

W celu sprawdzenia poprawności połączenia można użyć jeszcze polecenia `ping`:

![](screeny/15.png)

W kolejnym kroku za pomocą dokumentacji: https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html buduję plik inwentaryzacji.

Tak jak na ćwiczeniach tworzę nowy katalog, w którym umieszczam plik `inventory.ini`.

Treść pliku `inventory.ini`:

```
[MaszynyDocelowe]
ansible-target ansible_user=ansible
```

Następnie wyświetlam maszyny zdefiniowane w pliku inventory (w tym przypadku inventory.ini) w formacie JSON za pomocą polecenia:

```
ansible-inventory -i inventory.ini --list
```

![](screeny/16.png)

Następnie weryfikuję, czy ansible może połączyć się ze zdefiniowaną w pliku maszyną poleceniem:

```
ansible-inventory -i inventory.ini --list
```

![](screeny/17.png)

W moim przypadku ważne było, żeby dodać do pliku `inventory.ini` nazwę użytkownika, ponieważ domyślnie nadawało mi nazwę użytkownika z maszyny z ansiblem, co powowdowało błąd połączenia. 

Zmodyfikowałam plik tak, aby zawierał sekcję [Orchestrators] - zawiera nazwę, pod którą będziemy odwoływać się do tej konkretnej maszyny w innych plikach konfiguracyjnych lub w playbookach Ansible, a także sekcję [Endpoints], zawierającą maszyny docelowe :

```
[Orchestrators]
orchestrator ansible_host=agnieszka ansible_user=agnieszka

[Endpoints]
01 ansible_host=ansible-target ansible_user=ansible

[all:children]
Orchestrators
Endpoints
```
Po wywołaniu `ansible ping` pojawił się błąd połaczenia z orchestratorem, żeby to naprawić dodałam do `known-hosts` klucz publiczny maszyny z ansiblem. Po dodaniu klucza wszystkie połączenia zakończyły się sukcesem:

![](screeny/18.png)

### Zdalne wywyoływanie procedur 

Na podstawie podanej dokumnetacji https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html tworzę playbooka Ansible.

Na początku wsyłam żądanie `ping` do wszystkich maszyn:
```
- name: Ping all hosts
  hosts: all
  become: false
  tasks:
    - name: Ping all hosts
      ping:
```
Następnie kopiuję plik inwentryzacji z maszyny `Orchestratora` na maszynę `Endopoint` pod ścieżkę `/home/ansible/inventory_first.ini`. W kolejnym tasku w celu ponowienia operacji i sprawdzenia różnic w wyjściu, kopiuję plik inwentaryzacji jeszcze raz, nadaję nazwę `inventory_second.ini` i porównuję poleceniem `diff` z pierwszym skopiowanym. Operator || true sprawia, że nawet jeśli diff wykryje różnice i zakończy się błędem (z kodem wyjścia różnym od zera), zadanie nie zostanie oznaczone jako niepowodzenie. Wynik polecenia diff jest rejestrowany w zmiennej diff_output, a następnie wyświetlany.

```
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
Kolejna część playbooka, to aktualizacja pakietów na `Endpoints`, za pomocą `apt update cache`. Wynik jest zapisywany w `update_output` i w kolejnym tasku wyświetlany. Kolejne taski to restartowanie usługi `sshd` i `rngd`, która w moim przypadku jest częścią pakietu `rng-tools` (system oparty na Ubuntu).

```

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

    - name: Restart sshd service using systemd
      systemd:
        name: sshd
        state: restarted

    - name: Restart rngd service
      service:
        name: rng-tools
        state: restarted
```
Playbooka wykonuję poleceniem:

```
ansible-playbook -i inventory.ini --ask-become-pass playbook.yml
```
gdzie:

Flaga `-i` określa plik inwentaryzacji, który zawiera listę wszystkich maszyn, na których zostaną wykonane operacje zdefiniowane w playbooku. W tym przypadku plik inwentaryzacji to inventory.ini.

Flagi `--ask-become-pass` wymagają od użytkownika podania hasła uprawnień (sudo) przed uruchomieniem playbooka. Jest to potrzebne, ponieważ w playbooku jest ustawiona opcja become: true.

`playbook.yml` określa nazwę pliku playbooka, który chcę uruchomić.

Wynik wykonania playbooka:

![](screeny/19.png)

![](screeny/20.png)