## Sprawozdanie 2
# Dockerfiles, kontener jako definicja etapu

Wraz z rozwojem technologii, nieustannie starmy się znaleźć metody, które pomogą nam usprawnić, przyspieszyć wdrażanie aplikacji
W tym zakresie, docker od kilku lat sprawdza się świetnie i jest jednym z najczęściej używanych narzędzi.
Dockerfile jest to plik tekstowy, który zawiera zestaw instrukcji służących, do zautomatyzowanego tworzenia obrazu kontenerów.
Jest to skrypt, który definiuje kroki potrzebne do zbudowania kontenera, wraz z konfigurają i zależnościami aplikacji.

Główne cele używania dockerfile'i to:
- **Automatyzacja budowania obrazów**: Dockerfile pozwala na zdefiniowanie wszystkich niezbędnych kroków do utworzenia obrazu kontenera.
Dzięki temu proces budowy może być zautomatyzowany i może być powtarzalny w różnych środowiksach bez konieczności ręcznej konfiguracji
każdego kontenera.
- **Reprodukcja środowiska**: Umożliwia łatwą reprodukcję środowiska aplikacji na różnych maszynach
- **Zarządzanie zależnościami**: Poprzez zdefiniowanie zależności i konfiguracji w dockerfile'u, można zarządzać wersjami oprogramowania
i bibliotek używanych przez aplikację. Unikamy dzięki temu problemów z niekompatybilnością wersji
- **Zwiększenie skalowalności**: Ułatwia proces skalowania, ponieważ możemy szybko tworzyć nowe instancje kontenerów na podstawie tego samego obrazu.

# Znajdź repozytorium z kodem dowolnego oprogramowania

- **node-js-dummy-test**: https://github.com/devenes/node-js-dummy-test

Najpierw tworzymy dockerfile do budowania aplikacji:

```Dockerfile
FROM node

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install
```

**FROM node** - określami obraz bazowy, który zostanie użyty do budowy nowego obrazu. W tym przypadku obraz node.js
**RUN git clone** - klonujemy repozytorium zawierające aplikację z githuba. 
**WORKDIR /...** - ustawiamy katalog roboczy
**RUN npm install** - instalujemy zależności aplikacji nodowej wewnątrz kontenera

![Node_build](images/docker_build_node.png)

Następnie budujemy obraz do testowania aplikacji:

```Dockerfile
FROM node_builder
RUN npm test
```

**FROM node_builder** - określamy obraz bazowy - node_builder, który przed chwilą zbudowaliśmy
**RUN npm test** - uruchamiamy skrypt testowy aplikacji

![Node_test](images/docker_build_node_test.png)

Następnie budujemy kontener node deploy

```Dockerfile
FROM node_builder
CMD ["npm", "start"]
```
![Node_deploy](images/docker_node_deploy.png)

![Docker_ps](images/docker_ps.png)

Następnie dodałem plik docker compose, by jeszcze bardziej zautomatyzować cały proces:

```yaml
version: '3.8'

services:
  node_builder:
    build:
      context: .
      dockerfile: ./node_builder.Dockerfile
    image: node_builder

  node_test:
    build:
      context: .
      dockerfile: ./node_test.Dockerfile
    image: node_test
    depends_on:
      - node_builder

  node_depoy:
    build:
      context: .
      dockerfile: ./node_deploy.Dockerfile
    image: node_deploy
    depends_on:
      - node_builder
```

![Docker_compose](images/docker_compose_2.png)

Docker compose jest to narzędzie do uruchamiania wielu kontenerów w jednym środowisku za pomocą prostego pliku YAML. 
Pozwala na łatwe zarządzanie aplikacjami.


