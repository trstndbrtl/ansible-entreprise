#!/bin/bash

# Clean old log in /vagrant/logs/ folder
files=$(ls /vagrant/logs/*.log 2> /vagrant/logs/commons.log | wc -l)
if [ "$files" != "0" ]
then
rm -rf /vagrant/logs/*.log
fi

# Update Ubuntu and install lsb_release
sudo apt-get update >> /vagrant/logs/ubuntu.log 2>&1
sudo apt-get install lsb-core -y >> /vagrant/logs/lsb-core.log 2>&1
echo -e "$(lsb_release -a)"

# Install Ansible and followed libraries
sudo apt-get install software-properties-common -y >> /vagrant/logs/commons.log 2>&1
sudo apt-get install -y avahi-daemon libnss-mdns -y >> /vagrant/logs/commons.log 2>&1
sudo apt-add-repository ppa:ansible/ansible >> /vagrant/logs/ansible.log 2>&1
sudo apt-get update >> /vagrant/logs/ubuntu.log 2>&1
sudo apt-get install ansible -y >> /vagrant/logs/ansible.log 2>&1

# Copy orcherter ssh certificates
sudo cp -r /vagrant/certificates/id_rsa /home/vagrant/.ssh/id_rsa
sudo chmod 400 /home/vagrant/.ssh/id_rsa
sudo chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

# If not exist archive ansible hosts.ori file
if [ ! -f "/etc/ansible/hosts.ori" ]; then
    sudo mv /etc/ansible/hosts /etc/ansible/hosts.ori
    sudo cp /etc/ansible/hosts.mm /etc/ansible/hosts
fi