# Weronika Bednarz, 410023 - Inzynieria Obliczeniowa, GCL1
## Laboratorium 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
### Opis celu i streszczenie projektu:

Automatyzacja konfiguracji systemów poprzez wykorzystanie narzędzia Ansible.
- Umożliwienie zdalnego zarządzania i wykonywania poleceń na wielu maszynach wirtualnych.
- Zautomatyzowane instalowanie oprogramowania, konfigurowanie usług i zarządzanie użytkownikami.
Utworzenie playbooków do inwentaryzacji, zarządzania łącznością i wywoływania procedur na maszynach.
- Stworzenie spójnego środowiska wirtualnych maszyn, w tym konfiguracja nazw, łączności sieciowej i wymiany kluczy SSH.
- Wykorzystanie playbooków do wysyłania poleceń, aktualizowania pakietów, restartowania usług oraz zarządzania kontenerami.

Laboratoria koncentrują się na wykorzystaniu Ansible do automatyzacji konfiguracji i zarządzania maszynami wirtualnymi, umożliwiając zdalne wykonywanie poleceń i procedur. 

## Zrealizowane kroki:
### Pipeline

Poprawiłam pipeline'a z wcześniejszych laboratoriów aby działał prawidłowo:
```bash
pipeline {
    agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('e08d9a39-11d6-4211-b184-d7f62f6bf3e3')
    }
    
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Collect') {
            steps {
                git branch: "main", credentialsId: 'e08d9a39-11d6-4211-b184-d7f62f6bf3e3', url: "https://github.com/weronikaabednarz/spring-petclinic"
                sh 'git config user.email "weronikaabednarz@gmail.com"'
                sh 'git config user.name "weronikaabednarz"'
            }
        }
        
        stage('Clean up') {
            steps {
                echo "Cleaning up wrokspace..."
                sh '''
                docker stop spring-builder || true
                docker rm spring-builder || true
                docker stop spring-tester || true
                docker rm spring-tester || true
                docker stop spring-deploy || true
                docker rm spring-deploy || true
                
                docker image rm -f spring-builder
                docker image rm -f spring-tester
                docker image rm -f spring-deploy
                '''
            }
        }

        stage('Build') {
            steps {
                script {
                    try {
                        sh '''
                        docker build -t spring-builder -f ./dockerfile_builder .
                        docker run --name spring-builder spring-builder
                        docker logs spring-builder > log_build.txt
                        '''
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Błąd w trakcie budowania obrazu Docker: ${e.message}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    try {
                        sh '''
                        docker build -t spring-tester -f ./dockerfile_tester .
                        docker run --name spring-tester spring-tester
                        docker logs spring-tester > log_test.txt
                        '''
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Błąd w trakcie testowania obrazu Docker: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy') {
        steps {
            script {
                try {
                    sh '''
                    docker build -t spring-deploy -f ./dockerfile_deploy .
                    docker run --name spring-deploy spring-deploy
                    '''
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error "Błąd w trakcie deployment: ${e.message}"
                }
            }
        }
    }

        stage('Publish') {
            steps {
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz log_build.txt log_test.txt
                '''
                
               withCredentials([usernamePassword(credentialsId: 'e08d9a39-11d6-4211-b184-d7f62f6bf3e3', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker tag spring-deploy $DOCKER_USERNAME/spring-deploy:latest'
                    sh 'docker push $DOCKER_USERNAME/spring-deploy:latest'
                }
            } 
        }
    }
    post{
        always{
            echo "Archiving artifacts"

            archiveArtifacts artifacts: 'artifact_*.tar.gz', fingerprint: true
        }
    }
}
```
Stworzony plik dockerfile_deploy na githubie:
![12](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/pipeline.jpg)

Zbudowany projekt:
![13](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/pipeline1.jpg)

Workspace projektu:
![14](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/pipeline2.jpg)

DockerHub:
![15](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/pipeline3.jpg)

### Instalacja zarządcy Ansible

#### 1. Utworzyłam i skonfigurowałam drugą maszynę wirtualną **Ubuntu-Ansible** o jak najmniejszym zbiorze zainstalowanego oprogramowania:
- z tym samym systemem operacyjnym, co główna maszyna i utworzyłam w systemie użytkownika ansible i dodałam mu uprawnienia root'a
```bash
su root
cat /etc/sudoers
usermod -aG sudo ansible
exit
```
![1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/1.jpg)

![2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/2.png)

![3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/3.png)

- zapewniłam obecność serwera OpenSSH (sshd)
```bash
sudo ls
sudo apt install openssh-server 
sudo systemctl start sshd
sudo systemctl status
```
![4](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/4.png)

![5](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/5.png)

- zapewniłam obecność programu tar
```bash
sudo apt update
sudo apt install tar
tar --version
```
![6](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/6.png)

- nadałam maszynie hostname ansible-target
```bash
sudo hostnamectl set-hostname ansible-target
hostname
getent passwd ansible
```
![7](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/7.png)

- zrobiłam migawkę maszyny

![8](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/8.png)

#### 2. Zainstalowałam oprogramowanie **Ansible**: https://docs.ansible.com/ansible/latest/index.html na głównej maszynie wirtualnej.
Instalacja **Ansible** na maszynie **Ubuntu**:
```bash
sudo apt update
sudo apt install pipx
sudo pipx ensurepath
sudo apt install ansible
```
![9](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/9.png)

Sprawdziłam wersję zainstalowanego **Ansible**:
```bash
ansible --version
```
![10](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/10.png)

### 3. Dokonałam inwentaryzacji systemów.
- Ustaliłam nazwy obu maszyn stosując *hostnamectl* oraz następnie wyświetliłam nazwę hosta:
```bash
sudo hostnamectl set-hostname weronikaabednarz
hostname
```
Maszyna wirtualna zawierająca **Ansible**:

![11](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/11.png)

Maszyna wirtualna bez **Ansible**:

![16](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/16.png)

- Wprowadziłam nazwy DNS dla maszyn wirtualnych, stosując *systemd-resolved* i */etc/hosts*, tak aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP:

Otworzyłam plik **systemd-resolved:**
```bash
sudo nano /etc/systemd/resolved.conf
```
Maszyna wirtualna zawierająca **Ansible**:

![17](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/17.png)

Maszyna wirtualna bez **Ansible**:

![18](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/18.png)

W sekcji **[Resolve]** odkomentowałam części **DNS** i ustawiłam je na **8.8.8.8**:

Maszyna wirtualna zawierająca **Ansible**:

![19](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/19.png)

Maszyna wirtualna bez **Ansible**:

![20](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/20.png)

Restart usługi systemd-resolved w systemie:
```bash
sudo systemctl restart systemd-resolved
```
Maszyna wirtualna zawierająca **Ansible**:

![21](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/21.png)

Maszyna wirtualna bez **Ansible**:

![22](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/22.png)

- Zweryfikowałam łączność:

Zmieniłam ustawienia sieciowe wirtualnych maszyn z NAT na tryb mostkowy, ponieważ w domyślnym ustawieniu wszystkie maszyny posiadają takie same adresy IP, co uniemożliwia ich połączenie.

Maszyna wirtualna zawierająca **Ansible**:

![23](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/23.png)

Maszyna wirtualna bez **Ansible**:

![24](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/24.png)

Kolejno wyświetliłam adresy IP każdej z maszyn:
```bash
hostname -I
```
Maszyna wirtualna zawierająca **Ansible**:

![25](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/25.png)

Maszyna wirtualna bez **Ansible**:

![26](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/26.jpg)

Otworzyłam plik */etc/hosts* i dodałam w nim adres IP drugiej maszyny wirtualnej:
```bash
sudo nano /etc/hosts
```
Maszyna wirtualna zawierająca **Ansible**:

![27](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/27.png)

![28](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/28.jpg)

Maszyna wirtualna bez **Ansible**:

![29](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/29.png)

![30](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/30.png)

Wysłałam żądanie ping do drugiej maszyny:
```bash
ping <HOSTNAME>
```
Maszyna wirtualna zawierająca **Ansible**:

![31](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/31.png)

Maszyna wirtualna bez **Ansible**:

![32](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/32.png)

Wyświetliłam jednostki związane z usługą **SSH**:
```bash
sudo systemctl list-unit-files | grep ssh
```
i status **ssh**:
```bash
sudo systemctl status ssh
```
Maszyna wirtualna zawierająca **Ansible**:

![33](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/33.png)

Maszyna wirtualna bez **Ansible**:

![34](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/34.png)

Wygenerowałam nowy klucz **RSA** do uwierzytelniania **SSH**:
```bash
ssh-keygen -t rsa -b 4096
```
i wyświetliłam istniejące klucze:
```bash
ls ~/.ssh
```
Maszyna wirtualna zawierająca **Ansible**:

![35](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/35.png)

Maszyna wirtualna bez **Ansible**:

![36](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/36.png)

Wyświetliłam a następnie skopiowałam zawartość klucza publicznego **RSA**:
```bash
cat ~/.ssh/id_rsa.pub
```
Maszyna wirtualna zawierająca **Ansible**:                              Maszyna wirtualna bez **Ansible**:

![37](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/37.png)

Otworzyłam a następnie wkleiłam zawartość klucza RSA do pliku **authorized_keys**:
```bash
nano ~/.ssh/authorized_keys
```
![38](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/38.png)

Maszyna wirtualna zawierająca **Ansible**:

![39](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/39.png)

Maszyna wirtualna bez **Ansible**:

![40](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/40.png)

Stworzyłam plik inwentaryzacji, korzystając z dostępnej dokumnetacji: https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html

```bash
nano inventory.ini
```
![41](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/41.png)

- Umieściłam w pliku *inventory.ini* sekcje **Orcherators** oraz **Endpoints**, a w nich nazwy maszyn wirtualnych:

Zawartość pliku *inventory.ini*:
```bash
[Orcherators]
weronikaabednarz

[Endpoints]
ansible-target ansible_user=ansible
```
![42](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/42.png)

- Wysłałam żądanie **ping** do wszystkich maszyn:
```bash
ansible all -i inventory.ini -m ping
```
![43](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/43.png)

### Zdalne wywoływanie procedur

#### 1. Ponownie wysłałam żądanie **ping** do wszystkich maszyn z sukcesem:
```bash
ansible all -i inventory.ini -m ping
```
![44](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/43.png)

Utworzyłam plik *.yaml* - **playbook.yaml**:
```bash
nano playbook.yaml
```
![45](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/44a.png)

Zawartość pliku **playbook.yaml**:
```bash
- name: Copy inventory file
  hosts: Endpoints
  tasks:
    - name: Copy inventory.ini
      copy:
        src: ./inventory.ini
        dest: ~/
```
![46](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/44.png)

#### 2. Dwukrotnie skopiowałam plik inwentaryzacji na maszynę **Endpoints**:
```bash
ansible-playbook all -i inventory.ini playbook.yaml
```
![47](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/45.png)

![48](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/46.png)

Porównując różnice w wyniku, ponowne skopiowanie operacji nie spowodowało żadnych zmian (changed=0), jak przy pierwszym uruchomieniu (changed=1). 
Stąd wynika, że podczas pierwszego kopiowania plik inwentaryzacji został pomyślnie przetransportowany na drugą maszynę.

#### 3. Przeprowadziłam operację względem maszyny z wyłączonym serwerem SSH:
Zaktualizowałam pakiety w systemie i zrestartrowałam usługę sshd:
```bash
sudo service ssh restart
```
![49](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/47.png)

Na Endpoincie wyłączyłam usługę ssh:
```bash
sudo systemctl stop ssh
```
![50](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/48.png)

Nieudana próba skopiowania pliku inwentaryzacji na drugą maszynę:
```bash
ansible-playbook -i inventory.ini playbook.yaml
```
![51](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/49.png)

#### 4. Przeprowadziłam operację względem maszyny z odpiętą kartą sieciową:

Odpięcie karty sieciowej:
![52](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/51.png)

Ponowne włączenie usługi ssh na Endpoincie i sprawdzenie jej statusu:
```bash
systemctl start sshd
systemctl status ssh
```
![53](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/50.png)

Nieudana próba skopiowania pliku inwentaryzacji na drugą maszynę:
```bash
ansible-playbook -i inventory.ini playbook.yaml
```
![53](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/52.png)

### Zarządzanie kontenerem

Zainstalowałam **Docker** na maszynie wirtualnej, i wyświetliłam jego wersję:
```bash
sudo snap install docker
```
![54](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/55.png)

Stworzyłam drugiego playbooka **playbook2.yaml**, który pobiera z DockerHuba stworzony przeze mnie na poprzednich zajęciach obraz, a następnie uruchamia go:
```bash
nano playbook2.yaml
```
![55](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/53.png)

Zawartość pliku **playbook2.yaml**:
```bash
- name: Pobierz i uruchom obraz Docker
  hosts: Endpoints
  become: no
  tasks:
    - name: Pobierz obraz z DockerHub
      docker_image:
        name: weronikaabednarz/spring-deploy:latest
        source: pull
    
    - name: Uruchom kontener
      docker_container:
        name: spring-deploy
        image: weronikaabednarz/spring-deploy:latest
        state: started
```
![56](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/54.png)

Nieudana próba uruchamienia playbook Ansible'a:
```bash
ansible-playbook -i inventory.ini playbook2.yaml
```
![57](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/56.png)

Niestety po wielokrotnych próbach przeinstalowywania Dockera na drugiej maszynie wirtualnej i edycji pliku **playbook2.yam**, nie udało mi się zidentyfikować problemu i go naprawić tak aby playbook uruchamiał się prawidłowo :((

## Laboratorium 9 - Pliki odpowiedzi dla wdrożeń nienadzorowanych
### Opis celu i streszczenie projektu:

- Utworzenie źródła instalacji nienadzorowanej dla systemu operacyjnego hostującego nasze oprogramowanie.
- Przeprowadzenie instalacji systemu, który po uruchomieniu rozpocznie hostowanie naszego programu.

Laboratoria poświęcone przygotowaniu źródła instalacyjnego systemu dla maszyny wirtualnej/fizycznego serwera/środowiska IoT. Źródła takie stosowane są do zautomatyzowania instalacji środowiska testowego dla oprogramowania, które nie pracuje w całości w kontenerze

## Zrealizowane kroki:

### 1. Zainstalowałałam system **Fedora 38** na *VM* stosując instalator sieciowy (netinst)

Link do pobranego **ISO**: https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-netinst-x86_64-38-1.6.iso

Wgrany obraz **Fedora**:

![58](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/57.png)

Instalacja oraz konfiguracja środowiska **Fedora**:

![59](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/58.png)

Ustawiłam hasło dla **roota**:

![60](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/60.png)

Utworzyłam nowego użytkownika **weronikaabednarz**:

![61](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/59.png)

Ukończyłam instajację:

![62](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/61.png)

Zalogowałam się do systemu wcześniej utworzonym użytkownikiem:

![63](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/62.png)

### 3. Pobrałam plik odpowiedzi */root/anaconda-ks.cfg* i sprawdziłam zawartość katalogu, w którym się aktualnie znajduję.
```bash
sudo cp /root/anaconda-ks.cfg .
ls
```
![64](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/63.png)

### 4. Edytowałam plik odpowiedzi, aby nie zawierał wzmianek na temat potrzebnych repozytoriów.

Otworzyłam plik odpowiedzi:
```bash
sudo nano anaconda-ks.cfg
```
![65](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/64.png)

Zawartość pliku *anaconda-ks.cfg*:

![66](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/65.png)

Do zawartości pliku dodałam nizbędne linijki kodu, wzmianki na temat potrzebnych repozytoriów:
```bash
# Repositories
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
```
![67](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/66.png)

### 5. Zapewniłam aby plik odpowiedzi zawsze formatował całość (ponieważ może zakładać pusty dysk).

Zmodyfikowałam poniższą linijkę kodu w pliku *anaconda-ks.cfg*:
```bash
# Format
clearpart --all
```
![68](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/67.png)

### 6. Rozszerzyłam plik odpowiedzi o repozytoria i oprogramowanie potrzebne do uruchomienia programu, zbudowanego w ramach projektu z pipelinem. W sekcji **%post** utworzyłam mechanizm umożliwiający pobranie i uruchomienie kontenera.

Dodana zawartość pliku:
```bash
%post --erroronfail

cat << 'EOF' > /etc/systemd/system/my-docker.service

usermod -aG docker root
systemctl enable docker

[Unit]
Description=Download docker and run
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/docker pull weronikaabednarz/spring-deploy:latest
ExecStart=/usr/bin/docker run --name spring-deploy weronikaabednarz/spring-deploy

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reloaded
systemctl enable my-docker.service
systemctl start my-docker.service

%end
```
![69](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/68.png)

W tym fragmencie pliku konfiguracyjnego anaconda-ks.cfg znajduje się sekwencja poleceń, które zostaną wykonane po zakończeniu instalacji systemu operacyjnego. Skrypt ten ma za zadanie utworzyć nową usługę systemd o nazwie my-docker.service, dodać użytkownika root do grupy docker, aktywować usługę Docker, zdefiniować parametry nowej usługi systemd, takie jak zależności i sposób uruchamiania, oraz określić komendy do pobrania i uruchomienia kontenera Docker. Po wykonaniu skryptu, konfiguracja daemona systemd zostaje zaktualizowana, a usługa my-docker.service jest aktywowana i uruchamiana.

### 7. Zapoznałam się z dokumentacją pliku odpowiedzi.

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_an_advanced_rhel_9_installation/kickstart-commands-and-options-reference_installing-rhel-as-an-experienced-user

### 8. Zamieściłam plik konfiguracyjny w repozytorium **GitHub**.

Utworzyłam nowe repozytorium o nazwie **anaconda**:

![70](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/69.png)

Utworzyłam nowy plik konfiguracyjny **anaconda-ks.cfg** w repozyorium **anaconda** i wkleiłam do niego powyższą zawartość:

![71](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/70.png)

Repozytorium **anaconda**:

![72](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/71.png)

### 9. Zapewniłam by od razu po pierwszym uruchomieniu systemu, oprogramowanie zostało uruchomione.

W środowisku Git Bash utworzyłam skrypt *bash* do utworzenia nowej maszyny wirtualnej **Fedora**:
```bash
nano create-VM.sh
```
![73](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/72.png)

Sprawdziłam oraz skopiowałam nazwę adaptera mostkowej karty sieciowej, niezbędną do skryptu tworzenia maszyny wirtualnej:

![74](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/73.png)

Zawartość pliku **create-VM.sh**:
```bash
#!/bin/bash

VM_NAME="New-Fedora"
ISO_PATH="C:\Users\weron\Downloads\Fedora-Server-netinst-x86_64-38-1.6.iso"
VBOXMANAGE_PATH="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

"$VBOXMANAGE_PATH" createvm --name "$VM_NAME" --ostype "RedHat_64" --register
"$VBOXMANAGE_PATH" modifyvm "$VM_NAME" --memory 2048 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 "MediaTek Wi-Fi 6 MT7921 Wireless LAN Card"
"$VBOXMANAGE_PATH" createhd --filename "${VM_NAME}.vdi" --size 10000
"$VBOXMANAGE_PATH" storagectl "$VM_NAME" --name "SATA Controller" --add sata
"$VBOXMANAGE_PATH" storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VM_NAME}.vdi"
"$VBOXMANAGE_PATH" storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"
"$VBOXMANAGE_PATH" startvm "$VM_NAME"
```
![75](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/74.png)

Skrypt Bash służy do tworzenia i konfigurowania maszyny wirtualnej w programie Oracle VirtualBox. Początkowo definiuje nazwę maszyny wirtualnej jako New-Fedora oraz ścieżkę do obrazu ISO systemu Fedora. Następnie określa ścieżkę do programu VBoxManage.exe w systemie Windows. Skrypt korzysta z tego programu, aby utworzyć nową maszynę wirtualną, ustawić jej parametry (takie jak pamięć, typ systemu operacyjnego, sposób rozruchu), utworzyć wirtualny dysk twardy dla maszyny, skonfigurować kontroler SATA oraz dołączyć obraz ISO jako urządzenie optyczne. Na końcu skrypt uruchamia nową maszynę wirtualną.

Uruchomiłam skrypt tworzący nową maszynę wirtualną:
```bash
./create-VM.sh
```
![76](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/75.png)

System automatycznie się uruchomił. W poniższej sytuacji należało nacisnąć przycisk **E** w celu skonfigurowania systemu:

![77](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/76.png)

Konfiguracja systemu w następujący sposób:

![78](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/77.png)

Do pobrania pliku z repozytorium GitHub za pomocą skryptów lub wiersza poleceń bezpośrednio z linii poleceń wykorzystałam subdomenę **raw.githubusercontent.com**.

Konfiguracja systemu:

![79](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/77b.png)

![80](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/78.png)

Instalacja systemu **Fedora**:

![81](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/79.png)

Następnie ponownie uruchomiłam maszynę wirtualną, kolejno w sekcji "Troubleshooting -->" wybrałam "Boot first drive":

![82](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/80.png)

A następnie "Fedora Linux (0-rescue...)":

![83](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/81.png)

Efekty pierwszego załadowania **Fedory**:

![84](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/WB410023/INO/GCL1/WB410023/Sprawozdanie4/images/82.png)

Po pierwszym uruchomieniu Fedory, można zauważyć prawidłową instalację systemu oraz pomyślne pobranie kontenera do tego systemu. Jest to potwierdzeniem, że proces instalacji i konfiguracji kontenera zakończył się sukcesem, umożliwiając dalsze korzystanie z systemu przy użyciu przygotowanego środowiska kontenerowego.

### Dodałam sprawozdanie, zrzuty ekranu oraz listing historii poleceń i utworzone pliki.
Wykorzystane polecenia:
```bash
git add .

git commit -m "WB410023 sprawozdanie, screenshoty, listing oraz pliki"

git push origin WB410023
```
### Wystawiłam Pull Request do gałęzi grupowej.