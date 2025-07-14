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

RUN echo '#!/sbin/openrc-run\n\
name="webmin"\n\
description="Webmin web-based administration interface"\n\
\n\
command="/usr/bin/perl"\n\
command_args="/usr/local/webmin/miniserv.pl /etc/webmin/miniserv.conf"\n\
command_background="yes"\n\
pidfile="/var/run/webmin.pid"\n\
command_user="root"\n\
\n\
depend() {\n\
    need net\n\
    after firewall\n\
}\n\
\n\
start_pre() {\n\
    checkpath --directory --mode 0755 --owner root:root /var/run\n\
    if [ ! -f /etc/webmin/miniserv.conf ]; then\n\
        eerror "Configuration file not found"\n\
        return 1\n\
    fi\n\
}\n\
\n\
stop_post() {\n\
    rm -f "${pidfile}"\n\
}' > /etc/init.d/webmin && \
    chmod +x /etc/init.d/webmin

RUN echo '#!/bin/sh\n\
cd /usr/local/webmin\n\
perl ./miniserv.pl /etc/webmin/miniserv.conf &\n\
echo $! > /var/run/webmin.pid' > /usr/local/webmin/start && \
    chmod +x /usr/local/webmin/start

RUN echo '#!/bin/sh\n\
if [ -f /var/run/webmin.pid ]; then\n\
    kill $(cat /var/run/webmin.pid)\n\
    rm -f /var/run/webmin.pid\n\
    echo "Webmin stopped"\n\
else\n\
    echo "Webmin PID file not found"\n\
fi' > /usr/local/webmin/stop && \
    chmod +x /usr/local/webmin/stop

RUN echo '#!/bin/sh\n\
/usr/local/webmin/stop\n\
sleep 2\n\
/usr/local/webmin/start' > /usr/local/webmin/restart && \
    chmod +x /usr/local/webmin/restart

RUN echo "root:PASSWORD" | chpasswd

EXPOSE 10000

CMD ["/bin/sh", "-c", "rc-service webmin start && tail -f /dev/null"]
