#!/bin/bash 


#-------------------------------#
# Installation of java  		#
#-------------------------------#

sudo yum install -y java-1.8.0-openjdk

#-------------------------------#
# Installation of logstash 		#
#-------------------------------#

## Download the gpg-key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

## Add repo
cat << EOF > /etc/yum.repos.d/logstash.repo
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
sudo yum update -y
sudo yum install -y logstash

## Config logstash
cat << EOF > /etc/logstash/conf.d/logstash.conf
input {
  file {
    path => "/var/log/logstash/elk-users.log"
    start_position => "beginning"
  }
}
output {
  elasticsearch {
    hosts => ["localhost:9200"]
  }
  stdout { codec => rubydebug }
}
EOF

## Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable logstash
sudo systemctl start logstash


#-------------------------------#
# Installation of Elasticsearch	#
#-------------------------------#

## Download the gpg-key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

## Create repos
cat << EOF > /etc/zypp/repos.d/elasticsearch.repo
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


## Check key for elasticsearch
if [[ ! -f "/usr/share/elasticsearch/config/elasticsearch.keystore" ]]; then
	elasticsearch-keystore create
fi

#sudo sed -i "s/action\.auto_create_index/action\.auto_create_index: \.monitoring*,.watches,.triggered_watches,.watcher-history*,\.ml\*/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/network\.host.*$/network\.host: localhost/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/bootstrap.memory_lock: true/s/#//"  /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/http\.port.*$/http\.port: 9200/"  /etc/elasticsearch/elasticsearch.yml
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
cat << EOF > /etc/zypp/repos.d/kibana.repo
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


sudo sed -i "s/server\.port.*$/server\.port: 5601/" /etc/kibana/kibana.yml
sudo sed -i "s/server\.host.*$/server\.host: localhost/" /etc/kibana/kibana.yml
sudo sed -i "s/elasticsearch\.url.*$/elasticsearch\.url: "http:\/\/localhost:9200"/" /etc/kibana/kibana.yml

## Change firewall rules
sudo firewall-cmd --add-port=5601/tcp --permanent
sudo firewall-cmd --reload

## Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana