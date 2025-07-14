FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache wget perl perl-net-ssleay openssl bash tar gzip net-tools

RUN wget https://download.webmin.com/developers-key.asc -O /tmp/webmin-key.asc

RUN wget http://prdownloads.sourceforge.net/webadmin/webmin-2.105.tar.gz && \
    tar xzf webmin-2.105.tar.gz && \
    cd webmin-2.105 && \
    ./setup.sh /usr/local/webmin --force && \
    cd .. && \
    rm -rf webmin-2.105 webmin-2.105.tar.gz

RUN apk add --no-cache net-tools

RUN sed -i 's/ssl=1/ssl=0/g' /usr/local/webmin/miniserv.conf

# Change PASSWORD to your password

RUN echo "root:PASSWORD" | chpasswd

# Port

EXPOSE 10000

CMD ["/bin/sh", "-c", "/usr/local/webmin/start && tail -f /dev/null"]
