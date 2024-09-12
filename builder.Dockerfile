FROM python:3.9-slim

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

RUN cd MDO2024_INO && git checkout DP411750

WORKDIR MDO2024_INO/ITE/GCL4/DP411750

RUN pip install --upgrade pip && pip install -r requirements.txt   
