FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -o Dpkg::Options::="--force-confold" sslh
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

RUN a2enmod proxy
COPY myapp.conf /etc/apache2/sites-available/

RUN a2ensite myapp.conf
RUN service apache2 restart

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo 'root:password' | chpasswd
RUN service ssh restart

EXPOSE 443

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
