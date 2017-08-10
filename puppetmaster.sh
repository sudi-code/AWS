#!/bin/bash
# RUN COMMANDS AS SUDO
sudo -i
# PUPPET INSTALLATION AND CONFIGRATION OF AMAZON LINUX TO DEPLOY INSTANCES FROM PUPPET MANIEFESTS
yum update -y
yum install puppet-server -y
# COLLECT HOST DETAILS
internalname="$(echo $HOSTNAME | awk -F'.' '{print $1}')"
fqdn="hostname -f"
# ADDING HOST SPECIFIC DETAILS TO PUPPET CONFIG
echo "dns_alt_names = $internalname,$fqdn" >> /etc/puppet/puppet.conf
echo "certname = $internalname" >> /etc/puppet/puppet.conf
# START PUPPET MASTER
systemctl start puppetmaster
systemctl status puppetmaster
# ENSURE PUPPET MASTER IS RUNNING
puppet resource service puppetmaster ensure=running
# GENERATE CA CERTS
puppet master --no-daemonize --verbose
puppet cert list --all
# INSTALL PUPPET AWS MODULE
puppet module install puppetlabs-aws
