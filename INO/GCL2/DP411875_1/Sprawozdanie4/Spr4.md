# Sprawozdanie 3
Dagmara Pasek
411875

### Cel ćwiczenia:
Celem tego ćwiczenia było 

### Przebieg ćwiczenia 008:
# Instalacja zarządcy Ansible:
Utworzyłam drugą maszynę wirtualną o jak najmniejszym zbiorze zainstalowanego oprogramowania. 
Zastosowałam ten sam system operacyjny, co "główna" maszyna - Fedorę.
![](./screeny/4fedory.png)

Aby zapewnić komunikację między maszynami nadałam typ sieci: Sieć mostkowana - domyślna karta obu maszynom.
![](./screeny/4typsieci.png)

Zapewniłam obecność programu tar i serwera OpenSSH (sshd).

![](./screeny/4ssh.png)


![](./screeny/4tar.png)

Nadałam maszynie hostname ansible-target. 
Zastosowałam do tego polecenie:
```
sudo hostnamectl set-hostname ansible-target
```
![](./screeny/4at.png)

Utworzyłam w systemie użytkownika ansible.

![](./screeny/4user.png)

Na głównej maszynie wirtualnej zainstalowałam oprogramowanie Ansible korzystając z dokumentacji dołączonej w zadaniu. Użyłam polecenia:
```
 sudo dnf install ansible
```

![](./screeny/4av.png)

Wymieniłam klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem ansible z nowej tak, by logowanie ssh ansible@ansible-target nie wymagało podania hasła.

Za pomocą polecenia ping sprawdziłam, czy uda się połączyć ze sobą maszyny. 

![](./screeny/4ping.png)

![](./screeny/4ping2.png)

Udało się. Przeszłam więc do utworzenia klucza ssh na nowej maszynie. Użyłam polecenia:
```
ssh-keygen -t rsa
```

![](./screeny/4klucz.png)

Przekopiowałam treść klucza na zdalny serwer, tak aby nie musieć podawać hasła przy łączeniu. Użyłam polecenia:
```
ssh-copy-id -i ~/.ssh/id_rsa ansible@ansible-target
```

Sprawdziłam łączenie się stosując na początku adres ip nowej maszyny:

![](./screeny/4ip.png)

Udało się. 

# Inwentaryzacja:
Dokonałam inwentaryzacji systemów.
Ustaliłam przewidywalne nazwy komputerów stosując hostnamectl. W poprzednim kroku ustawiłam nazwę hosta dla nowej maszyny, zatem ustaliłam jedynie nazwę dla głownej maszyny. Było to: daga-fedora.

![](./screeny/4nazwa.png)

Wprowadziłam nazwy DNS dla maszyn wirtualnych, stosując /etc/hosts, aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP.
W pliku /etc/hosts dodałam nazwy i adresy ip drugich maszyn.

![](./screeny/4adr.png)

Kolejno sprawdziłam łączenie się stosując polecenie:

```
ssh ansible@ansible-target
```

![](./screeny/4ans.png)

Udało się.

Utworzyłam plik inwentaryzacji playbook1.yaml. Użyłam formatu .yaml. Umieściłam w nim sekcje Orchestrators oraz Endpoints. Umieściłam nazwy maszyn wirtualnych w odpowiednich sekcjach.
```
orchestrators:
  hosts:
    main_host:
      ansible_host: daga-fedora
endpoints:
    hosts:
	target_host:
            ansible_host: ansible-target
            ansible_user: ansible

network:
  children:
    orchestrators:
    endpoints:
```
W sekcji orchestrators zawarłam nazwę głównej maszyny: daga-fedora. W sekcji endpoints zawarłam nazwę hosta, którym będzie zarządzać main_host. Logowanie będzie się odbywać za pomocą użytkownika ansible. W sekcji networks zdefiniowałam relacje między grupami hostów. Łączone zostały obie powyższe sekcje. 

Wysłałam żądanie ping do wszystkich maszyn. Zastosowałam do tego polecenie:
```
ansible -i inventory.yaml network -m ping
```
Opcja -m określała, że ma być użyty moduł ping. 
Opcja -i określała, że ma być użyty plik inwentaryzacyjny inventory.yaml. 

![](./screeny/4inv.png)

Zapewniłam łączność między maszynami powyżej, więc nie musiałam tego ponawiać. 

# Zdalne wykonywanie procedur

Utworzyłam playbook Ansible o nazwie: playbook1.yaml, za pomocą którego wysłałam żądanie ping do wszystkich maszyn.
Kolejno skopiowałam plik inwentaryzacji na maszynę endpoints. 
```
- name: Copy
  hosts: endpoints
  tasks:
    - name: Copy inventory file
      copy:
	src: /home/parallels/ansible_1/inventory.yaml
        dest: /home/ansible/ansible_1/inventory.yaml

```
![](./screeny/4cp.png)
Za pierwszym razem zwrócony został status CHANGED. Oznaczało to, że wprowadzone zostały zmiany - kopiowanie pliku.

Ponów operację, porównaj różnice w wyjściu. 
Za drugim razem zwrócony został status OK, ponieważ plik był juz skopiowany. Nie została wyświetlona informacja o zmianach, więc plik z przekopiowaną wcześniej zawartością był widziany przez ansible.

![](./screeny/4cp2.png)

Zaktualizuj pakiety w systemie w następujący sposób:

```
- name: Packets update
  hosts: endpoints
  become: true
  tasks:
    - name: Update all packages to the latest version
      package:
	name: "*"
        state: latest
```

Zrestartuj usługi sshd i rngd
Przeprowadź operacje względem maszyny z wyłączonym serwerem SSH, odpiętą kartą sieciową
