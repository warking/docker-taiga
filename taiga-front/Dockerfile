FROM nginx

RUN useradd -ms /bin/bash taiga

RUN apt-get update -y
RUN apt-get install -y git
WORKDIR /home/taiga

RUN git clone https://github.com/taigaio/taiga-front-dist.git taiga-front
WORKDIR /home/taiga/taiga-front
RUN git checkout stable

ADD *.sh /root/
RUN chmod +x /root/*.sh

RUN mkdir -p /home/taiga/logs

RUN rm -rf /etc/nginx/sites-enabled/default

EXPOSE 80

ENTRYPOINT ["/root/startup.sh"]



