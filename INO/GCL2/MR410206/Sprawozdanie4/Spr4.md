# Sprawozdanie 4
Maciej Radecki 410206
## Instalacja nowej maszyny i jej konfiguracja
Pierwszym krokiem jakie należało wykonać na podanych laboratoriach było utworzenie nowej maszyny "ansible-target" z użytkownikiem "ansible". Maszyna miała być jak najmniejsza oraz tego samego typu co głowna. Tak więc została ona utworzona podonbnie do poprzedniej

![](../Screeny/4.1.1.1.png)

Sprawdziłem również czy hostname oraz podany użtkownik istnieje. Okazało się, że przy okazji aby być pewnym co do użytkownika, powstało ich aż trzech.

![](../Screeny/4.1.1.2.png)

Następnie zapewniono obecność tar

![](../Screeny/4.1.1.3.png)

Następnie zgodnie z odpowiednią dokumentacją na maszynie głównej został zainstalowant Ansible
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

![](../Screeny/4.1.1.4.png)
![](../Screeny/4.1.1.5.png)
![](../Screeny/4.1.1.6.png)

Instalacja powiodła się 

![](../Screeny/4.1.1.7.png)

W celu prawidłowej komunikacji pomiędzy maszynami dodałem do każdej maszyny nową kartę sieciową tak jak na zdjęciu poniżej"

![](../Screeny/4.1.1.8.png)

Następnie na obu maszynach użułem polecenia 
```
sudo dhclient -1 enp0s8
```
Które powoduje dynamiczną konfigurację protokołu IP dla interfejsu sieciowego o nazwie "enp0s8". Następnie przystąpiłem do generowania nowego klucza na nowej maszynie i przekazania go do maszyny głównej, oraz póżniej odwrotnie. Użyto poniższego polecenia.
```
ssh-keygen -t rsa
```
Czyli najpierw do wygenerowania klucza.

![](../Screeny/4.1.1.9.png)

A następnie polecenia:
```
ssh-copy-id -i ~/.ssh/id_rsa <nazwa uzytkownika>@<konkretne IP>
```
Do skopiowania klucza do konkretnej maszyny wirtualnej. Następnie sprawdziłem połączenie czy aby na pewno nie wymaga podawania hasła.

![](../Screeny/4.1.1.10.png)
![](../Screeny/4.1.1.11.png)

## Inwentaryzacja
W celu przeprowadznia inwentaryzacji w pierwszym kroku potrzebowałem pozać nazwę główej maszyny. 

![](../Screeny/4.1.2.1.png)

Jest to "radecki". Aby nie trzeba było wprowadzać adresów IP podanych maszyn dodano ich IP z nazwami do /etc/hosts.

![](../Screeny/4.1.2.2.png)

Następnie sprawdziłem łączenie przy pomocy poniższej komendy:
```
ssh ansible@ansible-target
```
Powiodło się:

![](../Screeny/4.1.2.3.png)

Następnie utworzono plik inwentaryzacji ibook.ini. Jego treść wyglądała następująco:

![](../Screeny/4.1.2.4.png)

W miejscu "orchestrators" umieszczona została nazwa głowej maszyny "radecki", natomiast w "endpoints" został umieszczona nazwa "ansibole-target" oraz "ansible_user=ansible" Następnie użyto poniższego polecenia:
```
ansible-inventory -i inventory.ini --list
```
Następnie wykonane komende pingu:

![](../Screeny/4.1.2.5.png)

Oraz na koniec komende pingu dla wszystkich

![](../Screeny/4.1.2.6.png)

## Zdalne wykonanie procedur 
Stworzono pleybooka Ansible o nazwie playbook1.yaml, jego treść znajduje się poniżej:

![](../Screeny/4.1.3.1.png)

Następnie przy pomocy poniższego polecenia wykonano polecenia wysłania żądania "ping" od wszystkich maszyn.
```
ansible-playbook -i ibook.ini playbook.yaml
```

![](../Screeny/4.1.3.2.png)

Następnie przeszedłem do wykonania polecenia związanego z skopiowaniem pliku inwentaruzacji na maszynę "Endpoints". nowy Playbook wyglądął następująco:

![](../Screeny/4.1.3.3.png)

Po uruchomieniu go przy pomocy poniższego polecenia otrzymaliśmy poniższe logi:

![](../Screeny/4.1.3.4.png)

Nastepnym pokleceniem było zaktualizowanie pakietu w systemie, co zostało wykonane przy pomocy poniższego playbooka:

![](../Screeny/4.1.3.5.png)

Po uruchomieniu otrzymaliśmy poniższe logi:

![](../Screeny/4.1.3.6.png)

Następnie wykonano polecenie dotyczące zrestartowania usługi "sshd" oraz "rngd". Należało upewnić się czy serwisy są zainstalowane na naszym hoście. A nastęnie utworzono playbook4.yaml:

![](../Screeny/4.1.3.7.png)

Po uruchomieniu otrzymaliśmy poniższe logi:

![](../Screeny/4.1.3.8.png)

Kolejne zadanie dotyczyło przeprowadzenia operacji względem maszyny z wyłączonym SSH. Pierwszym krokiem było zatrzymanie serwera ssh na hoście ansible-target.

![](../Screeny/4.1.3.9.png)

Po uruchomieniu playbooka1 otrzymano następujące logi:

![](../Screeny/4.1.3.10.png)

Następnie odłączono kartę sieciową w ustawieniach virtualboxa i otrzymano poniższe wyniki.

![](../Screeny/4.1.3.11.png)
![](../Screeny/4.1.3.12.png)

## Zarządzanie kontenerem
Kolejnym zadanie było uruchomienie aplikacji dostarczanej kontenerem Deploy/Publish, oraz podłączneie storage oraz wyporwadzenie portu. Pobierany obraz to obraz z poprzednich labolatoriów z DockerHub. Należało napisać kolejny playbook, który prezentował się następująco:

![](../Screeny/4.1.4.1.png)

Po uruchomieniu otrzymano następujące logi:

![](../Screeny/4.1.4.2.png)

Następnie na serwerze ansible dokonano sprawdzenia:

![](../Screeny/4.1.4.3.png)

Następne polecenie polegało na zatrzymaniu u usunięciu kontenera. Ponownie utworzono kolejny playbook:

![](../Screeny/4.1.4.4.png)

Po uruchomieniu otrzymano logi:

![](../Screeny/4.1.4.5.png)

Ostatnim poleceniem z bieżącej instrukcji było ubranie powyższych kroków w rolę, za pomocą szkieletowania "ansible-galaxy". Po zorganizowaniu wcześniejszych zadań jako role, unikniemy powtarzania tych samych zadań w różnych playbookach. Zamiast tego, będziemy korzystać z ról do zarządzania instalacją i deploymentem aplikacji na hostach. Zaczynamy od utworzenia szkieletu roli:

![](../Screeny/4.1.4.6.png)

Otrzymaliśmy poniższą struktóre plików:

![](../Screeny/4.1.4.7.png)

Następnie aktualozwana zostało "tasks/main.yml"

![](../Screeny/4.1.4.8.png)

Następnie aktualizowane zostaje "defaults/main.yml"

![](../Screeny/4.1.4.9.png)

Kolejnym krokiem jest wykonanie prostego playbooka z wykorzystaniem roli.

![](../Screeny/4.1.4.10.png)

Po uruchomieniu:

![](../Screeny/4.1.4.11.png)

## Instalacja systemu Fedora
Celem drugiej części laboratoriów była była instalacja systemu operacyjnego Fedora za pomocą instalatora sieciowego (netinst) w trybie nienadzorowanym, a następnie konfiguracja systemu poprzez plik odpowiedzi.  Zadanie rozpoczeto od istalacji oprogramowanie przy pomocy VirtualBoxa.

![](../Screeny/4.1.5.1.png)

Podczas instalacji w wersji graficznej wybrano mininmalną werjsę.

![](../Screeny/4.1.5.2.png)


Następnie należało skopiować pliki odpowiedzi z katalogu root do katalogu nad nim, tak aby było możliwe edytowanie. Do pliku zostały dodana lokalizacja serwerów lustrzanych z repozytorium fedory i aktualizacja, które pozwolą na niezależną instalacje.

```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-39&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f39&arch=x86_64
```

Oraz zgodnie z instrukcją upenwiono się że plik zawsze będzie formatowac całość, używając komendy:
```
clearpart --all
```
Kolejnym krokiem było utworzneie skecji %packages oraz %post, tak jak poniżej:

![](../Screeny/4.1.5.3.png)

Sekcja %packages określa pakiety, które mają zostać zainstalowane. Instalujemy minimalne środowisko, narzędzia do zarządzania kontenerami oraz środowisko serwera.

![](../Screeny/4.1.5.4.png)

Sekcja %post zawiera polecenia, które zostaną wykonane po zainstalowaniu pakietów, ale przed zakończeniem instalacji systemu. Dodaje użytkownika root do grupy docker.
Włączam usługę docker. Tworzę nową usługę systemową docker-java-deploy.service, która pobiera obraz kontenera radeckimaciej/deploy:1.1.1 i uruchamia go na porcie 8080. Uruchamiamy usługę docker-java-deploy.service.
Cały plik anaconda-ks.cfg wyglądał następująco:

![](../Screeny/4.1.5.55.png)

Następnie plik ten został umieszczony na githubie. Uruchomiono instalator w visualBox i za pomocą `e` zaraz po odpaleniu wpisano odpowiednią linikę, w okienku które się pojawiło:
```
inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/MR410206/INO/GCL2/MR410206/Sprawozdanie4/anaconda-ks.cfg
```
Po uruchomieniu instalatora otrzymano następujące logi:

![](../Screeny/4.1.5.5.png)
![](../Screeny/4.1.5.6.png)
![](../Screeny/4.1.5.7.png)

Niestety nie udało się prawidłowo zalogować.

![](../Screeny/4.1.5.8.png)
