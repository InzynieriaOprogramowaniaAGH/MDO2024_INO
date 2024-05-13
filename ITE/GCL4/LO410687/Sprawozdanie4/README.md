# Sprawozdanie 4
## Łukasz Oprych 410687 Informatyka Techniczna

## Lab 8-9

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Pierwszym krokiem w tym ćwiczeniu będzie utworzenie maszyny wirtualnej z systemem operacyjnym takim jak na maszynie z poprzednich zajęć. Będzie ona nam potrzebna do wykonania instrukcji podanych przez maszynę zarządczą z wykorszystaniem Ansible.

W tym celu przechodzimy do Menadżera Funkcji Hyper-V i wybrania opcji 

Nowa -> maszyna wirtualna 

![](0.png)

Idziemy zgodnie z instalatorem krok po kroku, wybieramy UEFI Generacja 2, ilość pamięci RAM 2048MB i dysk VHD wedle uznania. Należy pamiętać aby w ustawieniach maszyny wyłączyć Secure Boot.

![](1.png)

Następnie po uruchomieniu maszyny wirtualnej przechodzimy do instalatora i wykonujemy kolejne kroki instalacji systemu operacyjnego.

![](2.png)

Podsumowanie instalacji:

![](3.png)

Na maszynie zarządcy (będzie to maszyna z poprzednich zajęć) instalujemy `ansible` poleceniem:

```bash
sudo dnf install -y ansible
```
Na maszynie zarządzanej zapewniamy `tar` oraz serwer `ssh`, dokonujemy to poleceniami:

```bash
sudo dnf install tar
sudo dnf install openssh
```
Dodajemy użytkownika ansible, ustawiamy hasło i nadajemy mu odpowiednie uprawnienia:
```bash
sudo useradd ansible
sudo passwd ansible
sudo usermod -aG wheel ansible #przyda się między innymi do aktualizacji pakietów
```

![](6.png)

Następnie w celu łatwej identyfikacji maszyny w sieci korzystamy z polecenia:

```bash
sudo hostnamectl set-hostname ansible-target'
```
Wynik możemy sprawdzić poleceniem 
```
hostname
```
![](5.png)

Następnie wykonujemy migawkę z poziomu menadżera hyper-v opcją `Punkt kontrolny`

![](7.png)

Kolejnym krokiem w celu komunikacji między maszynami przy użyciu protokołu **ssh**
utworzenie oraz wymienienie między maszynami kluczy SSH tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła.

Klucze ssh generujemy poleceniem 
```bash
ssh-keygen -t <typ-szyfrowania>
```
Wynik z maszyny zarządczej:

![](8.png)

W celu prostej komunikacji między maszynami wprowadzamy nazwy DNS maszyn wirtualnych.

Przechodzimy do definicji DNS w katalogu `etc/hosts` w przypadku **Fedory**.
Dodajemy adres loopback, adres w sieci i hostname'y maszyn.

![](9.png)

![](10.png)

Weryfikacji poprawności wykonania możemy sprawdzić poleceniem `ping <hostname>`

![](11.png) ![](12.png)

Następnie poniższym poleceniem kopiujemy klucz między maszynami

```bash
ssh-copy-id -i ~/.ssh/id_<typ-szyfrowania>.pub/<username>@<hostname>
```

![13](13.png)

![14](14.png)

Jak widać logowanie działa:

![](16.png)

![](15.png)


## Inwentaryzacja

W celu dokonania definicji hostów zarządzanych przez ansible tworzymy w folderze ze sprawozdaniem plik inwentaryzacji w formacie `.yaml`

***inventory.yaml***
```yaml
all:
  children:
    Orchestrators:
      hosts:
        fedora:
          ansible_host: fedora
          ansible_user: loprych

    Endpoints:
      hosts:
        ansible-target:
          ansible_host: ansible-target
          ansible_user: ansible
```

Kolejnym krokiem było wykonanie ządania `ping` do wszystkich maszyn, w celu sprawdzenia łączności między maszynami oraz definicji pliku.

Dokonujemy tego za pomocą polecenia:

```bash 
ansible -i inventory.yaml all -m ping
```

![](17.png)

Kolejnym poleceniem było skopiowane pliku inwentaryzacji na maszynę Endpointową oraz wykonanie ping na wszystkie hosty.

***pingall.yaml***
```yaml
- name: Copy inventory and ping all
  hosts: Endpoints
  remote_user: ansible

  tasks:
    - name: Copy inventory.yaml to ansible-target
      copy:
        src: /home/loprych/MDO2024_INO/ITE/GCL4/LO410687/Sprawozdanie4/inventory.yaml
        dest: /home/ansible/

    - name: Ping all hosts using the copied inventory file
      ansible.builtin.ping:
```

Takowy playbook uruchamiamy poleceniem:

```bash
ansible-playbook -i <inventory> <playbook>
```

Pierwsze wykonanie:

![](18.png)

Drugie wykonanie:

![](19.png)

Różnica w postaci changed=1 przy pierwszym wykonaniu mówi nam, że podczas zadania kopiowania pliku inventory.yaml na maszynę o nazwie ansible-target, faktycznie doszło do zmiany na tej maszynie w postaci pojawienia się pliku inventory.yaml na maszynie ansible-target.

Następnym poleceniem było dokonanie aktualizacji pakietów przy użyciu Ansible
Tworzymy poniższy playbook:
***update.yaml***
```yaml
- name: Update packages on target system
  hosts: Endpoints
  tasks:
    - name: Upgrade all packages
      ansible.builtin.dnf:
        name: "*"
        state: latest
      become: true
```

Następnie poleceniem z parametrem `--ask-become-pass`, który pozwala na wykonanie aktualizacji jako root po podaniu hasła, dzięki dodaniu w yamlu parametru `become: true`.

```bash
ansible -i <inventory> --ask-become-pass <playbook>
```
Jak widać jesteśmy pytani o hasło `BECOME password`:

![](20.png)

Kolejnym poleceniem było zrestartowanie usługi `sshd` i `rngd`, które w przypadku systemu operacyjnego fedora nie występuje domyślnie.

![](21.png)

Tworzymy poniższy playbook dokonujący restartu ssh

***restartsshd.yaml***
```yaml
- name: Restart ssh deamon
  hosts: Endpoints
  become: true
  tasks:
    - name: Use systemd to restart running sshd deamon
      systemd:
        name: sshd
        state: restarted
```

Następnie poniższym poleceniem dokonujemy restartu usługi `ssh` przy użyciu ansible:

```bash
 ansible-playbook -i inventory.yaml --ask-become-pass ./playbook/restartsshd.yaml
```

![](23.png)

Kolejnym poleceniem było przeprowadzenie operacji względem maszyny z wyłączonym serwerem SSH, odpiętą kartą sieciową.

Zatem przechodzimy do menadżera zarządzanej przez ansible maszyny wirtualnej i odpinamy kartę sieciową wybierając przełącznik `brak połączenia`:

![](24.png)

Następnie poniższym poleceniem zatrzymujemy usługę i sprawdzamy po tym jej status

```bash
systemctl stop sshd
systemctl status sshd
```

Widoczny wynik:

![](25.png)

Następnie próbujemy wykonać ping przy użyciu playbooka

```bash
ansible-playbook -i inventory.yaml ./playbook/pingall.yaml
```

Wynik wykonania polecenia: 

![](22.png)

## Zarządzanie kontenerem

Kolejnym krokiem było Uruchomienie kontenera sekcji `Deploy` z poprzednich zajęć przy użyciu playbooka.

Obraz node-js-tests-sample, który został zamieszczony na DockerHub.

![](26.png)

W celu poprawnego wykonania ćwiczenia należało na maszynie zarządzanej zainstalować oraz uruchomić `Dockera`

```bash
dnf -y install Docker
systemctl start Docker
```
Następnie tworzymy playbooka umożliwiającego pobranie oraz uruchomienie kontenera z aplikacją

***node.yaml***
```yaml
- name: Deploy node
  hosts: Endpoints
  tasks:
    - name: Pull node-js-tests-sample image from DockerHub
      docker_image:
        name: lukoprych/node-js-tests-sample:1.0.12
        source: pull
    
    - name: Run node container
      docker_container:
        name: node
        image: lukoprych/node-js-tests-sample:1.0.12
        state: started
        interactive: yes
        tty: yes
```
 
 Jak widać zamieszczono dwa zadania pullujące obraz oraz uruchamiające kontener node w trybie interaktywnym.

 ```bash
ansible-playbook -i inventory.yaml playbooks/node.yaml
```

Wynik wykonania polecenia:

![](27.png)

Jak widać stan maszyny został zmieniony ze względu na pobranie obrazu oraz uruchomienie kontenera.

Następnie poleceniami sprawdzamy istnienie obrazu oraz działanie kontenera:

```bash
sudo docker images
sudo docker ps
```
Jak widać obraz i kontener istnieją

![](28.png) ![](29.png)

Następnie powyższe kroki ubrano w rolę przy użyciu szkieletowania `ansible-galaxy`

W tym celu generujemy odpowiednią strukturę katalogową poleceniem

```bash
ansible-galaxy init deploy-irssi
```
Widoczna struktura katalogowa:

![](31.png)

W `tasks/main.yml` tworzymy zadania zbliżone do `node.yaml`

***main.yml***
```yaml
---
- name: Deploy node container
  docker_image:
    name: "lukoprych/node-js-tests-sample:{{ VERSION }}"
    source: pull

- name: Run node container
  docker_container:
    name: node
    image: "lukoprych/node-js-tests-sample:{{ VERSION }}"
    state: started
    tty: yes
    interactive: yes
```

Zadany parametr jest uzupełniany dzięki uzupełniu `defaults/main.yml`

***main.yml***
```yaml
---
VERSION: 1.0.12
```
Następnie tworzymy playbooka, który wykonuje utworzone role

***node-deploy.yaml***
```yaml
- name: Deploy node using node-deploy role
  hosts: Endpoints
  roles:
    - role: node-deploy
      vars:
        VERSION: "1.0.12"
```

Playbooka wywołujemy poleceniem

```bash
ansible-playbook -i ../inventory.yaml ../playbook/node-deploy.yaml
```

Wynik, jak widać obraz był już wcześniej pobrany na maszynę i nie dokonała się w tym zadaniu żadna zmiana:

![](30.png)

## Instalacje nadzorowane

