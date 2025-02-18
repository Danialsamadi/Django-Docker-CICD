#! /bin/bash

# Variables
DOMAIN=danialsamadi.github.io
SSH_PORT=1245
BAC_DIR=/opt/backup/file_$NOW

if [-z $BAC_DIR]; then
  echo "Already exist"
else 
  mikdir -p $BAC_DIR
fi


apt update && apt upgrade -y


apt install curl vim fail2ban

# disable and mask ufw
systemctl stop ufw
systemctl disable ufw
systemctl mask ufw


cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sed -i 's/ssh port/ ssh port=''$SSH_PORT/g' /etc/fail2ban.local

systemctl restart fail2ban
systemctl enable fail2ban
fail2ban-client status
