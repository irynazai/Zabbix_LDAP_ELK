#!/bin/bash

## Install opanldap
sudo yum update -y && sudo yum install -y openldap openldap-servers openldap-clients
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd

## Create root password wuth SSHA encrypt
PASSW="123456789"
slappasswd -h {SSHA} -s $PASSW > ~/newpasswd
PASSWORD=$(cat ~/newpasswd)

## Add and upload root password schema
cat << EOF > ldaprootpasswd.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: ${PASSWORD}
EOF

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ldaprootpasswd.ldif


## Add and upload ssh schema
sudo cat > openssh-lpk.ldif <<EOF
dn: cn=openssh-lpk,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: openssh-lpk
olcAttributeTypes: ( 1.3.6.1.4.1.24552.500.1.1.1.13 NAME 'sshPublicKey'
    DESC 'MANDATORY: OpenSSH Public key'
    EQUALITY octetStringMatch
    SYNTAX 1.3.6.1.4.1.1466.115.121.1.40 )
olcObjectClasses: ( 1.3.6.1.4.1.24552.500.1.1.2.0 NAME 'ldapPublicKey' SUP top AUXILIARY
    DESC 'MANDATORY: OpenSSH LPK objectclass'
    MAY ( sshPublicKey $ uid )
    )
EOF

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f openssh-lpk.ldif

## Update database config
sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
sudo chown -R ldap:ldap /var/lib/ldap/DB_CONFIG
sudo systemctl restart slapd

## Add and upload exists schemas
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

## Add and upload domain schema
cat << EOF > ldapdomain.ldif
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=Manager,dc=devopsldab,dc=com" read by * none

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=devopsldab,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=Manager,dc=devopsldab,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: ${PASSWORD}

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by dn="cn=Manager,dc=devopsldab,dc=com" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=Manager,dc=devopsldab,dc=com" write by * read
EOF

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldapdomain.ldif

## Create and config base domain
cat << EOF > baseldapdomain.ldif
dn: dc=devopsldab,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: devopsldab com
dc: devopsldab

dn: cn=Manager,dc=devopsldab,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=devopsldab,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=devopsldab,dc=com
objectClass: organizationalUnit
ou: Group
EOF

## Create and config group
sudo ldapadd -x -D "cn=Manager,dc=devopsldab,dc=com" -w $PASSW -f baseldapdomain.ldif

cat << EOF > ldapgroup.ldif
dn: cn=Manager,ou=Group,dc=devopsldab,dc=com
objectClass: top
objectClass: posixGroup
gidNumber: 1005
EOF

sudo ldapadd -x -w $PASSW -D "cn=Manager,dc=devopsldab,dc=com" -f ldapgroup.ldif

## Create and config user
cat << EOF > ldapuser.ldif
dn: uid=zaitsava,ou=People,dc=devopsldab,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
objectClass: ldapPublicKey
cn: zaitsava
uid: zaitsava
uidNumber: 1005
gidNumber: 1005
homeDirectory: /home/zaitsava
userPassword: $PASSWORD
loginShell: /bin/bash
gecos: zaitsava
shadowLastChange: 0
shadowMax: -1
shadowWarning: 0
sshPublicKey: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHRiEo9ntE8mqLShQWhqq/jLeECPqoPcyPHCSUMxpQNcbqwZIMMXnM9iPpfPxDNV+QTxYtSFTx0VAvMrJt6pWtJj6LQ+X6K5GSJkN7OHSsjFQWzJtoguWo/a09NYfoUG7NkNg0RFmbGI0a6MRrtYD2ZENi3efCskFjivL+LoPEwthxWKvi3fbu/S23QnkPUBF0ZZy70S+sYrDWA1drVKe6gHxsc0ILltNr8PRLgqJHSSBEseTIrp4rfoJk+N27W7EpT3hb0qIakQgQK/XMo2VE+3h00r/tF91b1ERnV/FP9y8D3drvo1bxqmj/ybxmA1ZOZrKJ+xQAZ02lLCslJEHDozxjX78p1Wpf9G8k2R2A3cpwCz5L++BTtKuem5/JjTPr1YwGuZ+X+PKvW9mxlaBDUHexIvjKEmsTRxwtYsvxJ8I8/TnaRs0cnyO0dsOuwsMrkGyyTzmHpK+S5ec6YFbsJG8FQ+1cNAVUjrc99jLtV9M6MqO+HL+WzOoKy/mnyVU= mumz@mumz-pc
EOF

sudo ldapadd -x -w $PASSW -D "cn=Manager,dc=devopsldab,dc=com" -f ldapuser.ldif

## Install and config phpldapadmin
sudo yum --enablerepo=epel -y install phpldapadmin
sudo sed -i "s/\$servers->setValue('login','attr','uid');/\/\/\$servers->setValue('login','attr','uid');/" /etc/phpldapadmin/config.php
sudo sed -i "s/\/\/\$servers->setValue('login','attr','dn');/\$servers->setValue('login','attr','dn');/" /etc/phpldapadmin/config.php
sudo sed -i "s/Require local/Require all granted/"  /etc/httpd/conf.d/phpldapadmin.conf

## Restart services
sudo systemctl restart slapd
sudo systemctl restart httpd

## Delete all ldif files and credentials
sudo rm -f *.ldif
PASSWORD=""
PASSW=""
