#!/bin/bash

#######################################
# Bash script to install an Apache Solr in Ubuntu
# Solr Version: 6.6.5
# Author: Subhash (serverkaka.com)

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check port 8983 is Free or Not
netstat -ln | grep ":8983 " 2>&1 > /dev/null
if [ $? -eq 1 ]; then
     echo go ahead
else
     echo Port 8983 is allready used
     exit 1
fi

# Update System
sudo apt-get update

# Install Java if not allready Installed
if java -version | grep -q "java version" ; then
  echo "Java Installed"
else
  sudo add-apt-repository ppa:webupd8team/java -y  && sudo apt-get update -y  && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections && sudo apt-get install oracle-java8-installer -y && echo JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/environment && echo JRE_HOME=/usr/lib/jvm/java-8-oracle/jre >> /etc/environment && source /etc/environment
fi

# Installing the Solr application
cd /tmp
wget http://www.us.apache.org/dist/lucene/solr/6.6.5/solr-6.6.5.tgz

# extract the service installation file
tar xzf solr-6.6.5.tgz solr-6.6.5/bin/install_solr_service.sh --strip-components=2

# install Solr as a service
sudo ./install_solr_service.sh solr-6.6.5.tgz

# Set Service as startup
service solr enable

# Adjust the Firewall
ufw allow 8083/tcp

# Creating a Solr search collection (Core)
sudo su - solr -c "/opt/solr/bin/solr create -c gettingstarted -n data_driven_schema_configs"

echo "Apache Solr is successfully installed, For Aceess Solr Go to http://localhost:8983/solr/
echo "you can start and stop solr using command : sudo service solr stop|start|status|restart"
