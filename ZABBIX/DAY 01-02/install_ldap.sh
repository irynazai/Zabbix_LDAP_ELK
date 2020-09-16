#!/bin/bash

#-------------------------------------------#
#  Insstall ldap-server and myphpadmin      #
#-------------------------------------------#

#---------------#
#  Variable     #
#---------------#

CN=Admin
DC1=zabbix
DC2=com
PASSWORD_ADMIN=123456789
PASSWORD_USER=1234567
SSH_KEY=""              #use your ssh public key
USER=zaitsava
NAME_OU1=People
NUMBER_GUID=1005

## Install opanldap
sudo yum update -y && sudo yum install -y openldap openldap-servers openldap-clients
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd

## Create root password wuth SSHA encrypt
slappasswd -h {SSHA} -s ${PASSWORD_ADMIN} > ~/newpasswd

## Add and upload root password schema
sudo tee ldaprootpasswd.ldif << EOF
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $(cat ~/newpasswd)
EOF

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ldaprootpasswd.ldif


## Add and upload ssh schema
sudo tee openssh-lpk.ldif << EOF
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
sudo tee ldapdomain.ldif << EOF
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=${CN},dc=${DC1},dc=${DC2}" read by * none

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=${DC1},dc=${DC2}

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=${CN},dc=${DC1},dc=${DC2}

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $(cat ~/newpasswd)

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by dn="cn=${CN},dc=${DC1},dc=${DC2}" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=${CN},dc=${DC1},dc=${DC2}" write by * read
EOF

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldapdomain.ldif

## Create and config base domain
sudo tee baseldapdomain.ldif << EOF
dn: dc=${DC1},dc=${DC2}
objectClass: top
objectClass: dcObject
objectclass: organization
o: ${DC1} ${DC2}
dc: ${DC1}

dn: cn=${CN},dc=${DC1},dc=${DC2}
objectClass: organizationalRole
cn: ${CN}
description: Directory ${CN}

dn: ou=${NAME_OU1},dc=${DC1},dc=${DC2}
objectClass: organizationalUnit
ou: ${NAME_OU1}

dn: ou=Group,dc=${DC1},dc=${DC2}
objectClass: organizationalUnit
ou: Group 
EOF

## Create and config group
sudo ldapadd -x -D "cn=${CN},dc=${DC1},dc=${DC2}" -w ${PASSWORD_ADMIN} -f baseldapdomain.ldif

sudo tee ldapgroup.ldif << EOF
dn: cn=${CN},ou=Group,dc=${DC1},dc=${DC2}
objectClass: top
objectClass: posixGroup
gidNumber: ${NUMBER_GUID}
EOF

sudo ldapadd -x -w ${PASSWORD_ADMIN} -D "cn=${CN},dc=${DC1},dc=${DC2}" -f ldapgroup.ldif

## Create root password wuth SSHA encrypt
slappasswd -h {SSHA} -s ${PASSWORD_USER} > ~/pass

## Create and config user
sudo tee ldapuser.ldif << EOF
dn: uid=${USER},ou=${NAME_OU1},dc=${DC1},dc=${DC2}
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
objectClass: ldapPublicKey
cn: ${USER}
uid: ${USER}
uidNumber: ${NUMBER_GUID}
gidNumber: ${NUMBER_GUID}
homeDirectory: /home/${USER}
userPassword: $(cat ~/pass)
loginShell: /bin/bash
gecos: ${USER}
shadowLastChange: 0
shadowMax: 0
shadowWarning: 0
sshPublicKey: ${SSH_KEY}
EOF

sudo ldapadd -x -w ${PASSWORD_ADMIN} -D "cn=${CN},dc=${DC1},dc=${DC2}" -f ldapuser.ldif

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
