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
Następnie zapewniłem na nowej maszynie obecność programu `tar` i serwera OpenSSH `sshd`
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/3.1. zapewnij obecnosc tar.png">
</p>
<p align="center">
 <img src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/blob/KR409837/ITE/GCL4/KR409837/Sprawozdanie4/Sprawozdanie8-png/3.2. zapewnij obecnosc openssh.png">
</p>
