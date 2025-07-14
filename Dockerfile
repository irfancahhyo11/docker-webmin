FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache wget curl sudo git vim nano bash

RUN adduser -D user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apk add --no-cache apache2 mariadb mariadb-client php php-apache2 php-mysqli && \
    mkdir -p /run/apache2 && \
    chown -R apache:apache /var/www && \
    /etc/init.d/mariadb setup && \
    rc-service mariadb start && \
    mysqladmin -u root password 'PASSWORD' && \
    rc-service apache2 start

RUN wget http://prdownloads.sourceforge.net/webadmin/webmin-2.105.tar.gz && \
    tar xzf webmin-2.105.tar.gz && \
    cd webmin-2.105 && \
    ./setup.sh /usr/local/webmin --force && \
    cd .. && rm -rf webmin-2.105 webmin-2.105.tar.gz && \
    /usr/local/webmin/start

RUN apk add --no-cache openssh && \
    ssh-keygen -A && \
    mkdir -p /var/run/sshd

# change PASSWORD to your password
RUN echo "root:PASSWORD" | chpasswd

ADD ./run.sh /run.sh
RUN chmod +x /run.sh


CMD ["/run.sh"]
