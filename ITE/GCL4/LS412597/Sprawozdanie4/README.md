# Sprawozdanie 04 - ANSIBLE

---

## Sawina Łukasz - LS412597

### Przygotowanie maszyn

Do wykonania zadania zdalnego wykorzystnia poleceń Ansible potrzebna nam jest dodatkowa maszyna, w moim przypadku jest to kolejna wirtualna maszyna z systemem Fedora v38 (identyczna jak główna wirtualna maszyna). Przy instalacji systemu tworzymy dodatkowo użytkownika "ansible", który bedzie nam potrzebny w późniejszej części zadania.

![Użytkownik ansible](Images/1.png)

Dodatkowo musimy zapewnić obecność narzędzi `tar` oraz `sshd`, aby sprawdzić czy system posiada owe narzędzia można wykorzystać polecenie:

```bash
tar --help
```

oraz

```bash
sshd --help
```

TAR
![tar](Images/2.png)
SSHD
![sshd](Images/3.png)

W sytuacji, gdy któregoś z programu brakuje wystarczy go doinstalować:

```bash
sudo dnf install tar

sudo dnf install openssh-server
```

Nazwę maszyny możemy określić podczas instalacji, lub już po zmieniając jej nazwę w pliku `/etc/hostname`.

Na naszej głównej maszynie potrzebujemy zainstalować Ansible, do tego wykorzystujemy polecenie:

```bash
sudo dnf install ansible
```

Jak widać na mojej maszynie już jest zainstalowany program:
![ansible](Images/4.png)

Następnie potrzebujemy wygenerować klucz ssh i wymienić go z drugą maszyną, tak aby można było się z nią połączyć bez podawania hasła. W tym celu generujemy sobie nowy klucz i przesyłamy go na użytkownika na drugiej maszynie:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/[key-name]
ssh-copy-id -i ~/.ssh/[keyname].pub [username]@[hostname]
```

Jak widać połączenie się przez ssh z drugą maszyną zostało wykonane bez pytania o hasło, co oznacza, że pomyślnie zadziałały powyższe polecenia (nazwa hosta zamiast adresu IP będzie wytłumaczona poniżej)

![ssh](Images/5.png)

Aby nie musieć podawać adresu IP przy łaczeniu się z maszyną możemy na głównej maszynie edytować plik `/etc/hosts` i dopisać do niego naszą maszynę "ansible-target", dzięki czemu nie musimy znać cały czas jej adresu IP:

![/etc/hosts](Images/6.png)

Jak widać w ostatniej linii mamy dopisany adres oraz nazwę dodatkowej maszyny, co pozwala nam używać nazwy maszyny zamiast adresu IP, można to było zobaczyć powyżej przy połączeniu przez SSH.

### Inwentaryzacja

Do korzystania z Ansible potzrebujemy utworzyć plik `inventory.ini`, w którym określimy hosty z jakimi będziemy pracować:

```ini
[Endpoints]
ansible-target

[Orchestrators]
127.0.0.1
fedora
```

Jak widać w sekcji Endpoints mamy nazwę maszyny dodatkowej, to na niej będą wykonywane wszystkie operacje jakie określimy w Ansible, w Orchestrators mamy naszą maszynę podaną na 2 sposoby, przez jej adres loopback oraz nazwę maszyny.

Dla przetestowania możemy wykorzystać plik inwentaryzacji i wysłać na wszystkie hosty w Enpoints ping:

```bash
ansible Endpoints --module-name ping --inventory ./inventory.ini -u ansible
```

> Ważne aby znajdować się w lokalizacji gdzie jest plik inventory.ini lub podać odpowiednią ścieżkę do niego!

> Na końcu polecenia występuje "-u ansible" ponieważ domyślnie ansible będzie próbowało się połączyć z użytkownikiem o identycznej nazwie jak ten z którego uruchamiamy polecenie

![ansible ping](Images/7.png)

Jak widać nasz ansible oraz inventory działa prawidłowo!

### Playbook

Do wykonania większej ilosci zadań możemy wykorzystać playbooki, w których określamy co ma się wykonać na maszynach docelowych. W pierwszej kolejności będziemy chcieli wykonać następujące czynności:

- Wysłać żądanie PING
- Skopiować plik inventaryzacji na maszynę Enpoints
- Zaktualizować pakiety systemu
- Zrestartować usługę SSHD

W tym celu tworzymy plik `playbook.yml`

```yml
- name: My playbook
  hosts: Endpoints
  remote_user: ansible
  become: yes

  tasks:
    - name: Ping my hosts
      ansible.builtin.ping:

    - name: Copy file with owner and permissions
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini
        owner: ansible
        group: ansible
        mode: u=rw,g=r,o=r

    - name: Upgrade all packages
      ansible.builtin.dnf:
        name: "*"
        state: latest

    - name: Zrestartuj usługę SSH
      ansible.builtin.service:
        name: sshd
        state: restarted
```

Jak widać na początku podajemy nazwę naszego playbooku, hosty na których ma sie wszystko wykonać (są to hosty określone w inventory) oraz użytkownika na którym ma się to wykonać. Dodatkowo określamy, aby wszystko było wykonywane z poziomu sudo, przy pomocy `become: yes`.

Następnie mamy określone taski, ansible udostępnia moduły, które pomogą nam wykonać wszystkie te czynności, przykładowo do wysłania żądania PING wykorzystujemy `ansible.builtin.ping`, do skopiowania pliku: `ansible.builtin.copy` itd.

Przy kopiowaniu pliku musimy określić źródło, miejsce docelowe, właściciela pliku, grupę do której ma należeć oraz uprawnienia.

Do aktualizacji pakietów systemu wykorzystujemy `ansible.builtin.dnf`, który pobierze nam latest paczki.

Do zrestartowania usługi SSHD wykorzystujemy `ansible.builtin.service` na którym podajemy nazwę usługi, czynność jaką ma wykonać (state) oraz ponownie ma to zrobić z poziomu sudo.

Pora przetestować nasz playbook, wykonujemy to poleceniem:

```bash
ansible-playbook ./playbook.yaml --inventory ./inventory.ini
```

![playbook](Images/8.png)

Jak widać wykonało się pięć tasków, w podsumowaniu widzimy, że OK pojawiło się dla 5 z nich oraz changed dla 2, teraz gdy wykonamy ponownie to samo otrzymamy pewną różnicę w wyniku:

![playbook](Images/9.png)

Jak widać tym razem tylko 1 zadanie ma status changed, różnica pojawia się w zadaniu ze skopiowanie pliku, jest to spowodowane tym, że ansible już wykonał wcześniej to zadanie i nie powtarza go ponownie, nic nie zostało zmienione w tym przypadku, podobnie jest dla aktualizacji paczek, wcześniej testowo wykonałem playbooka, dlatego teraz otrzymuję przy nim OK.

Teraz sprawdzmy co się stanie, gdy na docelowej maszynie wyłączymy SSH (odłączymy kartę sieciową).

![playbook](Images/10.png)

Jak widać otrzymaliśmy błąd w którym mamy powiedziane, że pojawił się problem przy połączeniu przez SSH, połączenie z hostem ansible-target na porcie 22 nie zostało wykonane. Można się było domyślić takiego obrotu spraw, ponieważ ansible wykorzystuje ssh do łączenia się z maszynami.
