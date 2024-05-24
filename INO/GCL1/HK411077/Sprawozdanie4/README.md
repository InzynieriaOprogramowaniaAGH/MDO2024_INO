# Sprawozdanie 4 - Hubert Kopczyński 411077

## Wstęp - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible, Pliki odpowiedzi dla wdrożeń nienadzorowanych



### Instalacja zarządcy Ansible

W ramach tych zajęć laboratoryjnych pierwszą do wykonania rzeczą było zainstalowanie zarządcy Ansible. W tym celu należało utworzyć nową maszynę wirtualną z takim samym system operacyjnym co maszyna główna i o jak najmniejszym zbiorzee zainstalowanego oprogramowania. W moim przypadku systemem operacyjnym był system **Ubuntu 22.04**. Podczas instalacji systemu wybrałem więc opcję *Ubuntu Server (minimized)*, która zapewnia, że zainstalowany system nie będzie miał zbędnych w tym wypadku dla nas pakietów:

![ubuntu minimalized](images/ubuntu_minimalized.png)

Kolejną opcją którą również wybrałem podczas instalacji było zainstalowanie serwera SSH by nie musieć tego robić później:

![instalacja ssh](images/instalacja_ssh.png)

Po zakończonej instalacji i zalogowaniu się na utworzone konto, które utworzyłem również podczas instalacji nadając nazwę użytkownika **ansible** i hostname **ansible-target**, sprawdziłem czy na maszynie zainstalowany jest program *tar* i *openSSH* poleceniami:

```
tar --version
ssh -V
```

Rezultat był następujący:

![tar openssh](images/tar_ssh.png)

Oba te programy były zainstalowane więc przeszedłem do zrobieenia migawki maszyny:

![migawka nowej maszyny](images/migawka.png)

W tym momencie przeszedłem na swoją główną maszynę wirtualną na której należało zainstalować oprogramowanie Ansible. W tym celu najpierw zaktualizowałem pakiety i system poleceniami:

```
sudo apt update
sudo apt upgrade
```

A następnie zgodnie z instrukcją instalacji w dokumentacji Ansible dla mojego systemu operacyjnego zainstalowałem pakiet *software-properties-common* poleceniem:

```
sudo apt install software-properties-common
```

Kolejną rzeczą w ramach instalacji było dodanie repozytorium *ppa:ansible/absible* poleceniem:

```
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

Ostatnią rzeczą było już po prostu zainstalowanie programu *Ansible*:

```
sudo apt install ansible
```

Sprawdziłem jeszcze wersję zainstalowanego Ansible po to, żeby w ogóle być pewnym że się zainstalował poleceniem:

```
ansible --version
```

Polecenie zwróciło mi:

![wersja ansible](images/ansible_version.png)

Co potwierdziło, że program zainstalował się prawidłowo.

Ostatnim krokiem w ramach instalacji była wymiana kluczy SSH między użytkownikiem na głównej maszynie wirtualnej, a użytkownikiem *ansible* z nowej maszyny tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła. Domyślnie obie moje maszyny używały sieci NAT i miały ten sam adres IP więc łączność pomiędzy nimi była niemożliwa. Żeby umożliwić im łączność musiałem wyłączyłem obie swoje maszyny wirtualne i w górnym pasku menu VirtualBox'a przeszedłem kolejno *Plik -> Narzędzia -> Network Manager*:

![przejście do ustawień sieci](images/network_manager.png)

Gdy tam kliknąłem pojawiły się ustawienia sieci w których przeszedłem do zakładki *NAT Networks* i w niej utwórzyłem nową sieć z domyślnymi ustawieniami o nazwie *MyNetwork*:

![sieć nat](images/NAT_network.png)

W ustawieniach obu maszyn wirtalnych przeszedłem do zakładki *Sieć* i tam zamieniłem opcję *Podłączona do: NAT* na opcję *Podłączona do: Sieć NAT* i wybrałem nazwę utworzonej chwilę wcześniej sieci *MyNetwork*:

![ustawienia sieć](images/ustawienia_siec.png)

Żeby tak jak wcześniej móc korzystać z głównej maszyny wirtualnej za pomocą SSH w Visual Studio Code musiałem przekierować port maszyny głównej. W tym celu przeszedłem znowu tak jak wcześniej do *Network Manager* i tam na dole okna wybrałem zakładkę *Przekierowanie portów*. W odpalonej głównej maszynie wirtualnej sprawdziłem jaki adres ma za pomocą polecenia `ifconfig`:

![adres głównej maszyny](images/adres_glownej.png)

Port dla połączeń SSH sprawdziłem natomiast w pliku pod ścieżką */etc/ssh/sshd_config*:

![port](images/port.png)

Teraz już tylko przepisałem to przy przekierowaniu portów i maszyna z powrotem działała mi po ssh (przekierowałem również port związany z Jenkinsem, żeby on również mógł działać mimo zmiany sieci):

![przekierowanie portów](images/przekierowanie_portow.png)

Gdy wszystko już działało sprawdziłem w ten sam sposób, czyli za pomocą polecenia `ifconfig` adres nowej maszyny wirtualnej i dowiedziałem się że jest to adres *10.0.2.5*:

![adres nowej maszyny](images/nowa_ip.png)

Na głównej maszynie wirtualnej spróbowałem się połączyć z nową maszyną poleceniem `ssh ansible@10.0.2.5* co zakończyło się pomyślnie:

![ssh ansible@10.0.2.5](images/ssh_ansible.png)

Nie chciałem jednak łączyć się poprzez użycie adresu tylko poprzez użycie hostname'a więc do głównej maszyny musiałem dodać przekierowanie. Otworzyłem na głównej maszynie plik *etc/hosts* z uprawnieniami administratora czyli przy użyciu polecenia `sudo` i dopisałem w nim linijkę:

```
10.0.2.5 ansible-target
```

Plik zapisałem i spróbowałem teraz połączyć się po ssh używając polecenia `ssh ansible@ansible-target` co zakończyło się sukcesem:

![ssh ansible@ansible-target](images/ssh_ansible_target.png)

Komunikacja działała już poprawnie więc teraz musiałem wymienić pomiędzy maszynami klucze SSH. Wystarczyło jedynie przekopiować klucz publiczny z maszyny *ansible-target* na maszynę główną używając w niej (głównej maszynie) polecenia:

```
ssh-copy-id ansible@ansible-target
```

I w tym momencie mogłem wreszcie logować się z głównej maszyny na nową bez użycia hasła używając jedynie `ssh ansible@ansible-target`:

![ssh bez użycia hasła](images/bez_hasla.png)

### Inwentaryzacja

