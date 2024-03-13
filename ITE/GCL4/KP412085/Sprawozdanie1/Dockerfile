FROM ubuntu:22.04

WORKDIR usr/src/app

#umożliwia cache'owanie instalacji pakietów pomiędzy kolejnymi budowaniami kontenerów
#z obrazu, (dla włączonego BuildKit w dokerze)
#RUN --mount=type=cache,target=/var/cache/apt

RUN apt-get update && apt-get install -y git openssh-client \
    && useradd -ms /bin/bash my_ubuntu && chown -R my_ubuntu:my_ubuntu /usr/src/app

USER my_ubuntu

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

CMD ["/bin/bash"]