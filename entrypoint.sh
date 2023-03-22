#!/bin/bash
apache2ctl -D FOREGROUND &
/usr/sbin/sshd -D &
sslh -f -u root -p 0.0.0.0:443 --ssh 127.0.0.1:22 --ssl 127.0.0.1:443
