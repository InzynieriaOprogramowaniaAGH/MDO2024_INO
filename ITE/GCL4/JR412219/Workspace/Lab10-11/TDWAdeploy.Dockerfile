FROM fedora:39

WORKDIR /root

RUN dnf update -y && dnf install -y nodejs git
RUN git clone https://github.com/devenes/node-js-dummy-test TDWA

WORKDIR /root/TDWA/node-js-dummy-test

RUN npm install

WORKDIR /root/TDWA

EXPOSE 3000

ENTRYPOINT  exit 1