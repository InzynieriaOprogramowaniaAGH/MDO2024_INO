# Zajęcia 03 - Jenkins pipeline

---

## Sawina Łukasz - LS412597

### Wybrana aplikacja

Jako aplikację dla której zostanie przygotowany pipeline wybrałem aplikację napisaną w Node.js. Jest to aplikacja 'TakeNote', która pozwala użytkownikowi na tworzenei notatek.

![Aplikacja](Images/1.png)

Repozytorium posiada licenję MIT, która bez problemu pozwoli nam na pracowanie z tym programem, ponieważ jest to popularna licencja open-source.
Celowo wybrałem tą aplikację, ponieważ jest to bardziej rozbudowana licencja posiadająca całkiem sporo zależności oraz większą ilość testów.

### Dockerfile

W pierwszej kolejności chcemy przygotować sobie nasze podstawowe pliki dockerfile, które będą odpowiedzialne za: budowanie, testowanie oraz deploy.

#### Budowanie

Kod aplikacji został napisany kilka lat temu, dlatego do zbudowania wymagana jest odpowiednia wersja node.js, w tym przypadku v12.

Aby zbudować nasz obraz z aplikacją tworzymy następujący dockerfile:

```Dockerfile
FROM node:12-alpine

RUN apk update && \
    apk add --no-cache git && \
    git clone https://github.com/taniarascia/takenote.git  && \
    apk del git
WORKDIR /takenote
# Make sure dependencies exist for Webpack loaders
RUN apk add --no-cache \
    autoconf \
    automake \
    bash \
    g++ \
    libc6-compat \
    libjpeg-turbo-dev \
    libpng-dev \
    make \
    nasm
RUN npm install
```

Jak widać obraz tworzymy na podstawie node:12-alpine, jest to celowo wybrana wersja odchudzonego node, ponieważ chcemy aby nasz obraz był jak najmniejszy objętościowo oraz nie zawierał niepotrzebnych dodatków.
Ponieważ nasz kod musimy pobrać z repozytorium musimy zainstalować git'a, przy pomocy którego zrobimy klonowanie, po sklonowaniu git już nam nie będzie potrzebny, dlatego możemy się go pozbyć, aby nie zajmował dodatkowego miejsca.
