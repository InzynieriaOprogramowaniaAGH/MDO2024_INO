FROM tdwabuild

WORKDIR /root/TDWA

RUN npm publish --registry http://verdaccio:4873/