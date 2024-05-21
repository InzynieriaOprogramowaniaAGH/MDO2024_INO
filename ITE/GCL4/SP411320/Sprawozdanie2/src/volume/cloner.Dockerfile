FROM git-fedora
VOLUME /root/vin
WORKDIR /root/vin
RUN git clone https://github.com/devenes/node-js-dummy-test.git /root/vin/dummy
