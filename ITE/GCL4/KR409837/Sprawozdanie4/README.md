# Sprawozdanie 4 - Konrad Rezler
## Zajęcia 08
## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
### Instalacja zarządcy Ansible
Na moim urządzeniu utworzyłem przy pomocy VM Boxa drugą maszynę wirtualną, wykorzystując przy tym ten sam system operacyjny, co na mojej głownej maszynie: `Ubuntu`. 
Tworząc maszynę zapewniłem, aby `ansible-target` było nazwą hosta, a `ansible` było nazwą użytkownika. 
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/2. Utwórz drugą maszynę wirtualną o jak najmniejszym zbiorze zainstalowanego oprogramowania.png">
</p>
Na mojej głównej maszynie zainstalowałem zainstalowałem Ansible:
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

Moim pierwszym krokiem było utworzenie nowego pliku o rozszerzonu `.yaml`:
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/29. utworzyłem nowy plik.png">
</p>

oraz na nowej maszynie zainstalowałem docker (łącząc się z nią za pomocą komendy `ssh ansible@ansible-target`):
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/30. zainstalowałem docker na nowej maszynie łącząc się przez ssh.png">
</p>
