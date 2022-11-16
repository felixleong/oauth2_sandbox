FROM python:3

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /code

# Install the Python build environment
RUN pip3 install --upgrade pip && pip3 install poetry

COPY pyproject.toml poetry.lock /code/
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction
COPY . /code/
