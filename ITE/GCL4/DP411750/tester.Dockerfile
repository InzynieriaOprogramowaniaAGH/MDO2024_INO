FROM flask-app

RUN pip install -r ./requirements/tests.txt && pip install pytest && pip install -e .[dev]

CMD ["pytest"]