FROM builder:0.1

SHELL ["/bin/bash", "-c"]

WORKDIR /programmer-calculator

RUN ./run-tests.sh