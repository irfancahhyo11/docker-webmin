FROM debian:latest
#RUN echo "deb http://download.webmin.com/download/repository trusty contrib \n\
#deb http://webmin.mirror.somersettechsolutions.co.uk/repository trusty contrib" > /etc/apt/sources.list.d/webmin.list \
#RUN apt-get update && apt-get install -y wget
ADD https://raw.githubusercontent.com/dockerimages/ubuntu-installer/master/prepare-base.sh /prepare-base.sh
ADD https://raw.githubusercontent.com/dockerimages/ubuntu-installer/master/lampp.sh /lampp.sh
ADD https://raw.githubusercontent.com/dockerimages/ubuntu-installer/master/webmin.sh /webmin.sh
RUN chmod +x *.sh
RUN /prepare-base.sh
RUN cat /etc/apt/apt.conf.d/01buildconfig
RUN apt-get update
RUN /lampp.sh
RUN /webmin.sh
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

ADD https://github.com/irfancahhyo11/docker-webmin/releases/download/binaries/run_bedrockinstall.sh
ADD https://github.com/irfancahhyo11/docker-webmin/releases/download/binaries/bedrock-installer.sh

# change PASSWORD to your password

RUN echo "root:PASSWORD" | chpasswd

ADD ./run.sh /run.sh
ADD ./run_bedrockinstall.sh /run_bedrockinstall.sh
ADD ./bedrock-installer.sh /bedrock-installer.sh
RUN chmod +x /run.sh
RUN chmod +x /run_bedrockinstall.sh
RUN chmod +x /bedrock-installer.sh
RUN ./bedrock-installer.sh
CMD ["/run.sh"]
