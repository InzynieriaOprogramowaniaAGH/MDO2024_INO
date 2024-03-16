Sprawozdanie 1

Host wirualizacji: Hyper-V
Wariant dystrybucji Linux'a: Ubuntu

Laboratorium rozpoczęłam od wygenerowania kluczy SSH za pomocą polecenia ssh-keygen. Po wykonaniu polecenia pojawiła się opcja ustawienia lokalizacji kluczy. Pozostawiłam domyślny katalog ~/.ssh, w kórym następnie pojawiły się dwa pliki. Jeden z kluczem prywatnym (id_rsa) oraz drugi z publicznym (id_rsa.pub). Następnie pojawiła się opcja zabezpieczenia kluczy hasłem, z której nie skorzystałam.



Otrzymane klucze powiązałam z moim kontem na Githubie. Po zalogowaniu na https://github.com/ weszłam w Settings -> SSH and GPG keys -> New SSH key. Ustawiłam typ klucza na Authentication Key oraz wkleiłam wygenerowany wcześniej klucz publiczny (id_rsa.pub). Korzystając z protokołu SSH, można łączyć się ze zdalnymi serwerami i usługami takimi jak np. GitHub bez podawania swojej nazwy użytkownika i osobistego tokena dostępu przy każdej wizycie. Uwierzytelnianie zachodzi przy użyciu pliku klucza prywatnego na maszynie.

Dzięki powiązaniu konta, maszyna wirtualna uzyskała dostęp do GitHuba. Umożliwiło to sklonowanie repozytorium przedmiotu za pomocą komendy: git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024_INO.git. 

Powiązanie GitHuba z maszyną wirtualną za pomocą SSH ma wiele korzyści:

