FROM archlinux/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git wget perl openssl sudo

RUN useradd -m -G wheel -s /bin/bash builder && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm

RUN yay -S --noconfirm webmin

USER root

RUN sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# Change PASSWORD to your password

RUN echo "root:PASSWORD" | chpasswd

# port

EXPOSE 10000

CMD ["/bin/sh", "-c", "systemctl start webmin && tail -f /dev/null"]
