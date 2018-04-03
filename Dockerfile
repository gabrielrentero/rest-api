FROM python:3
MAINTAINER Gabriel MR

ENV PYTHONUNBUFFERED 1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y && \
    apt-get install python-pip python3-dev libpq-dev -y && \
    apt-get clean

RUN pip install virtualenv

COPY requirements.txt /app

RUN virtualenv venv --python=python3.6 && \
    /bin/bash -c "source venv/bin/activate && pip install -r requirements.txt"

# Copy over all the remaining code
COPY . /app

CMD ["/app/venv/bin/uwsgi", "--master", "--emperor", "/app/uwsgi.ini", "--die-on-term", "--logto", "/app/log/emperor.log"]
