# Sprawozdanie 4 - Konrad Rezler
## Zajęcia 08
## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
### Instalacja zarządcy Ansible
Na moim urządzeniu utworzyłem przy pomocy VM Boxa drugą maszynę wirtualną, wykorzystując ten sam system operacyjny, co na mojej głownej maszynie: `Ubuntu`. 
Tworząc maszynę zapewniłem, aby `ansible-target` było nazwą hosta, a `ansible` było nazwą użytkownika. 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/2. Utwórz drugą maszynę wirtualną o jak najmniejszym zbiorze zainstalowanego oprogramowania.png">
</p>
Na mojej głównej maszynie zainstalowałem Ansible:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/1. Na głównej maszynie wirtualnej (nie na tej nowej!), zainstaluj oprogramowanie Ansible, najlepiej z repozytorium dystrybucji.png">
</p>

Następnie zapewniłem na nowej maszynie obecność programu `tar`, serwera OpenSSH `sshd` oraz `net-tools`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/3.1. zapewnij obecnosc tar.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/3.2. zapewnij obecnosc openssh.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/4. sprawdzanie ifconfig.png">
</p>
Następnie wykonałem migawkę maszyny:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/5. Zrób migawkę maszyny (lub przeprowadź jej eksport).png">
</p>

Przed wymianą kluczy pomiędzy urządzeniami wykonałem jeszcze kilka kroków pośrednich:
- Zmieniłem typ sieci obu urządzeń na mostkowy i zarejestrowałem je w sieci w akademiku:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/5.0.0 zmieniłem typ sieci na mostkowa.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/5.0.1 dodałem komputer do sieci akademika.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/7.1.1 dodałem hosta do sieci akademickiej.png">
</p>

- Wygenerowałem klucze `ssh` na obu maszynach:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/5.2 Wymień klucze SSH.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/6. wygenerowałem klucze na nowej maszynie.png">
</p>

- Pobrałem adresy ip obu maszyn komendą `hostname -I` i wymieniłe klucze ssh pomiędzy maszynami. Klucze mojej głównej maszyny nazywa się `ansible1.pub`, natomiast klucz nowej maszyny to `ansible2.pub`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/5.3 przesłałem klucz ssh do nowej maszyny .png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/7.2 wysłanie z nowej maszyny do hosta.png">
</p>

- Wymienione klucze zamieściłem w pliku `authorized_keys`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/7. klucz który OTRZYMAŁEM wrzuciłem do authorized_keys.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/7.1 na drugiej maszynie zrobiłem to samo.png">
</p>

- W folderze `.ssh` utworzyłem plik `config`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/8. utworzyłem plik config.png">
</p>
powyżej utworzony plik od razu po utworzeniu posiadał następującą zawartość:

```
Host ansible-target
    HostName 192.168.65.116
    User ansible
    IdentityFile ~/.ssh/ansible1
```
Jednakże próbując się połączyć napotkałem nastepujące ostrzeżenie:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/10. za duże uprawnienia do klucz ansible2.pub.png">
</p>

Dlatego, starając się to naprawić metodą prób i błędów, zmieniłem uprawnienia kilku następujących plików: 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/11. próba ze zmianą uprawnień.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/12. zmiana uprawnien po stronie nowej maszyny.png">
</p>

Następnie skorzystałem z poniższej komendy, aby skopiować klucz publiczny do pliku `~/.ssh/known_hosts`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/13. przesłanie do knownhost do ziutka.png">
</p>

Po licznych bataliach nareszcie udało się, aby łączenie przy pomocy komendy `ssh ansible@ansible-target` nie wymagało podania hasła:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/14. udało się połączyć.png">
</p>

### Inwentaryzacja

Przy pomocy komendy `hostnamectl` sprawdziłem nazwę hosta na nowej maszynie:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/14.5 sprawdzam nazwę ansible hosta.png">
</p>

Następnie wprowadziłem nazwy DNS dla maszyn wirtualnych modyfikując plik /etc/hosts:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/15. przeszedłem do etc aby zmodyfikowac plik hosts.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/16. dodałem tę drugą linijkę.png">
</p>

Po czym zwerifikowałem łącznąść używając komendy `ping <hostname>`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/17. ping.png">
</p>

Na podstawie działań przedstawionych w sekcjach `Instalacja zarządcy Ansible` oraz `Inwentaryzacja` mogę stwierdzić, że udało się:
- [x] Użyć co najmniej dwóch maszyn
- [x] Dokonać wymiany kluczy między maszyną-dyrygentem, a końcówkami (`ssh-copy-id`)
- [x] Łączność SSH między maszynami jest możliwa i nie potrzebuje haseł

### Zdalne wywoływanie procedur

Aby wykonać żądanie `ping` do wszystkich maszyn najpierw utworzyłem nowy pliki `inventory.ini` oraz zamieściłem w nim następującą treść:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/18. utworzyłem plik inventory.ini.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/19. zamiescilem tresc do stworzonego pliku .ini.png">
</p>

Dodatkowo aby móc wykonać `ping` dodałem (ręcznie) swój klucz ssh `ansible1.pub` do authorized keys oraz zamieściłem swoje dane w folderu config:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/20. dodałem swój klucz do authorized_keys.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/21. dodałem swoje dane do folderu config.png">
</p>

Powyższe działania umożliwiły mi wykonanie pingu:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/22. efekt.png">
</p>

Po udanej operacji `ping` utworzyłem plik `playbook.yml`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/23. utworzenie pliku do playbook.png">
</p>

który posiadał następującą treść, gdzie w miejscach `<haslo>` zamieściłem hasło do maszyny wirtualnej:
```
---
- name: Pingowanie
  hosts: all
  tasks:
    - name: pingowanie
      ping:

- name: Kopiowanie
  hosts: Endpoints
  tasks:
    - name: Copy
      copy:
        src: ./inventory.ini
        dest: ~/

- name: Update package
  hosts: Endpoints
  vars:
    ansible_become_pass: <haslo> 
  tasks:
  - name: update
    become: yes
    apt:
      name: "*"
      state: latest
      
- name: Restart usług sshd i rngd
  hosts: Endpoints
  vars:
    ansible_become_pass: <haslo>
  tasks:
    - name: Restart usługi sshd
      become: yes
      service:
        name: ssh
        state: restarted

    - name: Restart usługi rngd
      become: yes
      service:
        name: rng-tools
        state: restarted

```

Na nowej maszynie pobrałem usługę rngd
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/24. pobrałem usługę rngd.png">
</p>

A następnie wykonałem polecenie `ansible-playbook -i inventory.ini playbook.yaml`, co pozwoliło uzyskać następujący efekt:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/25. succes 1.png">
</p>

Ponowne wywołanie tej metody daje delikatnie inny wynik, widać to na przykład przy tasku `copy`, gdzie status `changed` zmienił się na `ok`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/26. copy za drugim razem.png">
</p>

Powyższe operację przeprowadziłem również dla dwóch dodatkowych przypadków:
- względem maszyny z wyłączonym serwerem SSH:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/27. wyłączanie ssh na nowej maszynie.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/27.1 status po zastopowaniu.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/27.2 łącznąść po wyłączeniu ssh.png">
</p>

- względem maszyny z wyłączoną kartą sieciową
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/27.3 wyłączanie karty sieciowej.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/27.4 łączenie po wylączeniu karty sieciowej.png">
</p>

Po czym oczywiście ponownie włączyłem kartę sieciową:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/28. spowrotem włączyłem kartę sieciową.png">
</p>

### Zarządzanie kontenerem

Moim pierwszym krokiem było utworzenie nowego pliku o rozszerzoniu `.yaml` :
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/29. utworzyłem nowy plik.png">
</p>

w którym zamieściłem następującą treść: 
```
- name: Run docker image
  hosts: Endpoints
  vars:
    ansible_become_pass: <haslo>
  become: yes
  tasks:
    - name: Download project from DockerHub
      docker_image:
        name: krezler21/irssi_fork:latest
        source: pull

    - name: Run app
      docker_container:
        name: irssi
        image: krezler21/irssi_fork:latest
        state: started
        ports:
        - "80:3000"
```
oraz na nowej maszynie zainstalowałem dockera (łącząc się z nią za pomocą komendy `ssh ansible@ansible-target`) :
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/30. zainstalowałem docker na nowej maszynie łącząc się przez ssh.png">
</p>

Jednakże realizując zadanie poprzez powyższe czynności napotkałem błąd: 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/31. zaczal pojawiac sie blad.png">
</p>

Z tego też powodu zmieniłem treść pliku `irssi.yaml` na następującą, aby przygotować maszynę:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/31.2 poczatkowa tresc pliku aby przygotowac maszyne.png">
</p>

Niestety nie pomogło to całkowicie rozwiązać wszystkich problemów, ze względu na brak miejsca na moim komputerze. Stąd zmuszony byłem podjąć radykalne kroki, wykorzystać kontener `hello-world`. Z tego też powodu ostateczna wersja pliku prezentuje się następująco: 
```
- name: Run docker image
  hosts: Endpoints
  vars:
    ansible_become_pass: DJktvhpa66
  become: yes
  tasks:
    - name: Download project from DockerHub
      docker_image:
        name: hello-world
        source: pull

    - name: Run app
      docker_container:
        name: irssi
        image: hello-world
        state: started
        ports:
        - "80:3000"
```

Podjęcie takich kroków pozwoliło mi z sukcesem wdrożyć kontener na nową maszynę:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/32. sukces.png">
</p>

Powyższe kroki ubrałem w role za pomocą szkieletowania `ansible-galaxy`. W tym celu skorzystałem z komendy `ansible-galaxy init deploy-irssi` w dotychczas wykorzystywanym przeze mnie katalogu, co pozwoliło uzyskać następującą strukturę plików:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/34. po odpowiedniej komendzie powstala taka struktura plikow.png">
</p>
oraz utworzyłem nowy plik `.yaml`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/35. utworzyłem nowy yaml.png">
</p>

Powyżej stworzone pliki uzupełniłem o następującą treść:
- galaxy.yaml
```
- name: Deploy irssi using deploy-irssi role
  hosts: Endpoints
  roles:
    - /home/konrezl2/ansible/roles/deploy-hello
```

- tasks/main.yml
```
---
- name: Pull docker image from DockerHub
  vars:
    ansible_become_pass: <haslo>
  become: yes
  docker_image:
    name: "hello-world"
    source: pull

- name: Run hello-world
  vars:
    ansible_become_pass: <haslo>
  become: yes
  docker_container:
    name: hello-world
    image: "hello-world"
    state: started
```

Co pozwoliło wdrożyć kontener poprzez wykorzystanie szkieletowania `ansible-galaxy`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/36. ubrałem powyższe powyższe kroki w rolę, za pomocą szkieletowania ansible-galaxy.png">
</p>

## Zajęcia 09
## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Zainstalowałem system Fedora, stosując instalator sieciowy (neist). Następnie stworzyłem nową maszynę wirtualną:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/1. Zainstaluj system Fedora, stosując instalator sieciowy (netinst).png">
</p>

Upewniając się, że maszyna posiada ssh, wysłałem plik odpowiedzi do `anaconda-ks.cfg` na moją główną maszynę wirtualną:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/2. Pobierz plik odpowiedzi .png">
</p>

Wspomniany wyżej plik poddałem edycji:
- dodałem linijki zawierające informacje o repozytoriach systemu fedora:
  * `url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64`
  * `repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64`
- dodałem również linijkę odpowiedzialną za wymuszenie formatowania dysku przy każdej instalacji:
  * `clearpart --all`
 
Dodatkowo zamieściłem fragment odpowiedzialny za stworzenie konenera z aplikacją po zainstalowaniu systemu. Ostateczna wersja pliku prezentowała się następująco:
```
# Generated by Anaconda 39.32.6
# Generated by pykickstart v3.48
#version=DEVEL
# Use graphical install
graphical

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

%packages
@^server-product-environment
moby-engine

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.8.1
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all 

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted $y$j9T$Aap3Bczt34o5ZIE0AITVObbW$b.eEMJ7wzMMUo7QSbAFAmQQnYmDdFO4IeXiae92HHN1

# Repositories
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64

network  --bootproto=dhcp --hostname=konrezl2

%post --erroronfail --log=/root/ks-post.log

cat << 'EOF' > /etc/systemd/system/irssi-docker.service

usermod -aG docker root
systemctl enable docker

[Unit]
Description=Download docker and run
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/docker pull krezler21/irssi_fork:latest
ExecStart=/usr/bin/docker run --name irssi krezler21/irssi_fork:latest
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable irssi-docker.service
systemctl start irssi-docker.service

%end
```

Aby uprościć instalację zhostowałem plik anaconda-ks.cfg, dzięki czemu system mógł pobrać go przy instalacji:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/3. tworzę nowe repo, aby umożliwić pobranie pliku.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/4. sklonowalem repo i wrzucilem do niego plik anaconda.png">
</p>

Ręcznie skopiowałem ten plik do sklonowanego repozytorium po czym spushowałem zmiany:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/5. push do repo.png">
</p>

W folderze na moim prywatnym urządzeniu utworzyłem plik `file.ps1`, który umożliwił mi automatyczne tworzenie maszyny. Zdecydowałem się na taki krok, aby posiadać łatwy dostęp do zainstalowanego na początku zajęć instalatora sieciowgo (neist).
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/6. utworzylem plik, który ma pomoc w automatycznym tworzeniu maszyny.png">
</p>

Powyższy plik uzupełniłem o następującą treść:
```
# Ustawienia ścieżki do VBoxManage.exe
$VBoxManagePath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# Ustawienia maszyny wirtualnej
$vmName = "Fedora"
$isoPath = "C:\Users\sromk\Downloads\Fedora-Server-netinst-x86_64-39-1.5.iso"

# Utwórz maszynę wirtualną
& "$VBoxManagePath" createvm --name $vmName --ostype "RedHat_64" --register

# Skonfiguruj parametry maszyny wirtualnej
& "$VBoxManagePath" modifyvm $vmName --memory 2048 --acpi on --boot1 dvd --nic1 nat

# Utwórz dysk twardy wirtualnej maszyny
& "$VBoxManagePath" createhd --filename "$vmName.vdi" --size 8000

# Dodaj kontroler dysków SATA
& "$VBoxManagePath" storagectl $vmName --name "SATA Controller" --add sata

# Podłącz dysk twardy do kontrolera SATA
& "$VBoxManagePath" storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vmName.vdi"

# Podłącz obraz ISO jako napęd DVD
& "$VBoxManagePath" storageattach $vmName --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium $isoPath

# Uruchom maszynę wirtualną
& "$VBoxManagePath" startvm $vmName
```

Umożliwiłem w PowerShellu uruchamianie skryptów oraz uruchomiłem skrypt:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/7. w powershell umożliwienie uruchamiania skryptów.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/8. uruchamianie skryptu.png">
</p>

Tworząc nową maszynę w taki sposób przy starcie maszyny należało zmienić szczegóły instalacji, mianowicie zamieścić link do zhostowanego wcześniej pliku:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/9. tworzac nowa maszyna przy pomocy skryptu podaje link do shostowanego wczesniej pliku.png">
</p>

Następnie instalacja rozpoczęła się bez potrzeby ustawiania czegokolwiek:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/10. system sie samodzielnie instaluje.png">
</p>

Po uruchomieniu ukazał się następujący widok, co świadczy o poprawnym zainstalowaniu systemu oraz uruchomieniu kontenera z aplikacją:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie9-png/11. startuje serwis z dockerem.png">
</p>
