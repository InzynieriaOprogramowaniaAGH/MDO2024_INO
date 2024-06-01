FROM tdwabuild

WORKDIR /root/TDWA

CMD npm version jr-$(date +%Y-%m-%d) --no-git-tag-version & npm adduser --registry http://localhost:4873 & npm publish --registry http://verdaccio:4873/