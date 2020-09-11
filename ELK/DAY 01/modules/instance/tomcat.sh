#!/bin/bash

## Install tomcat
sudo yum -y update && sudo yum install -y tomcat
sudo yum -y install tomcat-webapps tomcat-admin-webapps
sudo systemctl enable tomcat
sudo systemctl start tomcat
