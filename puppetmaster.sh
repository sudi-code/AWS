#!/bin/bash
# PUPPET INSTALLATION AND CONFIGRATION OF AMAZON LINUX TO DEPLOY INSTANCES FROM PUPPET MANIEFESTS
sudo yum update -y
sudo yum install puppet-server -y
# COLLECT HOST DETAILS
sudo -i
internalname="$(echo $HOSTNAME | awk -F'.' '{print $1}')"
# ADDING HOST SPECIFIC DETAILS TO PUPPET CONFIG
echo "dns_alt_names = $internalname,$HOSTNAME" >> /etc/puppet/puppet.conf
echo "certname = $internalname" >> /etc/puppet/puppet.conf
exit
# START PUPPET MASTER
sudo systemctl start puppetmaster
sudo systemctl status puppetmaster
# ENSURE PUPPET MASTER IS RUNNING
sudo puppet resource service puppetmaster ensure=running
# GENERATE CA CERTS
sudo -u puppet master --no-daemonize --verbose
sudo puppet cert list --all
# INSTALL PUPPET AWS MODULE
sudo puppet module install puppetlabs-aws
