FROM ubuntu:latest

RUN apt-get update && apt-get install -y iperf3 && apt-get clean

CMD ["iperf3", "-s"]
