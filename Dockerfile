FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget gnupg apt-transport-https software-properties-common && \
    wget -qO- https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh | sh && \
    apt-get install -y webmin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# Change PASSWORD to password
RUN echo "root:PASSWORD" | chpasswd

# Port
EXPOSE 10000

CMD ["/bin/sh", "-c", "service webmin start && tail -f /dev/null"]
