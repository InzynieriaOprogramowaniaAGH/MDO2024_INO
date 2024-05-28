FROM tdwabuild

WORKDIR /root/TDWA

CMD npm adduser --registry http://localhost:4873 & npm publish --registry http://verdaccio:4873/