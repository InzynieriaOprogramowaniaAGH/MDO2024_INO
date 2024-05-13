FROM ubuntu:latest
RUN apt-get update && apt-get install -y
RUN apt-get install -y libglib2.0-0 
RUN apt-get install libutf8proc-dev -y
Run apt-get install libcrypt1 -y

