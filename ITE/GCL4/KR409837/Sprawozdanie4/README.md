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

