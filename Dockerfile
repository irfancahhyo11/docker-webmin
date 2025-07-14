FROM archlinux/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel wget curl sudo git

RUN pacman -S --noconfirm vim nano && \
    useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN curl -o xampp-installer.run https://www.apachefriends.org/xampp-files/8.2.12/xampp-linux-x64-8.2.12-0-installer.run && \
    chmod +x xampp-installer.run && \
    ./xampp-installer.run --mode unattended && \
    rm xampp-installer.run && \
    /opt/lampp/lampp start

RUN echo "[webmin]" >> /etc/pacman.conf && \
    echo "Server = https://download.webmin.com/download/repository" >> /etc/pacman.conf && \
    pacman-key --init && \
    wget http://www.webmin.com/jcameron-key.asc && \
    pacman-key --add jcameron-key.asc && \
    pacman-key --lsign-key 11F63C51 && \
    pacman -Syu --noconfirm webmin && \
    /etc/webmin/start

RUN pacman -S --noconfirm openssh && \
    ssh-keygen -A && \
    mkdir /var/run/sshd

# change PASSWORD to your password
RUN echo "root:PASSWORD" | chpasswd

ADD ./run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
