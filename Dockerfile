FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget gnupg

RUN apt-get install net-tools

RUN wget -qO- https://download.webmin.com/jcameron-key.asc | gpg --dearmor -o /usr/share/keyrings/webmin.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list

RUN apt-get update && \
    apt-get install -y webmin && \
    apt-get clean

RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf


# Change PASSWORD to password
RUN echo "root:PASSWORD" | chpasswd

# Port
EXPOSE 10000

CMD ["/bin/sh", "-c", "service webmin start && tail -f /dev/null"]
