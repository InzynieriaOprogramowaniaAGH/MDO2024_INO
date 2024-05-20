# Sprawozdanie 4
## Marcin Pigoń
## ITE gr. 4

### Cel: Zapoznanie się z zarządcą Ansible oraz instalacją nienadzorowaną

### Lab 8 & 9

*Ansible* jest narzędziem open-source, które służy do automatyzacji zarządzania konfiguracją, wdrażania aplikacji oraz orkiestracji zadań. Jest bezagentowy - oznacza to, że maszyny docelowe nie wymagają instalowania dodatkowego oprogramowania. Komunikacja odbywa się poprzez SSH. Ansible jest dosyć prosty w użyciu oraz korzysta z YAML - język, który jest logiczny oraz czytelny dla człowieka.

Pierwszym zadaniem było stworzenie nowej maszyny wirtualnej, która miała jak najmniejszy zbiór oprogramowania. Maszyna działała na najnowszej dystrybucji Fedory - Fedora40. Chcemy wykazać, że jedynie potrzeba SSH oraz tar, żeby na systemie dało się instalować nowe oprogramowanie oraz zarządzać nią. Ansible należało jedynie zainstalować na głównej maszynie (zarządcy). 

Instalacja Ansible odbywa się wskutek komendy `sudo dnf install -y ansible`. W analogiczny sposób pobieramy tar oraz sshd na nowej maszynie (ale sshd jest już domyślnie pobrane w systemie).

Kolejnym krokiem było utworzenie użytkownika 'ansible' oraz nadanie hostname 'ansible-target' dla odbiorcy. Użytkownika możemy dodać przez `sudo useradd ansible` i wykorzystać `sudo passwd ansible` do zmiany hasła. Zmiany nazwy host'a możemy dokonać przez `sudo hostnamectl set-hostname ansible-target`. Hostname służy do identyfikacji maszyny w sieci, żeby nie musieć pamiętać adresów IP, co może być kłopotliwe przy większej infrastrukturze IT. 

Jak już było wspomniane, Ansible działa przez łącza SSH. W tym celu należy wygenerować hasło poleceniem `ssh-keygen`, które domyślnie wygeneruje parę kluczy o typie rsa - jeden prywatny a drugi publiczny. Klucz publiczny należy przesłać do maszyny odbiorczej, w tym celu zastosowano `ssh-copy-id <user>@<ip>`.

Wymiana kluczy ssh, umożliwiająca łączenie się bez podawania hasła

![alt text](image.png)

Wymiana udana - klucz został skopiowany do pliku `.ssh/authorized_keys` w maszynie odbiorczej, co pozwala nam na połączenie się bez podawania hasła.

![alt text](image-1.png)

Upewnienie się, że program tar jest zainstalowany

![alt text](image-2.png)

Dodanie do `etc/hosts` ansible-target, żeby umożliwić połączenie się za pomocą hostname.

![alt text](image-3.png)

Możemy teraz się łączyć do maszyny poprzez `ssh <user>@<hostname>` zamiast ip.

![alt text](image-4.png)

### Inwentaryzacja

Ansible Inventory, czyli inwentarz, jest listą hostów, na których Ansible ma wykonywać zadania. Określamy adresy hostów poprzez adresy IP lub ich nazwę DNS. Plik ten może być formatu `.ini` lub `.yaml`. Różnica polega na tym, że `.yaml` jest zazwyczaj stosowany do bardziej złożonych infrastruktur, ponieważ jest czytelniejszy. Jednak w scenariuszu korzystamy jedynie z dwóch maszyn, więc dlaczego użyłem `.ini`. 

Plik `inventory.ini` wygląda następująco:

```
[Orchestrators]
fedora ansible_user=marcin

[Endpoints]
ansible-target ansible_user=ansible

```

Podział jest na `Orchestrators`, czyli maszyna nadzorująca - wysyłająca instrukcje. W tym przypadku adresem jest to hostname mojej głównej maszyny `fedora` oraz użytkownik na niej wpisany `marcin`. 

`Endpoints` to węzły końcowe, nasze docelowe. W tym przypadku jest to adres DNS `ansible-target` oraz użytkownik `ansible`. 

Po utworzeniu inwentarza, możemy odwoływać się do wymienonych w nim maszyn. Pierwszym zadaniem było pingowanie wszystkich hostów. Możemy wywołać komendę `ansible -i inventory.ini all -m ping`. Jednak napotkałem problem: pingowanie fedory przez siebie: nie było klucza w authorized keys. Z nieznanych mi przyczyn plik `authorized_keys` był katalogiem a nie plikiem.

![alt text](image-5.png)

Po zmianie i wklejeniu klucza, udało się wywołać ping.

![alt text](image-6.png)

### Playbook Ansible

Playbook w Ansible to plik napisany w formacie `.yaml` lub `.yml`, który definiuje zestaw zadań do wykonania na danych hostach. Playbooki są podstawowym narzędziem do automatyzacji procesów konfiguracyjnych, wdrożeniowych oraz zarządzania infrastrukturą w Ansible. Każdy playbook składa się z jednego lub więcej "plays", a każdy "play" opisuje zestaw zadań (tasks) do wykonania na określonych grupach hostów.

Playbooki wywołujemy komendą `ansible-playbook -i <inventory.ini/yaml> <playbook-name.yaml>`

#### ping.yml

Pierwszym playbookiem do napisania był playbook, który wysyła żądanie `ping` do wszystkich maszyn. Praktycznie to samo co wcześniej, tylko w formie playbooka.

Napisano taki playbook:

```
- name: Ping all machines
  hosts: all
  tasks:
    - name: Ping all machines
      ping:
```

Po jego wywołaniu otrzymujemy wynik:

![alt text](image-7.png)

Ping się udał, dostajemy odpowiedź `ok` dla obu hostów. 

### copy_inventory.yml

Kolejnym playbookiem był `copy_inventory.yml`, czyli playbook zajmujący się przesyłaniem pliku `inventory.ini` do maszyny docelowej. Plik wygląda następująco:

```
- name: Copy inventory file to Endpoints
  hosts: Endpoints
  tasks:
    - name: Copy inventory.ini to Endpoints
      copy:
        src: /home/marcin/MDO2024_INO/ITE/GCL4/MP412902/Sprawozdanie4/ansible_quickstart/inventory.ini
        dest: /home/ansible/

```

Pierwsze uruchomienie pokazuje nam, że dokonane zostały zmiany na maszynie docelowej.

![alt text](image-8.png)

Drugie uruchomienie różni się tym, że zmian nie ma, gdyż plik został już przekopiowany wcześniej i istnieje na maszynie. Jest to przydatne w przypadku, kiedy nie jesteśmi pewni czy każda maszyna ma plik i czy on jest aktualny - nie ma błędu jeśli plik już istnieje. 

![alt text](image-9.png)

Sprawdzenie istnienia pliku na drugiej maszynie wirtualnej

![alt text](image-10.png)

### update.yml

Playbook ten zajmował się aktualizacją wszystkich packages w systemie. Jest to częsty use-case dla administratorów oraz DevOpsów. 

```
- name: Update packages on target system
  hosts: Endpoints
  tasks:
    - name: Upgrade all packages
      ansible.builtin.dnf:
        name: "*"
        state: latest
      become: true
```

Jednak, wystąpił problem, ponieważ pierwsza wersja playbooka nie miała `become`. Become odpowiedzialne jest za nadanie playbookowi autoryzacji administratorskich (dostęp do sudo).

![alt text](image-11.png)

Sprawdzenie pakietów przed update.

![alt text](image-12.png)

Po odpaleniu update.yml z opcją `--ask-become-pass` (odpowiedzialne za pobranie z wejścia standardowego hasła sudo) oraz dodaniu `become: true` do playbooka otrzymujemy taki wynik:

![alt text](image-15.png)

Kolejne sprawdzenie pakietów weryfikuje ich aktualizację.

![alt text](image-13.png)

### restart.yml

Playbook ten zajmuje się restartowaniem usług sshd oraz rngd. Wygląda następujaco:

```
- name: Restart sshd and rngd services
  hosts: Endpoints
  become: yes
  tasks:
    - name: Restart sshd service
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd service
      ansible.builtin.service:
        name: rngd
        state: restarted
```

Próbując go uruchomić otrzymujemy błąd

![alt text](image-16.png)

Nie ma rngd, więc trzeba zainstalować. W takim przypadku należałoby uzupełnić playbook o instalacje potrzebnych usług:

```
- name: Install and restart sshd and rngd services
  hosts: Endpoints
  become: yes
  tasks:
    - name: Install rng-tools
      dnf:
        name: rng-tools
        state: present

    - name: Install OpenSSH Server
      dnf:
        name: openssh-server
        state: present

    - name: Restart sshd service
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd service
      ansible.builtin.service:
        name: rngd
        state: restarted
```

Lub zainstalować je ręcznie na maszynie:

![alt text](image-17.png)

Start usługi oraz sprawdzenie czy jest aktywna

![alt text](image-18.png)

Następnie wywołano playbook i zrestartowano usługi.

![alt text](image-19.png)

Widać, że usługa rng została zrestartowana, ponieważ czas działania jest od momentu wywołania playbook'a restart. Pozwala nam to na weryfikację działania playbooka. 

![alt text](image-20.png)

Na czerwono podświetlony tekst potwierdza restart usługi.

### Odpięcie karty sieciowej oraz wyłączenie usługi SSH

Odpięcie karty sieciowej wykonane zostało za pomocą ustawień VirtualBox'a. 

![alt text](image-14.png)

Wyłączenie SSH poprzez zatrzymanie usługi SSH oraz sprawdzenie statusu.

![alt text](image-21.png)

Próba przekopiowania inventory.ini do maszyny wirtualnej przez odpowiedni playbook kończy się błędem `unreachable`.

![alt text](image-22.png)

Maszyna wirtualna nie może odnaleźć w sieci target'a, więc program Ansible nie jest w stanie przesłać pliku. 

Po zrestartowaniu maszyny i ustawieniu bridged adapter, wszystko działa jak powinno.

![alt text](image-23.png)

### Konteneryzacja za pomocą Ansible

W celu pobrania obrazu, który był umieszczony na DockerHub na poprzednich zajęciach dzięki pipeline'owi Jenkins należy zainstalować program Docker na maszynie docelowej. Krok ten może zostać wykonany ręcznie lub optymalniej wewnątrz playbook'a. Podczas wykonywania laboratorium wykonałem instalację manualnie, ale gdybym miał je powtórzyć to te kroki wykonałbym poprzez Ansible.

![alt text](image-24.png)

Sprawdzenie, czy Docker prawidłowo może pobrać obraz testowy `hello-world`.

![alt text](image-25.png)

Należało napisać playbook do pobrania obrazu oraz uruchomienie kontenera z nim. 

```
- name: Pull Docker image and run container
  hosts: Endpoints
  become: yes
  tasks:
    - name: Pull the image
      community.docker.docker_image:
        name: phisiic/utt-deployer
        tag: "1.93"
        source: pull

    - name: Run the container 
      community.docker.docker_container:
        name: utt-deployer
        image: phisiic/utt-deployer:1.93
        state: started
        interactive: yes
        tty: yes
```

Jednak playbook z instalacją dockera przed pobraniem obrazu musiałby być rozszerzony o instrukcje:

```
    - name: Install Docker
      dnf:
        name: docker
        state: present
```

Sprawdzenie poprawnego pobrania z playbooka oraz uruchomienia kontenera

![alt text](image-26.png)

### Role w `Ansible`

Role w Ansible to struktury organizacyjne, które umożliwiają grupowanie powiązanych zadań, zmiennych, plików i szablonów w łatwe do ponownego użycia moduły, co ułatwia zarządzanie i skalowanie skomplikowanych konfiguracji.

Tworzymy rolę w ansible-galaxy *utt-deployer*

![alt text](image-27.png)

W nowo utworzonym katalogu `tasks`, powstałym dzięki powyższej komendzie, uzupełniamy plik `/tasks/main.yml` o instrukcje podobne do wcześniej napisanego playbooka

![alt text](image-28.png)

Wersję możemy ustawić wewnątrz `defaults/main.yml`

![alt text](image-29.png)

Należy teraz napisać playbook, który wykorzystuje rolę 

![alt text](image-30.png)

Po jego uruchomieniu otrzymałem błąd:

![alt text](image-31.png)

Sugeruje on, że docker nie ma uprawnień na systemie docelowym, więc należy użyć `become`. W tym celu należy uzupełnić `/tasks/main.yml` oraz w playbook'u `role.yml`, który korzysta z zadań w utt-deployer. 

`/tasks/main.yml`
```
- name: Pull the image
  become: yes
  community.docker.docker_image:
    name: "phisiic/utt-deployer:{{ VERSION }}"
    source: pull

- name: Run node container
  become: yes
  community.docker.docker_container:
    name: utt
    image: "phisiic/utt-deployer:{{ VERSION }}"
    state: started
    tty: yes
    interactive: yes
```

`role.yml`
```
- name: Deploy utt using role
  hosts: Endpoints
  roles:
    - role: utt-deployer
  become: yes
```

Wskutek tych zmian otrzymujemy taką informację

![alt text](image-32.png)

Oznacza, że obraz nie został znowu pobrany, tylko skorzystał z gotowego (wcześniej pobranego obrazu) i jedyną zmianą było ponowne uruchomienie kontenera z obrazu. 

### Instalacje nienadzorowane

Instalacje nienadzorowane to proces automatycznego instalowania systemu operacyjnego bez interakcji użytkownika, wykorzystując wcześniej przygotowane pliki konfiguracyjne, takie jak Kickstart. Kickstart pozwala na zdefiniowanie wszystkich parametrów instalacji, takich jak partycjonowanie dysku, instalowane pakiety i ustawienia sieci, co umożliwia szybkie i spójne wdrożenie wielu systemów.

Początkowo należało zainstalować nowy obraz maszyny wirtualnej o systemie operacyjnym Fedora 39 z instalatora sieciowego. Wybrano tę wersję Fedory, ponieważ jest stabilniejsza i wersja 40 jest nowa, co oznacza, że może występować wiele błędów. 

Mając świeży system Fedory 39, który miała jedynie użytkownika wyszukujemy plik `anaconda-ks.cfg` oraz wyświetlamy zawartość przez `cat`. Przekopiowano zawartość pliku do głównej maszyny z dostępem do repozytorium przedmiotowego, żeby w łatwy sposób móc mieć do tego pliku później dostęp. Plik ten zawierał informacje o użytkowniku oraz roocie, jak i partycji dysku - system fedory, który byłby tworzony na podstawie tego pliku wyglądałby identycznie do tego, w którym ręcznie prowadzono instalację. 

Należało dodać jednak link do zewnętrznego repozytorium, skąd można było pobrać Fedorę, gdyż nie było to podawane przez użytkownika podczas instalacji. 

```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-39&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f39&arch=x86_64
```

Również, żeby wyczyścić dysk przed instalacją systemu należy dodać `clearpart --all`.

Wstawiłem plik na swoją gałąź w repozytorium oraz wziąłem do niego link, ponieważ będzie przydatny podczas instalacji. 

W tym momencie, możemy sprawdzić poprawność zmodyfikowanego pliku i spróbować zainstalować Fedorę z plikiem konfiguracyjnym. Podczas bootowania systemu należało nacisnąć `e`. Wyświetla się GRUB i trzeba dodać linku do wstawionego na GitHubie pliku.

![alt text](image-34.png)

Odpalenie zainstalowanej maszyny oraz zalogowanie się do użytkownika z pliku anaconda-ks.cfg

![alt text](image-35.png)

Maszyna jest zainstalowana poprawnie z pliku konfiguracyjnego, więc można wykonać dalszą część laboratorium - dodanie czynności po instalacyjnych (post)

Ostateczny plik `anaconda-ks.cfg` wygląda następująco:

```
# Generated by Anaconda 39.32.6
# Generated by pykickstart v3.48
#version=DEVEL
# Use graphical install
graphical

# Keyboard layouts
keyboard --vckeymap=gb --xlayouts='gb'
# System language
lang en_GB.UTF-8

# Repository
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-39&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f39&arch=x86_64

%packages
@^custom-environment
moby-engine
%end

# Generated using Blivet version 3.8.1
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --lock
user --groups=wheel --name=feduser --password=$y$j9T$moT4qSTXSaO0QNUSxRYiSWvO$JqYyWExzp/i8hDy1oBFION3hsXBOVdVEgrDSYprLMbB --iscrypted --gecos="feduser"

%post --erroronfail --log=/root/ks-post.log

cat << 'EOF' > /etc/systemd/system/utt-docker.service

usermod -aG docker root
systemctl enable docker

[Unit]
Description=Download docker and run
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/docker pull phisiic/utt-deployer:1.93
ExecStart=/usr/bin/docker run -t --name utt-deploy -e TERM=xterm phisiic/utt-deployer:1.93

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable utt-docker.service
systemctl start utt-docker.service

%end
```

Fragment `packages` to lista pakietów, które mają być zainstalowane. Tutaj należy dodać `moby-engine`, który jest silnikiem Docker'a.

Sekcja `post` jest używana do definiowania skryptów, które mają zostać uruchomione po zakończeniu głównego procesu instalacji systemu. Docker działa jedynie na uruchomionym systemie, nie da się z nim komunikować na etapie instalatora systemu, więc skorzystam z tej sekcji, żeby uruchomić pobrać swój obraz z DockerHub oraz utworzyć usługę, która uruchamia kontener z obrazu. 

* `--erroronfail`: instalacja zwraca błąd, jeśli jakiekolwiek polecenie zakończy się niepowodzeniem.

* `--log=/root/ks-post.log`: Wszystkie wyjścia standardowe i błędy z tej sekcji będą zapisane do pliku /root/ks-post.log. Dzięki temu można później sprawdzić, co dokładnie zostało wykonane i czy wystąpiły jakieś problemy.

* `cat << 'EOF' > /etc/systemd/system/utt-docker.service`: utworzenie pliku usługi z wszystkim co jest poniżej

* `usermod -aG docker root`: dodaje `root` do grupy `docker`

* `systemctl enable docker`: Włącza usługę Docker, aby uruchamiała się automatycznie przy starcie systemu.

**[Unit]**
* `Description`: Opis usługi.
* `Requires=docker.service`: Usługa wymaga uruchomionej usługi Docker.
* `After=docker.service`: Usługa zostanie uruchomiona po uruchomieniu usługi Docker.

**[Service]**
* `Type=oneshot`: Usługa wykonuje jedno polecenie i kończy działanie.
* `RemainAfterExit=yes`: Usługa pozostaje aktywna po zakończeniu wykonania polecenia.
* `ExecStart=/usr/bin/docker pull phisiic/utt-deployer:1.93`: Pobiera obraz Docker phisiic/utt-deployer:1.93.
* `ExecStart=/usr/bin/docker run -t --name utt-deploy -e TERM=xterm phisiic/utt-deployer:1.93`: Uruchamia kontener Docker utt-deploy z obrazem phisiic/utt-deployer:1.93. Term odpowiada za terminal, który jest wykorzystywany w kontenerze i musimy to wstawić, żeby zapewnić poprawne działanie kontenera.

**[Install]**
* `WantedBy=multi-user.target`: Usługa będzie uruchamiana w trybie wieloużytkownikowym. 

Następnie wystartowano usługę.

W taki sam sposób co wcześniej przeprowadzono instalację nienadzorowaną z aktualnego pliku na GitHubie. 

Odpalając maszynę możemy sprawdzić czy utt-docker.service jest odpalony:

![alt text](image-36.png)

I widzimy, że obraz istnieje świeżo po instalacji, bez potrzeby manualnego pobrania.  

Kontener również został utworzony i zakończył się prawidłowo.

![alt text](image-37.png)

Po ponownym wystartowaniu kontenera, widzimy, że licznik czasu wynosił 2 minuty - oznacza to, że przy starcie kontener się odpalił w tle, działał i zakończył się po minucie. Ponowne odpalenie tego samego kontenera doliczyło minutę do poprzedniej. Wiem, że service działał w tle, ponieważ mogłem się zalogować do maszyny oraz operować w niej, podczas gdy skrypt utt się wykonywał.

![alt text](image-38.png)

Sprawdzając status utt-docker.service widzimy, że usługa jest **active (exited)**. Wcześniej ten service był w stanie **activating**.

![alt text](image-39.png)