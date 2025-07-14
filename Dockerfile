# linux distro
FROM almalinux:10
#FROM oraclelinux:9
#FROM oraclelinux:10

RUN dnf -y update && \
    dnf -y install wget perl perl-Net-SSLeay openssl && \
    wget http://www.webmin.com/jcameron-key.asc -O /etc/pki/rpm-gpg/RPM-GPG-KEY-webmin && \
    echo "[Webmin]" > /etc/yum.repos.d/webmin.repo && \
    echo "name=Webmin Distribution Neutral" >> /etc/yum.repos.d/webmin.repo && \
    echo "mirrorlist=https://download.webmin.com/download/yum/mirrorlist" >> /etc/yum.repos.d/webmin.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/webmin.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/webmin.repo && \
    echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webmin" >> /etc/yum.repos.d/webmin.repo && \
    dnf -y install webmin && \
    dnf clean all

RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# setting password!
RUN echo "root:YOUR_PASSWORD_HERE" | chpasswd

# Port for webmin
EXPOSE 10000

CMD ["/bin/sh", "-c", "/usr/libexec/webmin/webmin-init start && tail -f /dev/null"]
