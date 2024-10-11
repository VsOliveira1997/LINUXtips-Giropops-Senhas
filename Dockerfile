FROM python:3.10-slim

RUN python -m pip install virtualenv

RUN virtualenv giropops_env

RUN . /giropops_env/bin/activate

WORKDIR /app

COPY . /app

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir -r /app/requirements.txt

ENV REDIS_HOST=172.20.0.3

EXPOSE 5000

CMD ["flask" ,"run","--host=0.0.0.0"]



