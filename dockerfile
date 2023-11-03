FROM python:3.7

RUN apt-get update && apt-get install -y default-libmysqlclient-dev 

RUN git clone https://github.com/djtoler/Deployment7.git

WORKDIR Deployment7

RUN pip install -r requirements.txt

RUN pip install mysqlclient

RUN pip install gunicorn


EXPOSE 8000

ENTRYPOINT ["gunicorn", "app:app", "-b", "0.0.0.0:8000"]

