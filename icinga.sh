#!/bin/bash
# ICINGA INSTALLATION SCRIPT Ubuntu Server 16.04/14.04 LTS (AWS)
# Update the system
sudo apt-get update
sudo apt-get upgrade -y
# Install debconf to provide answers for icinga installation
sudo apt-get install -y debconf-utils
set -e -x
# Needed so that the aptitude/apt-get operations will not be interactive
export DEBIAN_FRONTEND=noninteractive
# Setting Internal fqdn value to a
a=`hostname --fqdn`
echo "postfix postfix/mailname string $a" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type select 'Local only'" | sudo debconf-set-selections
echo "icinga-cgi icinga/adminpassword password password" | sudo debconf-set-selections
echo "icinga-cgi icinga/adminpassword-repeat password password" | sudo debconf-set-selections
echo "icinga-common icinga/check_external_commands boolean false" | sudo debconf-set-selections
# 
sudo apt install -y icinga icinga-doc
#
echo "mysql-server-5.5 mysql-server/root_password password password" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password password" | sudo debconf-set-selections
#
sudo apt-get install -y mysql-server
#
echo "icinga-idoutils icinga-idoutils/database-type select mysql" | sudo debconf-set-selections
echo "icinga-idoutils icinga-idoutils/mysql/admin-pass password password" | sudo debconf-set-selections
echo "icinga-idoutils icinga-idoutils/mysql/app-pass password password" | sudo debconf-set-selections
echo "icinga-idoutils icinga-idoutils/app-password-confirm password password" | sudo debconf-set-selections
echo "icinga-idoutils icinga-idoutils/password-confirm password password" | sudo debconf-set-selections
echo "icinga-idoutils icinga-idoutils/dbconfig-install boolean true" | sudo debconf-set-selections
#
sudo apt-get install -y icinga-idoutils libdbd-mysql mysql-client
#
sudo usermod -a -G nagios www-data
sudo sed -ie 's/"IDO2DB=no"/"IDO2DB=yes"/g' /etc/default/icinga
# Starting the services
sudo service ido2db start && sudo service icinga start && sudo service apache2 start
# To view the current status of the process and services visit
# http://externalhostname/icinga  
# User Name = ‘icingaadmin’
# Password =  ‘password’
