FROM node:alpine

# Instalacja git
RUN apk add --no-cache git

# Klonowanie repozytorium
RUN git clone https://github.com/codeclown/tesseract.js-node.git

WORKDIR /tesseract.js-node

# Instalacja zależności
RUN npm install

# Wskazanie pliku startowego Twojej aplikacji
CMD ["node", "package.js"]
