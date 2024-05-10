# Sprawozdanie 4

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible
Aby poprawnie wykonać to zadanie konieczne było stworzenie drugiej maszyny wirtualnej na moim komputerze przy użyciu VirtualBoxa. Zainstalowałem drugi raz ubuntu w wersji 22.04 - jest to identyczny system jak w przypadku głównej maszyny.

Podczas tworzenia maszyny wirtualnej zapewniłem, że użytkownik nazywa się `ansible`, hostname to `ansible-target` oraz na końcu zrobiłem migawkę maszyny.

Oprogramowanie tar już było obecne na tej wersji, natomiast OpenSSH należało zainstalować komendą
```sh
sudo apt install openssh-client
```

Połączenie obu maszyn tak, by się widziały należało wykonać z niewielkimi przeszkodami. Pierwszym krokiem była zamiana typu sieci w jakiej te maszyny się znajdowały - NAT na NAT Network. To pozwala zapewnić, że obie te maszyny są w jednej sieci i możliwe jest ustanowienie połączenia między nimi.

Po tym kroku, sprawdzenie komendą ifconfig pozwala sprawdzić IP konkretnej maszyny. Maszyna o nazwie `ansible-target` w moim przypadku posiada IP 10.0.2.15, a główna maszyna: `10.0.2.4`.

Aby móc utworzyć połączenie ssh bez konieczności użycia klucza, konieczne jest wykonanie komendy:

```sh
ssh-keygen -t rsa -f ~/.ssh/ansible
```

gdzie flaga `-t` oznacza sposób szyfrowania, natomiast `-f` nazwę pliku do jakiego klucz ma być zapisany.

Przez to, że korzystamy z niedomyślnego klucza ssh należy do pliku `~/.ssh/config` dopisać:
```sh
Host ansible-target
    HostName 10.0.2.15 //ip ansible-target
    User ansible
    IdentityFile ~/.ssh/ansible
```

Potem konieczne jest skopiowanie klucza publicznego do pliku ~/.ssh/known_hosts:
```sh
ssh-copy-id -i ~/.ssh/ansible ansible@ansible-target
```

Dzięki temu, po wpisaniu:
```sh
ssh ansible@ansible-target
```

można bez podania klucza się połączyć z maszyną docelową, co widać na poniższym zrzucie ekranu:

<img src="images/1_ssh_polaczenie.png">

### Inwentaryzacja

Dzięki komendzie `hostnamectl` jesteśmy w stanie wyciągnać potencjalne nazwy komputerów. Aby nie musieć wywoływać maszyn jedynie poprzez ich adres IP należy wprowadzić nazwy DNS. W pliku /etc/hosts wystarczy dodać linijkę z adresem IP i po spacji nazwę do jakiej chcemy się odwoływać:

```
10.0.2.15 ansible-target
```

Mechanizm działa co widać na poniższym zrzucie ekranu:  

<img src="images/2_dns_names_work.png">


Następnym krokiem jest stworzenie pliku inwentaryzacji. Istnieją dwa sposoby: *inventory.ini* lub *inventory.yml*. W [dokumentacji ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html#get-started-inventory) na początku proponują użycie tej pierwszej metody, ale drugi sposób staje się rozsądniejszym, kiedy ilość węzłów wzrasta. Jako, że posiadamy jedynie jeden, to format `.ini` jest lepszym w tym przypadku.

Poniżej przedstawia się stworzona treść pliku:  
```
[Orchestrators]
devops-server

[Endpoints]
ansible-target
```

Następnie jesteśmy w stanie zweryfikować inwentarz po wykonaniu komendy:
```sh
ansible-inventory -i inventory.ini --list
```

<img src="images/3_ansible_inventory.png">

Jeśli plik posiada błędy, zostanie to zwrócone w ostrzeżeniach lub błędach.

Wysłanie żądania `ping` do wszystkich maszyn odbywa się poprzez połączenie ssh. Najwięcej ma sensu wysłanie pingu wyłącznie do maszyn z grupy `Endpoints`, jednakowoż, aby wysłać do *każdej* maszyny w naszym inwentarzu, konieczne jest dodanie kolejnego klucza do "samego siebie", czyli do IP 127.0.1.1, w przeciwnym wypadku konieczne będzie podanie hasła, a ansible zwróci błąd, dlatego też dodałem klucz jak wcześniej, ale dodałem go do pliku authorized_keys na tej samej maszynie.

Poniżej przedstawia się komenda wysłania pingu do grupy `Endpoints`:
```sh
ansible Endpoints -m ping -i inventory.ini
```

<img src="images/4_ansible_endpoints_ping.png">


Poniżej w przypadku wysłania do wszystkich maszyn (włącznie z orkiestratorem):  

<img src="images/5_ansible_all_ping.png">

Łączność między maszynami (endpointem a orkiestratorem) została zapewniona.

### Zdalne wywoływanie procedur

Rozpocząłem ten podpunkt od stworzenia pliku `playbook.yml` (alternatywnie: *.yaml*) według [oficjalnej dokumentacji](https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html)  

Playbooki to projekt automatyzacji w formacie `YAML`, dzięki któremu użytkownicy Ansible mogą wdrażać i konfigurować węzły na których działają.

Zadaniem playbooka jest wysłanie żądania `ping` do wszystkich maszyn, skopiowanie pliku inwentaryzacji na maszynę `Endpoints`, ponowienie operacji a następnie zaktualizowanie pakietów systemowych i restart usług `sshd` i `rngd`.

Usługa rngd nie istniała wcześniej na moim systemie ubuntu, co trzeba było zainstalować.
  
Treść tego pliku przedstawia się jak poniżej:
```yml
- name: Ping all machines
  hosts: all
  tasks:
  - name: Ping machines
    ping:
    
- name: Copy inventory
  hosts: Endpoints
  tasks:
  - name: Copy
    copy:
      src: ~/repo/MDO2024_INO/INO/GCL1/MJ410315/Sprawozdanie4/inventory.ini
      dest: ~/copied_inventory/inventory.ini

  - name: Copy (again)
    copy:
      src: ~/repo/MDO2024_INO/INO/GCL1/MJ410315/Sprawozdanie4/inventory.ini
      dest: ~/copied_inventory/inventory.ini

- name: Update package
  hosts: Endpoints
  vars:
    ansible_become_pass: ansible # Password is ansible in this case
  tasks:
  - name: update
    become: yes
    apt:
      name: "*"
      state: latest
  
- name: Restart sshd and rngd
  hosts: Endpoints
  vars:
    ansible_become_pass: ansible
  tasks:
  - name: Restart sshd
    become: yes
    service:
      name: sshd
      state: restarted
      
  - name: Restart rngd
    become: yes
    service:
      name: rngd
      state: restarted
```

Aby uruchomić takie polecenia takiego jak `sudo apt update` konieczne okazało się użycie słowa kluczowego `become=yes` i podania hasła do admina: `ansible_become_pass`, w przeciwnym wypadku ansible nie jest w stanie wykonać tego polecenia. Ostatecznie, uruchomienie odbywa się przy pomocy komendy:  

```sh
ansible-playbook -i inventory.ini playbook.yaml
```

<img src="images/8_ansible_whole_playbook.png">

Jak widać, po ponownym uruchomieniu polecenia skopiowania, okazało się, że flaga `changed` zmieniła się na `ok`, co znaczy, że nie była wykonana zmiana na systemie. Sumarycznie, 3 zmiany zostały zarejestrowane na systemie `ansible-target`: pierwsze kopiowanie oraz restart dwóch usług.

Jak natomiast zachowa się ten sam playbook, kiedy maszyny są niedostępne? Aby to sprawdzić, można wyłączyć kartę sieciową i serwer ssh:  

```sh
sudo ifconfig enp0s3 down
sudo systemctl stop ssh
```
Gdzie `enp0s3` to jest nazwa naszego urządzenia ubuntu. Wykonałem te komendy prosto na serwerze (bez użycia ssh):  

<img src="images/9_ntwrk_card_ssh_off.png">


Wykonanie playbooka odbywa się za pomocą identycznego polecenia jak wcześniej i wynik jest następujący:  

<img src="images/10_ansible_ntwrk_ssh_off.png">

Błąd jaki wyskakuje oznacza, że ansible nie jest w stanie połączyć się z maszyną i kończy działanie playbooka. Ostatecznie, aby móc się znów połączyć do serwera, włączyłem ponownie sieć i ssh.

<img src="images/11_ntrk_card_ssh_on.png">


### Zarządzanie kontenerem

W tym kroku należy użyć obrazów z poprzednich laboratoriów w celu uruchomienia ich kontenerów (naszej zbudowanej aplikacji). W moim przypadku, jest to `Redis`, którego udostępniłem na dockerhubie jako obraz `michaljurzak/redis_build:v1.0`. To jest taki sam obraz, jak w etapie `Build` a także `Publish`, dlatego ograniczyłem się wyłącznie do pobrania tego obrazu i uruchomienia go na drugiej maszynie wirtualnej.

Na samym początku chciałem przetestować czy się kontener uruchamia. Poniżej załączony kod playbooka:

```yaml
- name: Install docker
  hosts: Endpoints
  vars:
    ansible_become_pass: ansible
  tasks:
  - name: Install / ensure installation
    become: yes
    apt:
      name: docker.io
      state: latest
  
  - name: start on boot
    become: yes
    command: systemctl enable --now docker
  
- name: Download Redis Image
  hosts: Endpoints
  vars:
    ansible_become_pass: ansible
  tasks:
  - name: check if volume exists
    become: yes
    command: docker volume inspect vol
    register: vol_exists_result
    failed_when: false
    
  - name: create vol
    when: vol_exists_result is failed
    command: docker volume create vol
  
  - name: download and run
    become: yes
    community.docker.docker_container:
      name: ansible_redis
      image: michaljurzak/redis_build:v1.0
      command: ./src/redis-server
      state: started
      recreate: true
      volumes:
      - vol:/redis
      exposed_ports:
      - 6379
```

Wyniki w konsolach są następujące:

<img src="images/12_container_playbook.png">
 
<img src="images/13_results.png">

Jak widać, poprawnie zostało zaimplementowane pobranie dockera i utworzenie wolumenu (jeśli nie istnieje już taki). Dzięki modułowi `community.docker.docker_container` jesteśmy w stanie utworzyć nowy kontener bazując na danym obrazie. W tym przypadku, domyślnie ustawione jest, aby brakujący obraz pobrać z repozytorium dockerhuba. Dodatkowo istnieją takie opcje jak: `state`, który oznacza w tym przypadku uruchomienie, ale może być np. `present`, który wyłącznie tworzy kontener. `recreate` zapewnia ponowne utworzenie kontenera, `command` wykonuje daną komendę, w tym przypadku uruchomienie usługi redisa. Można także załączyć woluminy i wyeksponować porty, tu: domyślny port redisa `6379`.

Można zatem przejść do automatycznego zatrzymania i usuwania kontenera.

Do wyżej załączonego kodu, aby usunąć kontener, należy dołączyć poniższy fragment:

```yaml
- name: Stop and remove container
  hosts: Endpoints
  vars:
    ansible_become_pass: ansible
  tasks:
  - name: stop and remove container
    become: yes
    community.docker.docker_container:
      name: ansible_redis
      state: absent
```

Zasadniczo, usunięcie polega na zmianie stanu na `absent`. Według [dokumentacji](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html#parameter-state), oznacza to zatrzymanie i usunięcie.

Ustatecznie w konsoli wygląda to następująco:

<img src="images/14_final_playbook.png">


Poniżej także można zauważyć, że na drugiej maszynie nie ma żadnego kontenera, natomiast pozostał wolumin którego nie usuwaliśmy ręcznie:
  
<img src="images/15_final_playbook_proof.png">

Ostatni punkt tego laboratorium polegał na ubraniu tych kroków w rolę używając szkieletowania `ansible-galaxy`.

Nie jest oczywiste jak do tego zagadnienia podejść, natomiast wykorzystałem jedno z [tego poradnika](https://www.cherryservers.com/blog/ansible-roles-tutorial), które przedstawia generalny zarys i proste zagadnienie, dlatego zmieniłem analogicznie do mojego problemu.

Rozpoczynamy poprzez stworzenie folderu `~/ansible/roles` w którym będziemy przetrzymywać role. Następnie, aby stworzyć pierwszą rolę skorzystamy z komendy:  

```sh
ansible-galaxy init redis_container
```

<img src="images/16_roles_commands.png">

Wewnątrz tej roli stworzone zostały kolejne foldery a ich struktura jest następująca:

<img src="images/17_role_contents.png">

W poradniku jest napisane, że w `default/main.yml` znajdują się zmienne niskiego priorytetu, dlatego w tym przykładzie możemy to pominąć, tak samo jak utworzenie templatki w kroku 4 poradnika.

Główna zmiana nastąpiła w kroku 5 poradnika, gdzie należało zmienić w lokalizacji `tasks/main.yml` nieco zawartość playbooka tak, by to były wyłącznie taski. Zmieniona zawartość u mnie wygląda jak poniżej:

```yaml
---
# tasks file for redis_container
- name: Install docker
  become: yes
  vars:
    ansible_become_pass: ansible
  apt:
    name: docker.io
    state: latest

- name: start on boot
  vars:
    ansible_become_pass: ansible
  become: yes
  command: systemctl enable --now docker

- name: check if volume exists
  vars:
    ansible_become_pass: ansible
  become: yes
  command: docker volume inspect vol
  register: vol_exists_result
  failed_when: false

- name: create vol
  vars:
    ansible_become_pass: ansible
  become: yes
  when: vol_exists_result is failed
  command: docker volume create vol

- name: download and run
  vars:
    ansible_become_pass: ansible
  become: yes
  community.docker.docker_container:
    name: ansible_redis
    image: michaljurzak/redis_build:v1.0
    command: ./src/redis-server
    state: started
    recreate: true
    volumes:
    - vol:/redis
    exposed_ports:
    - 6379

- name: stop and remove container
  vars:
    ansible_become_pass: ansible
  become: yes
  community.docker.docker_container:
    name: ansible_redis
    state: absent
```

I to wszystko w kwestii modyfikacji istniejących plików. Dla wygody, skopiowałem plik inwentaryzacji `inventory.ini` do folderu `ansible`, a w nim utworzyłem także nowy playbook `role_playbook.yaml`, którego zawartość jest niezwykle prosta:

```yaml
- name: Run redis
  hosts: Endpoints
  roles:
  - redis_container
```

<img src="images/18_role_playbook_final.png">

Jak widać, wynik jest ten sam, a role pozwalają na znaczne uproszczenie ostatecznego playbooka. Warto jedynie udokumentować role, ponieważ dodajemy kolejny poziom abstrakcji.

Na sam koniec, skopiowałem folder `ansible` zawierający ostatni playbook i wszystkie role do folderu ze sprawozdaniem.


## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Druga część tego sprawozdania będzie się skupiać na przygotowaniu źródła instalacyjnego systemu dla maszyny wirtualnej/fizycznego serwera/środowiska IoT. Takie źródło stosuje się przy automatyzacji instalacji środowiska testowego dla oprogramowania, które nie pracuje całkowicie w kontenerze.

Na początku, należy zainstalować system fedora na nowej maszynie wirtualnej poprzez *network instalator*. Pobrałem z tego względu [obraz fedory](https://ftp.icm.edu.pl/pub/Linux/fedora/linux/releases/40/Server/x86_64/iso/) (rozszerzenie *.iso*) i przeszedłem kroki w VirtualBoxie na utworzenie maszyny wirtualnej z pobranym obrazem jako bazowym.

Następnie, po uruchomieniu, ukazują się trzy opcje w konsoli. Wybrałem zwykłą instalację fedory. Po chwili ukazuje się instalator w wersji graficznej:

<img src="images/1_ekran_instalacji.png">

Na powyższym zrzucie ekranu jestem już po wybraniu kilku opcji:
- Język Polski, z dodatkowym wsparciem angielskiego
- Źródło instalacji dodane jako `http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64`, analogicznie jak w sprawozdaniu.
- Minimalna instalacja ze wsparciem menadżera kontenerów
- użytkownik `michaljurzak`

Rozpoczęcie instalacji trwa chwilę:  

<img src="images/2_instalacja_1.png">

A następnie zakończenie każe nam uruchomić komputer ponownie

<img src="images/3_instalacja_koniec.png">

Problematyczne w przypadku automatycznego wdrażania na wielu komputerach byłoby potwierdzenie ponownego uruchomienia, dlatego w pliku konfiguracyjnym jaki wyciągniemy z maszyny w następnym kroku, będzie trzeba dodać odpowiednią opcję uruchomienia od razu.

Następnym krokiem w tych laboratoriach jest skopiowanie pliku odpowiedzi. Znajduje się on w ścieżce `/root/anaconda-ks.cfg`. Problem w tym, że chcąc skopiować na inne urządzenie poprzez `scp` nie jesteśmy w stanie w prosty sposób dostać się do tej ścieżki, ponieważ należy to zrobić z komendą `sudo`.

Jednym rozwiązaniem jest skopiowanie pliku do ścieżki do której mamy dostęp, (np. `/`):

```sh
sudo cp /root/anaconda-ks.cfg .
```
A następnie zmiana uprawnień:

```sh
sudo chmod 666 anaconda-ks.cfg
```

Aby wszyscy mogli odczytywać i zapisywać do tego pliku. Teraz dopiero jesteśmy w stanie skopiować na lokalny komputer:

```sh
scp -P 4444 michaljurzak@localhost:/anaconda-ks.cfg .
```

Należy treść pliku trochę zmienić:

- instalację `graphical` na `text` aby można było z pliku
- dodać dwie linijki:
  ```py
  url --mirrorlist="http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64"
  repo --name=updates-released --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64
  ```
  ponieważ nie została załączona informacja na temat repozytorium i mirrora jakiego chcemy użyć.
- Należy upewnić się, że dysk będzie całkowicie formatowany:
  `clearpart --all`.
- Także należy zmienić hostname inny niż domyślny localhost:
  ```py
  network  --hostname=michaljurzakhost.com
  ```
  W podsekcji `network` w [dokumentacji IBM](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax#sect-kickstart-commands) możemy znaleźć jak korzystać z opcji hostname.
  
Ostatecznie zawartość pliku `anaconda-ks.cfg` wygląda jak poniżej:
  
```ini
# Generated by Anaconda 40.22.3
# Generated by pykickstart v3.52
#version=DEVEL
# Use graphical install
text

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8 --addsupport=en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=michaljurzakhost.com

url --mirrorlist="http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64"
repo --name=updates-released --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64

%packages
@^minimal-environment
@container-management

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.9.1
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all

# System timezone
timezone Europe/Warsaw --utc

#Root password
rootpw --lock
user --groups=wheel --name=michaljurzak --password=$y$j9T$F48fH82sUKnZnzMpb5znHQ9T$wdDG.7vl5iIImZ.kwsql1jadyeEcWgr4RaYfWhXVLK2 --iscrypted

reboot
```

Jest to pierwsza część która przedstawia, czy jest możliwe uruchomienie. Aby móc uruchomić w VirtualBoxie plik `kickstart` potrzebujemy umieścić ten plik tam, gdzie może mieć dostęp instalacja. Moim docelowym hostem jest github, a dokładniej, to repozytorium online. Należy się odwołać do tego pliku poprzez tryb `surowy`, ponieważ w przeciwnym razie instalacja uruchomi się w sposób manualny.

Tak więc, podczas uruchomienia w konsoli wchodzimy w tryb `GRUB`, w kórym możemy modyfikować opcje poprzez wciśnięcie klawisza `e`. Pozwala to na modyfikacje uruchomienia poprzez wprowadzenie linijki:

```sh
init.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/MJ410315/INO/GCL1/MJ410315/Sprawozdanie4/anaconda-ks.cfg
```

która definiuje nam źródło pliku kickstart, za pomocą którego ma być prowadzona instalacja nienadzorowana. 

<img src="images/4_grub_opcje.png">

Uruchamiamy instalację dzięki `F10` lub `ctrl+x`. 
Na poniższym zrzucie ekranu widać, że plik został poprawnie odczytany (początek instalacji):

<img src="images/5_instalacja_w_konsoli.png">

W trakcie:

<img src="images/6_instalacja_dalej.png">

I na końcu po instalacji uruchamia się tak samo ekran jak przed instalacją. Różnica polega na tym, że należy wejść w opcję `Troubleshooting`. Ukazuje się kilka opcji, ale uruchamiamy `Boot first drive`.

<img src="images/7_po_instalacji.png">

Poniżej natomiast widać potwierdzenie działania systemu, ale bez dockera:

<img src="images/8_pierwszy_dowod_bez_dockera.png">

### Rozszerzenie o repozytoria i oprogramowanie potrzebne do uruchomienia programu.

W przypadku wybranego przeze mnie projektu - `Redisa` najprostszym sposobem jest użycie obrazu dockera do uruchomienia programu. Aby uruchomić dockera konieczne jest załącznie paczek:

```
@^server-product-environment
moby-engine
```

Aby ostatecznie otrzymać dockera i uruchomić kontener rozszerzę kickstart o sekcję `%post`. Plik kickstarter pozwala na dodanie zarówno skryptu `pre` jak i `post`. Sekcja przedstawia się jak poniżej:

```
%post --erroronfail

cat << 'EOF' > /etc/systemd/system/docker-redis.service

usermod -aG docker root
systemctl enable docker

[Unit]
Description=docker download and run
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes

ExecStart=/usr/bin/docker pull michaljurzak/redis_build:v1.0
ExecStart=/usr/bin/docker run -t -d --name reddis -e TERM=xterm michaljurzak/redis_build:v1.0 ./src/redis-server

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable docker-redis.service
systemctl start docker-redis.service

%end
```

Powyższy kod zasadniczo korzysta z `systemd`, który jest menedżerem inicjalizacji i zarzadzania usług w systemach linuxowych. 

Na początku tworzymy serwis o nazwie `docker-redis.service`, który będzie zarządzany przez systemd.

Pierwsza sekcja [Unit] określa metadane serwisu, takie jak inne jednostki, od których zależy ten serwis (`Requires=`), oraz kolejność uruchamiania w stosunku do innych jednostek (`After=`).

Następnie, w sekcji [Service], definiujemy działanie samego serwisu. Określamy tutaj, że proces będzie jednorazowy (`Type=oneshot`), co oznacza, że systemd będzie czekał na zakończenie tego procesu przed przejściem do innych jednostek. Ponadto, ustawiamy, że mimo zakończenia procesu, systemd powinien nadal traktować serwis jako aktywny (`RemainAfterExit=`). W końcu, podajemy ścieżkę i argumenty, aby uruchomić proces (`ExecStart=`).

Ostatnia sekcja [Install] definiuje, w jaki sposób jednostka ma być zachowywana w systemie. Tutaj, używamy dyrektywy `WantedBy=`, aby określić, że serwis powinien być włączony domyślnie.

Po zdefiniowaniu jednostki, umieszczamy ją w odpowiednim miejscu w systemie, zgodnie z zasadami systemd. Zwykle najbezpieczniej jest modyfikować jednostki w katalogu `/etc/systemd/system`.

Ostatnim krokiem jest przeładowanie zmian w systemd oraz uruchomienie naszego serwisu. Komenda `systemctl daemon-reload` służy do przeładowania nowych konfiguracji, a następnie ustawiamy nasz serwis jako uruchamiany domyślnie i natychmiast go uruchamiamy poprzez odpowiednio `systemctl enable docker-redis.service` i `systemctl start docker-redis.service`.

Powtarzamy kroki jak podczas uruchomienia. Na sam koniec, sprawdźmy czy usługa została uruchomiona:

<img src="images/10_final.png">

Jak widać na zrzucie ekranu, usługa dockera działa, a także kontener redisa został uruchomiony. Aby kontener był cały czas uruchomiony, konieczne jest uruchomienie go w trybie *detached* z opcją `-d`, co widać powyżej.