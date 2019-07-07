#!/bin/bash

# Create an archive of the authorized_keys file
if [ ! -f "/home/vagrant/.ssh/authorized_keys.ori" ]; then
  sudo cp /home/vagrant/.ssh/authorized_keys /home/vagrant/.ssh/authorized_keys.ori
fi

# At each vagrant up or provision,
# copy the original authorized_keys file and save the expected key in
sudo cat /home/vagrant/.ssh/authorized_keys.ori > /home/vagrant/.ssh/authorized_keys
sudo cat /vagrant/certificates/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys