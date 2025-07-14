#linux distro
FROM oraclelinux:9

RUN dnf -y update && \
    dnf -y install wget perl perl-Net-SSLeay openssl && \
    echo "[Webmin]" > /etc/yum.repos.d/webmin.repo && \
    echo "name=Webmin Distribution Neutral" >> /etc/yum.repos.d/webmin.repo && \
    echo "mirrorlist=https://download.webmin.com/download/yum/mirrorlist" >> /etc/yum.repos.d/webmin.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/webmin.repo && \
    rpm --import http://www.webmin.com/jcameron-key.asc && \
    dnf -y install webmin && \
    dnf clean all


RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf



#RUN passwd root

#port
EXPOSE 10000

CMD ["/bin/sh", "-c", "/usr/libexec/webmin/webmin-init start && tail -f /dev/null"]

#passwd root
