#!/bin/bash
# SCRIPT TO INSTALL PUPPET SERVER ON RHEL7
# Adding puppetrepo and installing the package
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
sudo yum update -y
sudo yum install puppetserver -y
# Collecting ec2-instance details#
internalname="$(echo $HOSTNAME | awk -F'.' '{print $1}')"
hostname=$HOSTNAME
# Adding ec2-instance details to the default configration file
echo "dns_alt_names = $internalname,$hostname" >> /etc/puppet/puppet.conf
echo "certname = $internalname" >> /etc/puppet/puppet.conf
# Start the service and check status
sudo systemctl start puppetserver
sudo systemctl status puppetserver
# Ensure puppetmaster service
puppet resource service puppetserver ensure=running
# Generate CA CERTS
puppet cert list --all
#Install puppet modules for creation of new nodes
puppet module install puppetlabs-aws
puppet gems install aws-sdk-core
