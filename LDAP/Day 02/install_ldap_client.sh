#!/bin/bash

## Install ldap client
sudo yum -y install openldap-clients nss-pam-ldapd

## Config ldap client
sudo authconfig --enableldap --enableldapauth --ldapserver=${server} --ldapbasedn="dc=devopsldab,dc=com" --enablemkhomedir --update

## Config sshd
#sudo sed -i "/\PasswordAuthentication no/s/^/\#/" /etc/ssh/sshd_config
#sudo sed -i "s/\#PasswordAuthentication yes/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/\#AuthorizedKeysCommand none/AuthorizedKeysCommand /opt/ssh_ldap.sh/g" /etc/ssh/sshd_config
sudo sed -i "s/\#AuthorizedKeysCommandUser nobody/AuthorizedKeysCommandUser nobody/g" /etc/ssh/sshd_config 

## Add script for checking user
cat << EOF > /opt/ssh_ldap.sh
#! /bin/bash
/usr/bin/ldapsearch -x '(&(objectClass=posixAccount)(uid='"\$1"'))' 'sshPublicKey' | sed -n '/^ /{H;d};/sshPublicKey:/x;\$g;s/\n *//g;s/sshPublicKey: //gp'
EOF

## Make script executable
sudo chmod +x /opt/ssh_ldap.sh

## Update and restart
sudo systemctl restart nslcd
sudo systemctl restart sshd
