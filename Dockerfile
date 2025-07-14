FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache wget perl perl-net-ssleay openssl tar gzip expect net-tools openrc

RUN wget https://github.com/webmin/webmin/releases/download/2.402/webmin-2.402.tar.gz && \
    tar xzf webmin-2.402.tar.gz && \
    cd webmin-2.402 && \
    expect -c "spawn ./setup.sh /usr/local/webmin; \
               expect \"Use SSL*\"; send \"n\r\"; \
               expect \"Start Webmin*\"; send \"y\r\"; \
               expect eof" && \
    cd .. && \
    rm -rf webmin-2.402 webmin-2.402.tar.gz

RUN echo "root:PASSWORD" | chpasswd

EXPOSE 10000

CMD ["/bin/sh", "-c", "rc-service webmin start && tail -f /dev/null"]
