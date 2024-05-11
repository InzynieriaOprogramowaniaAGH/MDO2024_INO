FROM fedora
RUN dnf install -y git python3-pip
RUN git clone https://github.com/larose/utt.git
WORKDIR /utt
# Install dependencies using Poetry
RUN pip install poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-dev

    