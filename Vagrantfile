# -*- mode: ruby -*-
# vi: set ft=ruby :

# Verify if vagrant-vbguest plugin is installed
unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'Install vagrant-hostsupdater with: vagrant plugin install vagrant-vbguest'
end

# Verify if vagrant-hostsupdater plugin is installed
unless Vagrant.has_plugin?("vagrant-hostsupdater")
  raise 'Install vagrant-hostsupdater with: vagrant plugin install vagrant-hostsupdater'
end

# Require YAML module
require 'yaml'

# store dirname
host_dir = File.dirname(File.expand_path(__FILE__))

# Box Orchester configurations
config_orchester_file = "#{host_dir}/orchester.yaml"
config_orchester = YAML.load_file(config_orchester_file)

# Box Machines configurations
config_machines_file = "#{host_dir}/machines.yaml"
config_machines = YAML.load_file(config_machines_file)

# Environment deployed
deployed_machines = "#{host_dir}/deploy.yaml"
list_deployed_machine = YAML.load_file(deployed_machines)

# For each env, store hosts configuration in an array
domains_machine = {}
list_deployed_machine.each do |domain|
  domains_machine[domain] = ["#{ config_machines[domain]['ip'] } #{ config_machines[domain]['hostname'] } #{ config_machines[domain]['name'] }"]
end

# Build pattern domain orchester host
host_orchester = "#{ config_orchester['ip'] } #{ config_orchester['hostname'] } orchester"

# Here start multibox configurations
Vagrant.configure("2") do |config|

  # Here start config_orchester builder
  config.vm.define "orchester" , primary: true do |orchester|

    # Box
    orchester.vm.box = config_orchester['box']

    # Memory and CPU allocation
    orchester.vm.provider "virtualbox" do |v|
      v.memory = config_orchester['memory']
      v.cpus = config_orchester['cpus']
    end

    # Share /etc/ansible folder
    orchester.vm.synced_folder "./sstm/orchester/etc/ansible", "/etc/ansible", owner: "root", group: "root", id: "ansible"

    # IP allocation
    orchester.vm.network "private_network", ip: config_orchester['ip'], virtualbox__intnet: "servernetwork01"

    # Host name allocation
    orchester.vm.hostname = config_orchester['hostname']

    # Install Ansible and needed libraries
    orchester.vm.provision "Ansible", type: "shell" do |commons|
      commons.path = "provision/ansible.sh"
      commons.args = host_orchester
    end

    # Store all domain environement in orchester /etc/hosts
    list_deployed_machine.each do |dmn|
      orchester.vm.provision "for-orchester-host-#{dmn}", type: "shell" do |domain|
        domain.path = "provision/hosts.sh"
        domain.args = domains_machine[dmn]
      end
    end

  end

  # Here start config_machines builder
  list_deployed_machine.each do |machine|
    # Set configuration
    config.vm.define "#{machine}" do |mchn|

      # Box
      mchn.vm.box = "#{config_machines[machine]['box']}"

      # Memory and CPU allocation
      mchn.vm.provider "virtualbox" do |v|
        v.memory = "#{config_machines[machine]['memory']}"
        v.cpus = "#{config_machines[machine]['cpus']}"
      end

      # Network
      mchn.vm.network "private_network", ip: "#{config_machines[machine]['ip']}", virtualbox__intnet: "servernetwork01"

      # Host name machine allocation
      mchn.vm.hostname = "#{config_machines[machine]['hostname']}"

      # Share /var/www folder for each env
      mchn.vm.synced_folder "./sstm/#{config_machines[machine]['name']}/www", "/var/www", owner: "www-data", group: "www-data", id: "www"

      # Set machine hosts configuration
      mchn.vm.provision "shell" do |commons|
        commons.path = "provision/hosts.sh"
        commons.args = domains_machine[machine]
      end

      # Set ssh configuration
      mchn.vm.provision "Store key ssh", type: "shell", path: "provision/ssh.sh"

    end
  end
end
