#!/bin/bash

sudo yum update -y && sudo yum install -y openldap openldap-servers openldap-clients
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd

slappasswd -h {SSHA} -s {jhjibqgfhjkmlkzj,kfrf  > ~/newpasswd
PASSWORD=$(cat ~/newpasswd)

cat << EOF > ldaprootpasswd.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: ${PASSWORD}
EOF

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ldaprootpasswd.ldif

sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
sudo chown -R ldap:ldap /var/lib/ldap/DB_CONFIG
sudo systemctl restart slapd
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif


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
olcAccess: {0}to attrs=userPassword,shadowLastChange by
  dn="cn=Manager,dc=devopsldab,dc=com" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=Manager,dc=devopsldab,dc=com" write by * read
EOF

sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldapdomain.ldif

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

sudo ldapadd -x -D "cn=Manager,dc=devopsldab,dc=com" -w {jhjibqgfhjkmlkzj,kfrf -f baseldapdomain.ldif

cat << EOF > ldapgroup.ldif
dn: cn=Manager,ou=Group,dc=devopsldab,dc=com
objectClass: top
objectClass: posixGroup
gidNumber: 1005
EOF

sudo ldapadd -x -w {jhjibqgfhjkmlkzj,kfrf -D "cn=Manager,dc=devopsldab,dc=com" -f ldapgroup.ldif

slappasswd -h {SSHA} -s {jhjibqgfhjkmlkz.pthf  > ~/pass


cat << EOF > ldapuser.ldif
dn: uid=iryna,ou=People,dc=devopsldab,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: iryna
uid: iryna
uidNumber: 1005
gidNumber: 1005
homeDirectory: /home/iryna
userPassword: $(cat ~/pass)
loginShell: /bin/bash
gecos: iryna
shadowLastChange: 0
shadowMax: -1
shadowWarning: 0
EOF

sudo ldapadd -x -w {jhjibqgfhjkmlkzj,kfrf -D "cn=Manager,dc=devopsldab,dc=com" -f ldapuser.ldif

sudo yum --enablerepo=epel -y install phpldapadmin
sudo sed -i "s/\$servers->setValue('login','attr','uid');/\/\/\$servers->setValue('login','attr','uid');/" /etc/phpldapadmin/config.php
sudo sed -i "s/\/\/\$servers->setValue('login','attr','dn');/\$servers->setValue('login','attr','dn');/" /etc/phpldapadmin/config.php
sudo sed -i "s/Require local/Require all granted/"  /etc/httpd/conf.d/phpldapadmin.conf

sudo systemctl restart slapd
sudo systemctl restart httpd

sudo rm -f *.ldif
PASSWORD=""
sudo rm ~/pass
