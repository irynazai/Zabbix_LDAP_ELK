#!/bin/bash

#-------------------------------#
# Installation of java  		#
#-------------------------------#
sudo yum install -y java-1.8.0-openjdk

#-------------------------------#
# Installation of tomcat  		#
#-------------------------------#
sudo yum install -y tomcat wget tomcat-admin-webapps tomcat-docs-webapp tomcat-javadoc tomcat-webapps

## Upload and deploy sample.war for test
wget https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war 
sudo /bin/cp -rf sample.war /var/lib/tomcat/webapps/

## Change permissions
chown tomcat:tomcat -R /var/lib/tomcat/webapps/*
sudo chmod 775 -R /var/lib/tomcat/webapps/
sudo chmod 775 -R /usr/share/tomcat/logs/

## Change default login and password for tomcat (use login "tomcat" and password "tomcat")
sudo tee /usr/share/tomcat/conf/tomcat-users.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users version="1.0" xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd">
  <role rolename="manager-gui"/>
  <role rolename="admin-gui"/>
  <role rolename="manager-script"/>
  <user username="tomcat" password="tomcat" roles="manager-gui,admin-gui,manager-script"/>
</tomcat-users>
EOF

## Enable and start servoces
sudo systemctl enable tomcat
sudo systemctl start tomcat

## Edit firewall rules
sudo ufw allow 8080, 80

## Remove downloaded files
sudo rm -f sample.war

#-------------------------------#
# Installation of logstash 		#
#-------------------------------#

## Download the gpg-key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

## Add repo
sudo tee /etc/yum.repos.d/logstash.repo  << EOF
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

## Install Logstash
sudo yum install -y logstash

## Config logstash
cat << EOF | sudo tee /etc/logstash/conf.d/logstash.conf
input {
	file {
		path => "/usr/share/tomcat/logs/*"
		start_position => "beginning"
		type => "tomcat_logs"
	}
}
output {
	elasticsearch {
		hosts => ["${IP}:9200"]
	}
	stdout { codec => rubydebug}
}
EOF
sudo tee /etc/logstash/logstash.yml << EOF
path.config: "/etc/logstash/conf.d/*.conf"
EOF

## Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable logstash
sudo systemctl start logstash
