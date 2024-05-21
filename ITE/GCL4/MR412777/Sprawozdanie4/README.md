# Sprawozdanie 4

---
# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible. Pliki odpowiedzi dla wdrożeń nienadzorowanych.

## Magdalena Rynduch ITE GCL4

Celem laboratorium było wdrożenie kontenera na drugiej maszynie za pomocą Ansible oraz utworzenie źródła instalacji 
nienadzorowanej dla systemu operacyjnego hostującego oprogramowanie.

Instrukcje realizowane były przy użyciu:
- hosta wirualizacji: Hyper-V
- wariantu dystrybucji Linux'a: Ubuntu, Fedora

Laboratorium rozpoczęłam od utworzenia drugiej maszyny wirtualnej o tym samym systemie co główna – w tym przypadku było to Ubuntu. Następnie zainstalowałam tar oraz openssh-server. Instalacja ta zapewnia podstawowe narzędzia i usługi, które mogą być potrzebne w procesie zarządzania konfiguracją za pomocą Ansible.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9d0b36c2-b60b-4533-95f9-29fae68ca59c)

Nadałam maszynie hostname `ansible-target`, co ułatwi dalszą identyfikację i zarządzanie nią z poziomu innych maszyn.
 
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1c1ffcd8-0b7b-4d95-9899-8f4700edca0e)

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/df4576d2-b228-4f57-884c-497b53cdb4f4)

Dla uporządkowanie w zarządzaniu systemu, utworzyłam użytkownika `ansible`.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/3e20352d-e174-49a9-a549-c8c8679d36f0)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/293ba9dd-dc4e-4b2d-ae96-d16cc275e215)

Na tym etapie wykonałam migawkę maszyny.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/86b8bc47-c5f7-4e13-a6bf-08f5bbbfccf2)

Kolejnym etapem była instalacja oprogramowania Ansible z repozytorium dystrybucji, co pozwala na korzystanie z oficjalnej, stabilnej wersji narzędzia, zapewniając regularne aktualizacje.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e6d147b1-064e-4eaf-8ebf-d497922b68d7)

Zweryfikowałam połączenie pomiędzy maszynami.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f1e162f7-6fe3-4cf0-aebd-07443d3675b5)

Korzystając z `visudo` umożliwiłam logowanie się na użytkowników bez podawania hasła, dzięki czemu dalsza automatyzacja będzie ułatwiona.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/294de188-0fbd-4221-be38-ec27d2a2ec45)

Na nowej maszynie wymagało to dodania następującej linii:
```
ansible ALL=(ALL) NOPASSWD: ALL
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1c8aad7c-99e2-4776-9339-0562eb887d5c)

Analogicznie postąpiłam na głównej maszynie.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0313eca5-c08f-4409-b42a-d18de8801f5d)
 
Następnie na wygenerowałam nowy klucz `id_rsa` na `ansible-target`.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b54ff659-abcb-4174-9a7a-871becf40ebc)

Kolejnym krokiem była wymiana kluczy ssh za pomocą polecenia `ssh-copy-id`. Proces ten polega na skopiowaniu klucza publicznego z jednego hosta na drugi, umożliwiając uwierzytelnianie się bez hasła między nimi.
 
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/8744366e-53d1-4418-88cf-5a3a26cc6ad4)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7d81c912-d9f1-4a64-bbb8-ad7971368e55)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/adac1db2-09de-4c5d-8284-86d05e43f0c5)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/49a1db38-5140-4208-872c-4c29ad2750b5)
 
Sprawdziłam połączenie ssh za pomocą `ssh ansible@ansible-target`.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0bff4968-d6e6-42bd-95b6-a1e5733bba87)

Ustaliłam przewidywalne nazwy komputerów za pomocą `nano /etc/hosts` tak, aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b6f2a2c3-28f5-4d69-85f0-04db14f003c2)

Sprawdziłam status usługi `systemd-resolved`, co pozwoliło upewnić się, że procesy rozwiązywania nazw domenowych działają poprawnie.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/ace14a79-cb98-4981-85b8-0a840583be3a)

Stworzyłam plik inwentaryzacji `inventory.yml` służący do zarządzania grupami hostów w konfiguracji Ansible. Umieściłam w nim sekcje `Orchestrators` oraz `Endpoints` wraz z nazwami maszyn wirtualnych w odpowiednich sekcjach.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/f94309db-99ba-4926-93cb-11d1c338223a)

Na `ansible-target` utworzyłam katalog tymczasowy i nadałam mu odpowiednie uprawnienia, aby zapewnić poprawne działanie Ansible.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/50a0e2f2-5711-4f72-95f5-d000e3d02127)

Skonfigurowałam `ansible.cfg` tak aby sekcja [defaults] zawierała właściwą ścieżkę do katalogu tymczasowego.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/0504c35b-79f9-4579-93ae-5735eb93971c)

Wysłałam żądanie ping do wszystkich maszyn. Okazało się, że pominęłam wymianę klucza na głównym hoście z samym sobą, co uniemożliwiło połączenie i uwierzytelnianie hosta wobec samego siebie. W przypadku automatyzacji zadań za pomocą narzędzi takich jak Ansible, wymiana kluczy z samym sobą jest istotna, ponieważ pozwala to na bezproblemowe wykonywanie operacji na hoście przez narzędzia zarządzania konfiguracją.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/38e27866-5287-4c8b-82fd-afa291862e23)

Kolejnym etapem było stworzenie playbooka Ansible, który:
- wysyła żądanie ping do wszystkich maszyn
```
- name: Ping to all machines
  hosts: all
  tasks:
    - name: Send ping to all machines
      ping:
```
- kopiuje plik inwentaryzacji na maszyny Endpoints
```
- name: Copy inventory file to Endpoints
  hosts: Endpoints
  tasks:
    - name: Copy inventory file
      copy:
        src: ~/devops/MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie4/inventory.yml
        dest: /home/ansible/inventory.yml
        force: yes
      become: yes
```
- aktualizuje pakiety w systemie
```
- name: Update system packages
  hosts: all
  tasks:
    - name: Update all packages to the latest version
      apt:
        update_cache: yes
        upgrade: dist
      become: yes
```
- restartuje usługi sshd i rngd
```
- name: Restart services
  hosts: all
  tasks:
    - name: Restart sshd service
      service:
        name: sshd
        state: restarted
      become: yes

    - name: Restart rngd service
      service:
        name: rngd
        state: restarted
      become: yes
```
Podczas prób wykonania `playbook.yml` istotne okazało się przypisanie nazw hostów do adresów IP w plikach `/etc/hosts` obu maszyn.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/188e7309-008d-4667-a964-7158fb38226c)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e11469d4-55fa-4067-a77b-54ccce534772)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/482cc8aa-361b-49af-b30e-d2dcff78fa83)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/1b2dd892-c3f0-487a-933b-cce1764dbda2)

Wykonanie playbooka poskutkowało różnymi komunikatami. Część z nich oznaczona na zielono "ok" oznaczała pomyślne wykonanie kroku. Komunikaty oznaczone na żółto jako "changed" wskazują, że została wprowadzona zmiana w systemie w wyniku wykonania danego kroku, na przykład aktualizacji pakietów lub restartu usługi. Wystąpiły również czerwone komunikaty "failed" wskazujące, że operacja restartu RNGD zakończyła się niepowodzeniem. Jest to oczekiwane zachowanie, ponieważ RNGD nie jest domyślnie instalowany w systemie, dlatego jego restart nie jest możliwy.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6a0e9a8f-ee43-420f-bb34-a9fe56536ad4)

Wynik `playbook.yml` względem maszyny z wyłączonym serwerem SSH.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/6c840dce-9fc5-415e-a8df-6aaec2f67561)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e5ff1206-ddcd-4302-b8dd-cd81c434ebdd)

Wynik `playbook.yml` względem odpiętej karty sieciowej.
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/61b97e29-c0e9-4aa4-9785-8ef53002a34e)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/e9fb072e-ac9a-45fd-937b-38715c813911)

Plik `playbook.yml` umieściłam w folderze `playbook-1`.
Następnie skopiowałam pliki Dockerfile, z których korzystałam na poprzednich laboratoriach do folderu `Sprawozdanie4`

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b2c0c99a-617a-4f95-98c2-6aa7b955eb68)

W celu wdrożenia aplikacji, stworzyłam rolę za pomocą szkieletowania ansible-galaxy. Jest to sposób na szybkie i spójne zorganizowanie kodu i zasobów potrzebnych do wykonywania konkretnego zadania lub funkcji w Ansible.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b0122152-7ce2-4e30-b525-8651350c98e4)

Powstała w wyniku szkieletowania ansible-galaxy struktura katalogów i plików.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/7bc5bc50-3f3f-42f7-a5cc-6f10ab5d2df0)

Na poziomie katalogu `docker-role` utworzyłam plik `site.yml`, który w pierwszej sekcji kopiuje obrazy Builder i Tester z pliku z hosta, na którym jest uruchamiany Ansible (`Orchestrators `) do pozostałych (`Endpoints`). Dzięki tym obrazom możliwe będzie późniejsze uruchomienie kontenera deploy. Druga sekcja playbooka skupia się na punktach końcowych (`Endpoints`), które będą korzystać z roli `docker-role`.
```
- name: Copy Dockerfiles to endpoints
  hosts: Orchestrators
  tasks:
    - name: Copy Dockerfile.build to endpoints
      copy:
        src: "/home/magda/devops/MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie4/Dockerfile.build"
        dest: /home/ansible/Dockerfile.build
      become: yes
      delegate_to: "{{ item }}"
      with_items: "{{ groups['Endpoints'] }}"

    - name: Copy Dockerfile.test to endpoints
      copy:
        src: "/home/magda/devops/MDO2024_INO/ITE/GCL4/MR412777/Sprawozdanie4/Dockerfile.test"
        dest: /home/ansible/Dockerfile.test
      become: yes
      delegate_to: "{{ item }}"
      with_items: "{{ groups['Endpoints'] }}"

- name: Import Docker images and manage containers
  hosts: Endpoints
  become: yes
  roles:
    - docker-role
```
Dokładne kroki roli docker-role zostały zawarte w pliku `docker-role/tasks/main.yml`.
- Sprawdzenie, czy Docker jest zainstalowany na maszynach docelowych.
```
- name: Ensure Docker is installed
  apt:
    name: docker.io
    state: present
  become: yes
```
-	Uruchamienie usługi Docker
```
- name: Start Docker service
  service:
    name: docker
    state: started
    enabled: yes
  become: yes
```
-	Obraz Dockerowy budujący oraz testujący.
```
- name: Build Builder image
  command: docker build -t build_image -f /home/ansible/Dockerfile.build /home/ansible
  become: yes

- name: Build Tester image
  command: docker build -t test_image -f /home/ansible/Dockerfile.test /home/ansible
  become: yes
```
-	Uruchomienie kontenera
```
- name: Run application container
  command: docker run -itd --name app build_image
  register: container
  become: yes
```
-	Czas na pełne uruchomienie
```
- name: Wait for container to start
  pause:
    seconds: 10
```
-	Wykonanie testów
```
- name: Run tests
  command: docker exec app sh -c 'cd maven-simple && mvn test'
  become: yes
```
-	Wykonanie deploy
```
- name: Deploy application
  command: docker exec app sh -c 'cd maven-simple && mvn deploy -DaltDeploymentRepository=myRepo::default::file:/maven-simple/artifact'
  become: yes
```
-	Stworzenie artefaktów
```
- name: Create artifacts directory
  command: mkdir /home/ansible/artifact
  become: yes
```
-	Skopiowanie artefaktów
```
- name: Copy artifacts from container
  command: docker cp app:/maven-simple/artifact /home/ansible/artifact
  become: yes
```
-	Zatrzymanie oraz usunięcie kontenera
```
- name: Stop container
  command: docker stop app
  ignore_errors: yes
  become: yes
- name: Remove container
  command: docker rm app
  ignore_errors: yes
  become: yes
```
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/d20b437c-9b50-488f-baeb-4fcfd4576ffe)

Powstałe obrazy oraz artefakty świadczą o poprawnym działaniu roli.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/18d3ed48-c505-4620-abd1-12face4a96c3)

W kolejnym etapie stworzyłam nową maszynę wirtualną z systemem Fedora 38, stosując instalator sieciowy (netinst). Korzystałam z manualnej konfiguracji.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/c4c1dd75-b346-4e3b-9710-557338b70087)

Po instalacji pobrałam plik odpowiedzi `/root/anaconda-ks.cfg` do głównego katalogu użytkownika.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/4d0672be-0d00-4dde-be20-d3fb565f2475)

Skopiowaną wersję uzupełniłam o fragmenty:
- ` url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64 `
instalator systemu będzie pobierać paczki z serwerów Fedora Project
- ` repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64 `
dodatkowe repozytorium, z którego instalator będzie pobierał aktualizacje
- ` clearpart –all` usunięcie wszystkich istniejących partycji na dysku twardym
- ` network --bootproto=dhcp --device=eth0 --ipv6=auto –activate` konfiguracja sieci dla instalowanego systemu
- ` network --hostname=mrynduch` ustawienie nazwy hosta

Plik skopiowałam do katalogu `Sprawozdanie4` na maszynie głównej i zmianę wypchałam na zdalne repozytorium.
Utworzyłam nową maszynę wirtualną Fedora. Na etapie wyboru ustawień instalacji nacisnęłam `e` w celu edycji wykonywanych poleceń.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/d78818f4-8e53-493a-a4fc-c1e6f27c9396)

Odnalazłam bezpośredni adres URL pliku na GitHubie z wcześniej edytowaną konfiguracją.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/b77df784-1788-4f0c-93ad-960e0368ed13)

Przepisałam znaleziony adres URL pliku do `inst.ks`, który może być używany do zautomatyzowania procesu instalacji systemu operacyjnego.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/3957d7c1-79fd-42ee-833f-4bcdaf062e42)
 
Konfiguracja została ustawiona automatycznie i po jej zakończaniu od razu nastąpiła instalacja systemu.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/9cc6dbe3-0bac-4fc8-9b63-f28251ce81c7)
![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/908f2b73-f8ff-4821-8d94-ea93ff299728)

Po zakończonej instalacji uruchomiłam system ponownie i sprawdziłam czy nazwa hosta odpowiada nazwie określonej w pliku konfiguracyjnym.

![image](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/assets/96431223/fd6d9a44-7857-4be6-be89-0888554dece0)


