#!/bin/bash

#-------------------------------#
#  Insstall zabbix-server    	#
#-------------------------------#

#---------------#
#  Variable     #
#---------------#

DBName=zabbix
DBUser=zabbix
DBPassword=Gfhjkm
DBHost=localhost
DBType=MYSQL
DBPort=3306
ZBX_SERVER=localhost
ZBX_SERVER_PORT=10051
ZBX_SERVER_NAME='zabbix-server'

## Change hostname (metadata)
sudo hostnamectl set-hostname ${ZBX_SERVER_NAME}

## Disable SElinux and firewalld
sudo sed -i "s/SELINUX=.*$/SELINUX=disabled/" /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld

## Config firewall rules
sudo firewall-cmd --permanent --add-port={80/tcp,443/tcp,3306/tcp,10051/tcp,10050/tcp,10050/udp,10051/udp} 2>/dev/nul
sudo firewall-cmd --reload

## Config timezone of host
sudo mv /etc/localtime /etc/localtime-backup
sudo ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime

## Install time synchronize service
sudo yum install chrony -y
sudo systemctl start chronyd
sudo systemctl enable chronyd

## Install apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum update -y

## Add repo and install zabbix and features
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum clean all
sudo yum-config-manager --enable rhel-7-server-optional-rpms
sudo yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent -y
sudo chkconfig httpd on

## Install database server
sudo yum install mariadb-server mariadb -y
sudo systemctl enable mariadb.service
sudo systemctl start mariadb

## Create database and get permissions for user
mysql -uroot -e "CREATE DATABASE ${DBName} CHARACTER SET utf8 COLLATE utf8_bin;"
mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DBName}.* to ${DBUser}@${DBHost} IDENTIFIED BY '${DBPassword}';"
mysql -uroot -e "FLUSH PRIVILEGES;"
mysql -uroot -e "EXIT"

## Import database schemas and config mysql
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u${DBUser} -p${DBPassword} ${DBName}

## Enable and start apache and zabbix server service
sudo systemctl enable zabbix-server httpd
sudo systemctl restart zabbix-server httpd

## Change config of zabbix server
sudo tee /etc/zabbix/zabbix_server.conf << EOF
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
SocketDir=/var/run/zabbix
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
DBName=${DBName}
DBUser=${DBUser}
DBPassword=${DBPassword}
DBHost=${DBHost}
DBPort=${DBPort}
EOF

## Config timezone for zabbix
sudo sed -i '/timezone/s/#//' /etc/httpd/conf.d/zabbix.conf | sudo sed -i 's/Europe\/Riga/Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf

sudo tee /etc/zabbix/web/zabbix.conf.php << EOF
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = "${DBType}";
\$DB['SERVER']   = "${DBHost}";
\$DB['PORT']     = "${DBPort}";
\$DB['DATABASE'] = "${DBName}";
\$DB['USER']     = "${DBUser}";
\$DB['PASSWORD'] = "${DBPassword}";

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = "${ZBX_SERVER}";
\$ZBX_SERVER_PORT = "${ZBX_SERVER_PORT}";
\$ZBX_SERVER_NAME = "${ZBX_SERVER_NAME}";

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOF

sudo systemctl restart zabbix-server zabbix-agent

## Config SELinux
#sudo ausearch -c ${ZBX_SERVER_NAME} --raw | audit2allow -M my-zabbixserver
#sudo semodule -i my-zabbixserver.pp
#sudo yum install policycoreutils-python -y
#sudo yum install setroubleshoot -y
#sudo setsebool -P httpd_can_connect_zabbix 1
#sudo setsebool -P httpd_can_network_connect_db 1
#sudo setsebool -P httpd_can_network_connect 1
#sudo setsebool -P zabbix_can_network 1

## Restart apache
sudo systemctl restart httpd
sudo setenforce 0

## Restart OS
#sudo reboot
