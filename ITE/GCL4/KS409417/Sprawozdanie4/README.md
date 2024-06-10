# Sprawozdanie 4

## Ansible
Ansible to popularne narzędzie open source do automatyzacji zarządzania konfiguracją, wdrażania aplikacji oraz orkiestracji procesów w środowiskach IT. Zapewnia prosty sposób na zarządzanie wieloma serwerami i urządzeniami z jednego punktu, używając prostych(albo i nie) plików konfiguracyjnych. Głównymi cechami Ansible jest bezagentowa architektura - wykorzystuje protokół SSH do komunikacji, nie wymaga instalacji oprogramowania na zarządzanych hostach.

## Instalacja ansible
Postawiłem drugą maszyne, której hostname to ansible-target. Tą maszynę wykorzystamy do testowania naszych playbooków.
Wymieniłem klucze ssh, by móc łączyć się z maszyną bez podawania hasła, zainstalowałem openssh i tar

![](images/openssh_install.png)

![](images/tar_version.png)

Dodałem maszynę do znanych hostów, bym mógł pingować ją czy łączyć się do niej za pomocą nazwy, a nie IP

![](images/add_host.png)

![](images/ping_ansible_target.png)

![](images/ssh_do_ansible_target.png)

# Inwentaryzacja

![](images/hostnamectl.png)

Stworzyłem plik inwentaryzacji, w którym umieściłem sekcje Orchestrators oraz Endpoints

![](images/inventory.png)

I następnie wysłałem ansible ping do wszystkich

![](images/ansible_ping.png)

Kolejnym krokiem było utworzenie playbooka w którym wysyłam ping do wszystkich maszyn, kopiuje plik inwentaryzacji na maszynę wirtualną, aktualizuję pakiety w systemie, restartuję usługę sshd i rngd

```yaml
---
- name: Ping
  hosts: all
  tasks:
    - name: ping
      ping:

- name: Copy
  hosts: Endpoints
  tasks:
    - name: Copy
      copy:
        src: ./inventory.ini
        dest: ~/

- name: Update package
  hosts: Endpoints
  vars:
    ansible_become_pass: <passwd>
  tasks:
  - name: update
    become: yes
    apt:
      name: "*"
      state: latest
      
- name: Restart sshd & rngd
  hosts: Endpoints
  vars:
    ansible_become_pass: <passwd>
  tasks:
    - name: Restart sshd
      become: yes
      service:
        name: ssh
        state: restarted

    - name: Restard rngd
      become: yes
      service:
        name: rng-tools
        state: restarted
```

Napotkałem problem z hasłem - otórz udało mi się na mojej maszynie za pomocą *sudo visudo* ustawić, bym nie musiał podawać hasła przy korzystaniu z komend sudo, natomiast na drugiej maszynie z jakiegoś powodu nie chciało to działać - więc dodałem plain text w playbooku - wiem, niezbyt dobra taktyka, ale jedyne inne rozwiązanie które przychodziło mi do głowy to podanie tego jako argumentu przy odpalaniu playbooka - co trochę zabiera mu automatyczności - na potrzeby opublikowania tego w sprawozdaniu hasła zamieniłem na "<passwd>"

![](images/ansible_playbook.png)

![](images/ansible_playbook_2.png)

Tutaj z wyłączonym SSH

![](images/stop_sshd.png)

![](images/ansible_playbook_no_ssh.png)

A tutaj z wyłączoną kartą sieciową

![](images/ansible_playbook_no_card.png)

Następnie utworzyłem playbook, w którym pobieramy z DockerHuba "opublikowaną" aplikację oraz odpalamy ją na maszynie ansible-target, następnie zatrzymujemy i usuwamy kontener

```yaml
---
- name: Run docker image
  hosts: Endpoints
  vars:
    ansible_become_pass: <passwd>
  become: yes
  tasks:
    - name: Download project from DockerHub
      docker_image:
        name: ksagan23/node_deploy:latest
        source: pull

    - name: Run app
      docker_container:
        name: node
        image: ksagan23/node_deploy:latest
        state: started
        ports:
        - "80:3000"
    
    - name: Stop the container
      docker_container:
        name: node
        state: stopped

    - name: Remove the container
      docker_container:
        name: node
        state: absent
```
![](images/ansible_playbook_deploy.png)

![](images/ansible_target_docker_ps.png)

Te kroki ubrałem w rolę za pomocą ansible-galaxy. *ansible-galaxy init deploy* co utworzyło taką strukturę plików:

![](images/ansible_galaxy.png)

Musiałem zmodyfikować kilka plików

np vars/main.yaml

```yaml
---
docker_image_name: ksagan23/node_deploy
docker_image_tag: latest
container_name: node
host_port: 80
container_port: 3000
```

tasks/main.yaml

```yaml
---
- name: Download project from DockerHub
  docker_image:
    name: "{{ docker_image_name }}:{{ docker_image_tag }}"
    source: pull

- name: Run app
  docker_container:
    name: "{{ container_name }}"
    image: "{{ docker_image_name }}:{{ docker_image_tag }}"
    state: started
    ports:
      - "{{ host_port }}:{{ container_port }}"

- name: Stop the container
  docker_container:
    name: "{{ container_name }}"
    state: stopped

- name: Remove the container
  docker_container:
    name: "{{ container_name }}"
    state: absent
```

oraz utworzyłem nowy playbook

```yaml
---
- name: Deploy Docker Container
  hosts: Endpoints
  vars:
    ansible_become_pass: <passwd>
  become: yes
  roles:
    - role: deploy
```

![](images/ansible_role.png)

I również sukces!

# Pliki odpowiedzi dla wdrożeń nienadzorowanych

Zainstalowałem system Fedora 40 pobrany z mirror'a onetu w wersji netinst
Po instalacji, przesłałem na swoją główną maszynę plik odpowiedzi anaconda-ks.cfg

![](images/fedora_download.png)

Do niego wrzuciłem kilka wzmianek na temat potrzebnych repozytoriów:

```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64
```

Musiałem uzupełnić plik o kolejne dodatkowe instrukcje

```
%packages
@^production-server
moby-engine

%end
```

tu by być w stanie uruchomić obraz z Docker Hub'a

dodałem również instrukcje wykonujące się już po instalacji systemu:

```kickstart
%post --erroronfail --log=/root/ks-post.log
```

Ten fragment ustawia zapisy logów do pliku /root/ks-post.log, a opcja --erroronfail sprawaia, że jeśli jakieś polecenie w bloku zakończy się błędem to skrypt instalacyjny również zakończy się błędem

```kickstart
network  --bootproto=dhcp --hostname=kacper
```

tutaj ustawiamy hostname na kacper oraz konfigurację sieci na DHCP

```kickstart
usermod -aG docker root
systemctl enable docker
cat << 'EOF' > /etc/systemd/system/node_deploy.service
```

następnie dodajemy root'a do grupy docker, by umożliwić wykonywanie poleceń Docker bez sudo, włączamy usługę Docker, by przy starcie systemu się włączała automatycznie oraz tworzymy nowy plik usługi

```kickstart
[Unit]
Description=Download app and run container
Requires=docker.service
After=docker.service
```

Definiujemy metadane:
- Description: opis usługi
- Requires: wymagania - potrzebuje uruchomionej usługi docker
- After: określa, że uruchamiamy ją po dockerze

```kickstart
[Service]
Type=oneshot
RemainAfterExit=yes

ExecStart=/usr/bin/docker pull ksagan23/node_deploy:latest
ExecStart=/usr/bin/docker run --name node ksagan23/node_deploy:latest
```

Definiujemy jak powinna być zarządzana i uruchomiona usługa. Wykonuje jedno polecenie i się kończy, jest aktywna po zakończeniu wykonania polecenia. 
ExecStart - polecenia, które wykonujemy - pobieramy apkę z dockerhuba a następnie uruchamiamy kontener z tym obrazem.

```kickstart
[Install]
WantedBy=multi-user.target
```

Usługa będzie uruchomiona w trybie multiuser

```kickstart
systemctl daemon-reload
systemctl enable node_deploy.service
systemctl start node_deploy.service
```

Następnie przeładowujemy demona, by uwzględnił konfigurację usługi, włączamy usługę node_deploy by włączała się przy rozruchu systemu oraz ją uruchamiamy 

Finalnie udało się nam postawić drugą maszynę z konfiguracją opartą o nasz plik anaconda-ks.cfg. By to osiągnąć, trzeba było zmienić źródło instalacji na nasz plik:

```
inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/KS409417/ITE/GCL4/KS409417/Sprawozdanie4/anaconda/anaconda-ks.cfg
```

![](images/fedora_download_2.png)

![](images/fedora_docker_ps.png)