#!/bin/bash 

#-------------------------------#
# Installation of Elasticsearch	#
#-------------------------------#

## Download the gpg-key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

## Create repos
sudo tee /etc/yum.repos.d/elasticsearch.repo  << EOF
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

## Install elasticsearch
sudo yum install -y --enablerepo=elasticsearch elasticsearch 

## Configure elasticsearch
sudo tee -a /etc/elasticsearch/elasticsearch.yml <<EOF
network.host: 0.0.0.0
transport.host: localhost
EOF

#sudo sed -i "/bootstrap.memory_lock: true/s/#//"  /etc/elasticsearch/elasticsearch.yml
#sudo sed -i "s/http\.port.*$/http\.port: 9200/"  /etc/elasticsearch/elasticsearch.yml
#sudo sed -i"/MAX_LOCKED_MEMORY/s/MAX_LOCKED_MEMORY=.*$/MAX_LOCKED_MEMORY=unlimited/" /etc/sysconfig/elasticsearch

## Change firewall rules
sudo firewall-cmd --add-port=9200/tcp --permanent
sudo firewall-cmd --reload

## Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

#-------------------------------#
# Installation of Kibana 		#
#-------------------------------#

## Download gpg-key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

## Add repo
sudo tee /etc/yum.repos.d/kibana.repo << EOF
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

## Install kibana
sudo yum install -y kibana 

## Configure kibana
sudo sed -i "s/server\.port.*$/server\.port: 5601/" /etc/kibana/kibana.yml
sudo sed -i "s/network\.host.*$/network\.host: 0.0.0.0" /etc/kibana/kibana.yml
sudo sed -i "s/http\.port.*$/http\.port: 9200/" /etc/kibana/kibana.yml

sudo tee -a /etc/kibana/kibana.yml  <<EOF
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
EOF

## Change firewall rules
sudo firewall-cmd --add-port=5601/tcp --permanent
sudo firewall-cmd --reload

## Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana
