#distro
FROM oraclelinux:10

RUN dnf -y update && \
    dnf -y install wget perl perl-Net-SSLeay openssl && \
    wget https://download.webmin.com/developers-key.asc -O /etc/pki/rpm-gpg/RPM-GPG-KEY-webmin-developers && \
    echo "[Webmin-newkey]" > /etc/yum.repos.d/webmin.repo && \
    echo "name=Webmin Distribution Neutral (new key)" >> /etc/yum.repos.d/webmin.repo && \
    echo "baseurl=https://download.webmin.com/download/newkey/yum" >> /etc/yum.repos.d/webmin.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/webmin.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/webmin.repo && \
    echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webmin-developers" >> /etc/yum.repos.d/webmin.repo && \
    dnf -y install webmin && \
    yum install net-tools
    dnf clean all

RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# change PASSWORD to your password

RUN echo "root:PASSWORD" | chpasswd

# webmin port

EXPOSE 10000

CMD ["/bin/sh", "-c", "/usr/libexec/webmin/webmin-init start && tail -f /dev/null"]
