FROM tdwabuild

WORKDIR /root/TDWA

RUN npm publish --registry http://localhost:4873/