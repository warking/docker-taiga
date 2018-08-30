FROM python:3.4

RUN useradd -ms /bin/bash taiga

RUN apt-get update -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN pip install circus gunicorn

WORKDIR /home/taiga

RUN git clone https://github.com/taigaio/taiga-events.git
WORKDIR /home/taiga/taiga-events
RUN npm install
RUN npm install -g coffee-script

ADD *.sh /root/
RUN chmod +x /root/*.sh

RUN mkdir -p /home/taiga/logs

EXPOSE 8888

ENTRYPOINT ["/root/startup.sh"]



