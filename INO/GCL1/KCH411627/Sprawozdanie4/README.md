# Sprawozdanie 4

## Cel ćwiczenia
## Przebieg ćwiczenia - zajęcia 8 

### Utworzenie drugiej maszyny wirtualnej

Utworzyłem drugą maszynę wirtualną z systemem *ubuntu server 24.04.4* (tak jak maszyna główna)

<div align="center">
    <img src="screenshots/ss_01.png" width="850"/>
</div>

<div align="center">
    <img src="screenshots/ss_02.png" width="850"/>
</div>

<br>

Wybrałem opcje instalacji systemu o jak najmniejszym zbiorze zainstalowanego oprogramowania

<div align="center">
    <img src="screenshots/ss_03.png" width="850"/>
</div>

<br>

Nadałem maszynie *hostname* `ansible-target` oraz utworzyłem użytkownika `ansible`

<div align="center">
    <img src="screenshots/ss_04.png" width="850"/>
</div>

<br>

System zainstalował się pomyślnie (widok po reboot'cie)

<div align="center">
    <img src="screenshots/ss_05.png" width="850"/>
</div>

<br>

 System posiada program `tar` oraz server `OpenSSH`

<div align="center">
    <img src="screenshots/ss_06.png" width="850"/>
</div>

### Połączenie sieciowe maszyn

Aby maszyny mogły się widzieć w sieci muszą należeć do jednej sieci

Więc utworzyłem nową sieć NAT o nazwie *MyNatNetwork* w VirtualBox'ie po przez przejście `File > Tools > Network Manager > NAT networks > create `

<div align="center">
    <img src="screenshots/ss_07.png" width="850"/>
</div>

<br>

Dodałem obie maszyny do nowo utworzonej sieci

<div align="center">
    <img src="screenshots/ss_08.png" width="850"/>
</div>

<br>

Sprawdziłem ip maszyny głównej (`10.0.2.4`)

<div align="center">
    <img src="screenshots/ss_09.png" width="850"/>
</div>

<br>

Oraz ip drugiej maszyny (`10.0.2.15`)

<div align="center">
    <img src="screenshots/ss_10.png" width="850"/>
</div>

<br>

Sprawdziłem czy maszyny się widzą po przez `ping`

<div align="center">
    <img src="screenshots/ss_14.png" width="850"/>
</div>

<br>


Wróciłem do ustawień sieci *MyNatNetwork* i dodałem przekierowanie portów aby móc się połączyć z hosta

<div align="center">
    <img src="screenshots/ss_11.png" width="850"/>
</div>

<br>

Połączenia z hosta do maszyny głownej

<div align="center">
    <img src="screenshots/ss_12.png" width="850"/>
</div>

<br>

Połączenie z hosta do drugiej maszyny

<div align="center">
    <img src="screenshots/ss_13.png" width="850"/>
</div>

### Wymiana kluczy ssh

Utworzyłem klucz ssh z algorytmem szyfrowania *ed25519*

<div align="center">
    <img src="screenshots/ss_15.png" width="850"/>
</div>

<br>

Wymieniłem klucz SSH pomiędzy użytkownikiem na głównej maszynie i użytkownikiem ansible.

<div align="center">
    <img src="screenshots/ss_16.png" width="850"/>
</div>

<br>

Dodałem utworzony klucz do agenta SSH i zalogowałem się do drugiej maszyny. Wymiana kluczy się udała, teraz nie trzeba wpisywać hasła przy logowaniu.

<div align="center">
    <img src="screenshots/ss_17.png" width="850"/>
</div>

### Inwentaryzacja

Zainstalowałem `ansible` na maszynie głównej

<div align="center">
    <img src="screenshots/ss_18.png" width="850"/>
</div>

<br>

Zapisałem ip 10.0.2.15 (druga maszyna) jako ansible-target do pliku `etc/hosts` aby łączyć się po nazwie a nie po adresie ip

<div align="center">
    <img src="screenshots/ss_19.png" width="850"/>
</div>

<br>

Sprawdziłem połączenie po nazwie za pomocą `ping`

<div align="center">
    <img src="screenshots/ss_20.png" width="850"/>
</div>

### Plik inwentaryzacji

Utworzyłem plik inventory.ini, w którym są trzy sekcje `Orchestrators`, `Endpoints` oraz `All`.

```
[Orchestrators]
devops ansible_user=kamil

[Endpoints]
ansible-target

[All:children]
Orchestrators
Endpoints
```
<br>

Wysłałem żądanie `ping` do wszystkich maszyn (musiałem dodać klucz ssh do maszyny głównej aby móc się do niej połączyć)

<div align="center">
    <img src="screenshots/ss_21.png" width="850"/>
</div>

### Zadalne wywoływanie procedur

Utworzyłem plik `playbook.yaml`

Stworzyłem *play* który jako zadanie ma wysłanie `ping` do wszystkich maszyn

```
- name: Ping play
  hosts: All
  tasks:
  - name: Ping all hosts
    ansible.builtin.ping:
```

<br>

Stworzyłem nowy *play* który będzie wykonywał zadania na maszynie w sekcji `Endpoints`

Napisałem zadanie które tworzy nowy folder *ansible* i kopiuje do niego plik `inventory.ini` z głównej maszyny, a następnie kopiuje drugi raz.

```
- name: Endpoints play
  hosts: Endpoints
  tasks:
  - name: Creating directory
    become: true    
    ansible.builtin.file:
      path: ~/ansible
      state: directory
      mode: '0755'

  - name: Copying inventory file
    copy:
      src: inventory.ini
      dest: ~/ansible/inventory.ini

  - name: Copying inventory file again 
    copy:
      src: inventory.ini
      dest: ~/ansible/inventory.ini
```

<br>

Kolejne zadanie aktualizuje pakiety w systemie

```
  - name: Package update
    become: true
    ansible.builtin.apt:
      name: "*"
      state: latest
```

<br>

Ostatnie zadania restartują usługi `sshd` i `rngd`

```
  - name: Sshd restart
    become: true 
    ansible.builtin.service:
      name: sshd
      state: restarted

  - name: Rngd restart
    become: true
    ansible.builtin.service:
      name: rng-tools
      state: restarted
```

<br>

Cały plik `playbook.yaml`

```
- name: Ping play
  hosts: All
  tasks:
  - name: Ping all hosts
    ansible.builtin.ping:

- name: Endpoints play
  hosts: Endpoints
  tasks:
  - name: Creating directory
    become: true    
    ansible.builtin.file:
      path: ~/ansible
      state: directory
      mode: '0755'

  - name: Copying inventory file
    copy:
      src: inventory.ini
      dest: ~/ansible/inventory.ini

  - name: Copying inventory file again 
    copy:
      src: inventory.ini
      dest: ~/ansible/inventory.ini
      
  - name: Package update
    become: true
    ansible.builtin.apt:
      name: "*"
      state: latest

  - name: Sshd restart
    become: true 
    ansible.builtin.service:
      name: sshd
      state: restarted

  - name: Rngd restart
    become: true
    ansible.builtin.service:
      name: rng-tools
      state: restarted
  
```

<br>

Uruchomiłem playbooka z opcją `--ask-become-pass` aby móc wykonać polecenia które potrzebują uprawnień administratora (zadania z `become: true`) 

<div align="center">
    <img src="screenshots/ss_22.png" width="850"/>
</div>

Przy ponownym skopiowaniu pliku `inventory.ini` zmienił się stan z `changed` na `ok`

<br>

Na drugiej maszynie wyłączyłem server SSH i uruchomiłem

```
sudo systemctl stop ssh
```

I uruchomiłem ponownie playbooka na maszynie głównej, durga maszyna jest `unreachable`, `Connection refused`

<div align="center">
    <img src="screenshots/ss_23.png" width="850"/>
</div>

<br>

Odpiąłem karte sieciową od drugiej maszyny (odznaczyłem *Cable Connected*)

<div align="center">
    <img src="screenshots/ss_24.png" width="850"/>
</div>

<br>

Uruchomiłem ponownie playbooka, druga maszyna jest `unreachable`, `Connection timed out`

<div align="center">
    <img src="screenshots/ss_25.png" width="850"/>
</div>

### Modyfikacja aplikacji z poprzednich zajęć

Przez to że wybrana przeze mnie aplikacja ([maven-demo](https://github.com/davidmoten/maven-demo)) nic nie robi, postanowiłem że dopisze funkcje `main` od niej

```
public class Thing {
    public static void main(String[] args) {
        System.out.println("Hello world! Hello maven!");
    }
}
```

Oraz dodam do `pom.xml` potrzebny plugin aby móc zbudować fatjar'a

```
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <configuration>
        <appendAssemblyId>
            false
        </appendAssemblyId>
        <archive>
            <manifest>
                <mainClass>demo.Thing</mainClass>
            </manifest>
        </archive>
        <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
    </configuration>
    <executions>
        <execution>
            <id>make-assembly</id> 
            <phase>package</phase> 
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```
Dzięki tym modyfikacjom aplikacja wyświetla napis "*Hello world! Hello maven!*" po uruchomieniu.

### Zarządzanie kontenerem

Utworzyłem nowy plik playbook o nazwie `docker-playbook.yaml`

Napisałem pierwszy `play` który polega na pobraniu `docker`, utworzeniu folderu o nazwie `ansible` i przekopiowaniu do niego pliku `.jar`

```
-name: Docker prepare
  hosts: Endpoints
  tasks:
  - name: Download docker
    become: true
    ansible.builtin.apt:
      name: docker.io
      state: latest

  - name: Creating directory
    become: true    
    ansible.builtin.file:
      path: ~/ansible
      state: directory
      mode: '0755'

  - name: Copying jar file 
    copy:
      src: ~/devops/maven-demo/target/maven-demo-0.1-SNAPSHOT.jar
      dest: ~/ansible/app.jar
```
<br>

Następnie utworzyłem nowy `play` którego zadaniami są:

Uruchomienie `dockera`

```
  - name: Start docker
    become: true
    ansible.builtin.service:
      name: docker
      state: started
```
Utworzenie i uruchomienie konteneru deployowego w trybie interaktywnym z obrazu `openjdk` (jedyna wymaga dependencja do wybranego przeze mnie projektu) 

```
  - name: Create a deploy container
    become: true
    community.docker.docker_container:
      name: deploy 
      image: openjdk 
      detach: true
      interactive: true
```

Przekopiowanie pliku `.jar` do kontenera deployowego (aby móc używać `community.docker.docker_container_copy_into` musiałem zaktualizować kolekcję `community.docker` poleceniem 
`ansible-galaxy collection install community.docker`)

```      
  - name: Copy a jar file into the deploy container
    become: true
    community.docker.docker_container_copy_into:
      container: deploy 
      path: /home/ansible/ansible/app.jar
      container_path: app.jar
```
Uruchomienie aplikacji w kontenerze

```
  - name: Run app in deploy container
    become: true
    community.docker.docker_container_exec:
      container: deploy
      command: java -jar app.jar
    register: result
```
Wyswietlenie wyniku aplikacji

```
  - name: Print stdout
    ansible.builtin.debug:
      var: result.stdout
```

Usunięcie kontenera

```
  - name: Remove deploy container
    become: true
    community.docker.docker_container:
      name: deploy
      state: absent
```

<br>

Cały `docker-playbook.yaml`

```
-name: Docker prepare
  hosts: Endpoints
  tasks:
  - name: Download docker
    become: true
    ansible.builtin.apt:
      name: docker.io
      state: latest

  - name: Creating directory
    become: true    
    ansible.builtin.file:
      path: ~/ansible
      state: directory
      mode: '0755'

  - name: Copying jar file 
    copy:
      src: ~/devops/maven-demo/target/maven-demo-0.1-SNAPSHOT.jar
      dest: ~/ansible/app.jar
      
- name: Docker play
  hosts: Endpoints
  tasks:
  - name: Start docker
    become: true
    ansible.builtin.service:
      name: docker
      state: started
  
  - name: Create a deploy container
    become: true
    community.docker.docker_container:
      name: deploy 
      image: openjdk 
      detach: true
      interactive: true
      
  - name: Copy a jar file into the deploy container
    become: true
    community.docker.docker_container_copy_into:
      container: deploy 
      path: /home/ansible/ansible/app.jar
      container_path: app.jar

  - name: Run app in deploy container
    become: true
    community.docker.docker_container_exec:
      container: deploy
      command: java -jar app.jar
    register: result

  - name: Print stdout
    ansible.builtin.debug:
      var: result.stdout

  - name: Remove deploy container
    become: true
    community.docker.docker_container:
      name: deploy
      state: absent
```

<br>

Wynik uruchomienia playbooka


<div align="center">
    <img src="screenshots/ss_26.png" width="850"/>
</div>

### Role 

Utworzyłem dwie role `Docker_prepare` i `Docker` w nowo stworzonym folderze `roles`


<div align="center">
    <img src="screenshots/ss_27.png" width="850"/>
</div>

<br>

Dla roli `Docker-prepare` przekopiowałem zadania z `play` "Docker prepare" do `roles/Docker_prepare/tasks/main.yml`

Dla roli `Docker` przekopiowałem zadania z `play` "Docker play" do `roles/Docker/tasks/main.yml`

Utworzyłem nowy playbook `role-playbook.yaml` w folderze `roles`

```
- name: Run docker 
  hosts: Endpoints
  roles:
  - Docker_prepare 
  - Docker
```

Uruchomiłem nowy playbook, wynik jest taki sam jak poprzednio.

<div align="center">
    <img src="screenshots/ss_28.png" width="850"/>
</div>

## Przebieg ćwiczenia - zajęcia 9 

### Pobranie i zainstalowanie fedory

Pobrałem obraz [fedory](https://mirroronet.pl/pub/mirrors/fedora/linux/releases/40/Server/x86_64/iso/) server 40, utworzyłem nową maszynę wirtualną i rozpocząłem instalacje


<div align="center">
    <img src="screenshots/ss_29.png" width="850"/>
</div>

<br>

Wybrałem minimalną instalację oprogramowania

<div align="center">
    <img src="screenshots/ss_30.png" width="850"/>
</div>

<br>

Ustawiłem hostname `fedora-server`

<div align="center">
    <img src="screenshots/ss_31.png" width="850"/>
</div>

<br>

Utworzyłem użytkownika `fedora`

<div align="center">
    <img src="screenshots/ss_32.png" width="850"/>
</div>

<br>

Dodałem link do repozytoriów

<div align="center">
    <img src="screenshots/ss_33.png" width="850"/>
</div>

<br>

Instalacja fedory przebiegła pomyślnie

<div align="center">
    <img src="screenshots/ss_34.png" width="850"/>
</div>

<br>

Połączyłem się z fedorą przez ssh i skopiowałem plik `root/anaconda-ks.cfg`

Aby plik odpowiedzi zawsze formatował cały dysk dodałem do niego polecenie

```
clearpart --all
```