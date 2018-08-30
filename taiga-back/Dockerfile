FROM python:3.4

RUN useradd -ms /bin/bash taiga

RUN apt-get update -y
RUN apt-get install -y netcat gettext
RUN pip install circus gunicorn

WORKDIR /home/taiga

RUN git clone https://github.com/taigaio/taiga-back.git
WORKDIR /home/taiga/taiga-back
RUN git checkout stable
RUN pip install -r requirements.txt

ADD *.sh /root/
RUN chmod +x /root/*.sh

RUN mkdir -p /home/taiga/logs
RUN mkdir -p /home/taiga/media
RUN mkdir -p /home/taiga/static


ENTRYPOINT ["/root/startup.sh"]



