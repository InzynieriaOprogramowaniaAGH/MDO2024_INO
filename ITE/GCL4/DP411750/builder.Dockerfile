FROM python:3.9-slim

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/pallets/flask ./app

WORKDIR ./app

RUN pip install -r ./requirements/build.txt && pip install flask  

EXPOSE 5001

CMD ["python", "app.py"]
