
Nadanie hostname 'ansible-target'


Wymiana kluczy ssh, umożliwiająca łączenie się bez podawania hasła

![alt text](image.png)

Wymiana udana - nie trzeba hasła

![alt text](image-1.png)

Upewnienie się, że program tar jest zainstalowany

![alt text](image-2.png)

Dodanie do `etc/hosts` ansible-target, żeby umożliwić połączenie się za pomocą hostname, zamiast adresu ip.

![alt text](image-3.png)

Połączenie działa 

### Inwentaryzacja

![alt text](image-4.png)

Problem z pingowaniem siebie: nie było klucza w authorized keys. Po jego dodaniu działa

![alt text](image-5.png)

Udany ping

![alt text](image-6.png)

### Playbook Ansible

**ping.yml**

![alt text](image-7.png)

**copy_inventory.yml**

Pierwsze uruchomienie

![alt text](image-8.png)

Drugie uruchomienie

![alt text](image-9.png)

Sprawdzenie istnienia pliku na drugiej maszynie wirtualnej

![alt text](image-10.png)

**update.yml**

wymagane sudo
![alt text](image-11.png)

Sprawdzenie pakietów przed update

![alt text](image-12.png)

Po odpaleniu update.yml

![alt text](image-15.png)

![alt text](image-13.png)

**restart.yml**
![alt text](image-16.png)

Nie ma rngd, trzeba zainstalować

![alt text](image-17.png)

Start usługi oraz sprawdzenie czy jest aktywna

![alt text](image-18.png)

Udany restart usług

![alt text](image-19.png)

Widać, że usługa rng została zrestartowana, ponieważ czas działania jest od momentu wywołania playbook'a restart. Pozwala nam to na weryfikację działania playbooka. 

![alt text](image-20.png)

**Odpięcie karty sieciowej oraz wyłączenie usługi SSH**

Odpięcie karty sieciowej wykonane zostało za pomocą ustawień VirtualBox'a. 
![alt text](image-14.png)

Wyłączenie SSH oraz sprawdzenie statusu.
![alt text](image-21.png)

Próba przekopiowania inventory.ini do maszyny wirtualnej.

![alt text](image-22.png)

Maszyna wirtualna nie może odnaleźć w sieci target'a, więc program Ansible nie jest w stanie przesłać pliku. 

Po zrestartowaniu maszyny i ustawieniu bridged adapter, wszystko dziąła jak powinno

![alt text](image-23.png)

**Konteneryzacja za pomocą Ansible**

W celu pobrania obrazu, który był umieszczony na DockerHub na poprzednich zajęciach należy zainstalować program Docker na maszynie docelowej.

![alt text](image-24.png)

Sprawdzenie, czy Docker prawidłowo może pobrać obraz testowy hello-world

![alt text](image-25.png)

Należało napisać playbook do pobrania obrazu oraz uruchomienie kontenera z nim. 


Sprawdzenie poprawnego pobrania z playbooka oraz uruchomienia kontenera

![alt text](image-26.png)

Tworzymy rolę w ansible-galaxy *utt-deployer*

![alt text](image-27.png)

W nowo utworzonym katalogu tasks uzupełniamy plik main.yml o instrukcje podobne do wcześniej napisanego playbooka

![alt text](image-28.png)

Wersję możemy ustawić wewnątrz defaults/main.yml

![alt text](image-29.png)

Należy teraz napisać playbook, który wykorzystuje rolę 

![alt text](image-30.png)

Po jego uruchomieniu otrzymałem błąd:

![alt text](image-31.png)

Sugeruje on, że docker nie ma uprawnień na systemie docelowym, więc należy użyć become. W tym celu należy uzupełnić main.yml w /tasks oraz w playbook'u role.yml, który korzysta z zadań w utt-deployer. 

Wskutek tych zmian otrzymujemy taką informację

![alt text](image-32.png)

Oznacza, że obraz nie został znowu pobrany, tylko skorzystał z gotowego (wcześniej pobranego obrazu) i jedyną zmianą było ponowne uruchomienie kontenera z obrazu. 

## Instalacje nienadzorowane

Początkowo należało zainstalować nowy obraz maszyny wirtualnej o systemie operacyjnym Fedora 39. Wybrano tę wersję Fedory, ponieważ jest stabilniejsza i wersja 40 jest świeża, co oznacza, że może występować wiele błędów. 

e w GRUB i dodanie linku do wstawionego na GitHubie pliku

![alt text](image-33.png)