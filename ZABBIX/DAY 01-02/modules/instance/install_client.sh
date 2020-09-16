#!/bin/bash

#-----------------------#
# Install zabbix agent  # 
#-----------------------#

## Change hostname (metadata)
#sudo hostnamectl set-hostname VM2

## Config firewall rules
sudo firewall-cmd --permanent --add-port={22/tcp,80/tcp,443/tcp,3306/tcp,10051/tcp,10050/tcp,10050/udp,10051/udp} 2>/dev/nul
sudo firewall-cmd --reload

## Disable SElinux and firewalld
sudo setenforce 0
sudo sed -i "s/SELINUX=.*$/SELINUX=disabled/" /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld

## Config timezone of host
sudo mv /etc/localtime /etc/localtime-backup
sudo ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime

## Install time synchronize service
sudo yum install chrony -y
sudo systemctl start chronyd
sudo systemctl enable chronyd

## Install zabbix agent and features 
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum clean all
sudo yum install zabbix-agent -y

## Config zabbix agent
sudo tee /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Include=/etc/zabbix/zabbix_agentd.d/*.conf
Server=${IP}
ServerActive=${IP}
HostMetadataItem=system.uname 
Hostname=$(hostname -f)
HostnameItem=$(hostname -f)
UserParameter=count.accounts,sudo wc -l /etc/passwd
EOF

## Enable and start zabbix agent service
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent

sudo setenforce 0

## Config SELinux
#sudo grep httpd_t /var/log/audit/audit.log | audit2allow -M httpd_custom
#sudo semodule -i httpd_custom.pp
#sudo ausearch -c $(hostname -f) --raw | audit2allow -M my-zabbixserver
#sudo semodule -i my-zabbixserver.pp
#sudo yum install policycoreutils-python -y
#sudo yum install setroubleshoot -y
#sudo setsebool -P httpd_can_connect_zabbix 1
#sudo setsebool -P httpd_can_network_connect_db 1
#sudo setsebool -P httpd_can_network_connect 1
#sudo setsebool -P zabbix_can_network 1

#sudo reboot

#-------------------------------#
# Installation of tomcat  		#
#-------------------------------#

## Installing Java 8
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk-1.8.0.252.b09-2.el7_8.x86_64

## Create tomcat user
sudo groupadd tomcat
sudo useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

## Download Tomcat
sudo yum -y install wget
wget https://mirror.datacenter.by/pub/apache.org/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz

## Extract tar into /opt/tomcat
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1

## Make new permissions for tomcat dir
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo chmod 775 -R /var/log/tomcat

## Copy basic Tomcat configuration files
sudo /bin/cp -rf /tmp/tomcat-users.xml /opt/tomcat/conf/
sudo /bin/cp -rf /tmp/clusterjsp.war /opt/tomcat/webapps/
sudo /opt/tomcat/bin/startup.sh
sudo ufw allow 8080, 80
sudo setenforce 0

