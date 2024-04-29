FROM builder-dockerfile

RUN apt-get update
RUN apt-get install libncurses5 -y
RUN apt-get libncursesw5 -y