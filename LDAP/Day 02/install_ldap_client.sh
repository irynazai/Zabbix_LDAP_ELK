#!/bin/bash

## Install ldap client
sudo yum install -y openldap-clients
sudo yum install -y nss-pam-ldapd

## Config ldap client
sudo authconfig --enableldap --enableldapauth --ldapserver=${server} --ldapbasedn="dc=devopsldab,dc=com" --enablemkhomedir --updateall
sudo systemctl stop firewalld

## Add server address in config
sudo sed -i 's/127.0.0.1/'${server}'/' /etc/nslcd.conf
sudo sed -i '/base/d' /etc/nslcd.conf
sudo echo -e "dc=devopsldab,dc=com" >> /etc/nslcd.conf

## Add script for checking user
sudo cat > /opt/ssh_ldap.sh <<EOF
#!/bin/bash
set -eou pipefail
IFS=$'\n\t'
result=\$(ldapsearch -x '(&(objectClass=posixAccount)(uid='"\$1"'))' 'sshPublicKey')
attrLine=\$(echo "\$result" | sed -n '/^ /{H;d};/sshPublicKey:/x;\$g;s/\n *//g;/sshPublicKey:/p')
if [[ "\$attrLine" == sshPublicKey::* ]]; then
  echo "\$attrLine" | sed 's/sshPublicKey:: //' | base64 -d
elif [[ "\$attrLine" == sshPublicKey:* ]]; then
  echo "\$attrLine" | sed 's/sshPublicKey: //'
else
  exit 1
fi
EOF

## Make script executable
sudo chmod +x /opt/ssh_ldap.sh

## Config sshd
sudo sed -i "/\PasswordAuthentication no/s/^/\#/" /etc/ssh/sshd_config
sudo sed -i "/PermitRootLogin no/s/no/yes/g" /etc/ssh/sshd_config
sudo sed -i "s/\#PermitRootLogin /s/#//g" /etc/ssh/sshd_config
sudo sed -i "s/\#PasswordAuthentication yes/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/\#AuthorizedKeysCommand none/AuthorizedKeysCommand /opt/ssh_ldap.sh/g" /etc/ssh/sshd_config
sudo sed -i "s/\#AuthorizedKeysCommandUser nobody/AuthorizedKeysCommandUser nobody/g" /etc/ssh/sshd_config 
sudo systemctl restart sshd

