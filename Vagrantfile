# -*- mode: ruby -*-
# vi: set ft=ruby :

# Check if is a window machine and
# Verify if vagrant-hostsupdater and vagrant-vbguest plugin are present
if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  required_plugins = %w( vagrant-hostsupdater vagrant-vbguest )
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end
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

# Array of environments to build
domains_machine = []

# Array of hosts to set
ansible_hosts = {}

# Here start multibox configurations
Vagrant.configure("2") do |config|

  # create folder for ansible hosts configuration
  FileUtils.mkdir_p("sstm/orchester/etc/mm/transfert")
  if !Dir.empty?('sstm/orchester/etc/mm/transfert')
    FileUtils.rm_rf(Dir['sstm/orchester/etc/mm/transfert/*']) 
  end

  # Parse Machine config file
  config_machines.each do |cm|
    # print sub_array
    cm.each do |domain_on|
      type_domain =  domain_on["type"]
      # check if internal type machine
      if !type_domain.nil? && !type_domain.empty? && type_domain == "interne"
        # If it's an internal domain,
        # add its machine name to the array of environments to build
        domains_machine.push(domain_on["name"])
      end
      # Build array hosts ansible
      if !type_domain.nil? && !type_domain.empty? && type_domain != "off"

        Dir.chdir("sstm/orchester/etc/mm/transfert") do
          # proces machine interne
          if type_domain == "interne"
            open("#{domain_on["group"]}", "a") do |f|
              f << "#{domain_on["ip"]}\n"
            end
          end
          # proces machine externe
          if type_domain == "externe"
            open("#{domain_on["group"]}", "a") do |f|
              f << "#{domain_on["user"]}@#{domain_on["ip"]}\n"
            end
          end

        end      
      end
    end
  end

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
    # Share /home/vagrant folder
    orchester.vm.synced_folder "./sstm/orchester/desktop/", "/home/vagrant/desktop", id: "home"
    # Share /var/www folder
    orchester.vm.synced_folder "./sstm/orchester/www", "/var/www", owner: "www-data", group: "www-data", id: "wwww"

    # IP allocation
    orchester.vm.network "private_network", ip: config_orchester['ip']
    # , virtualbox__intnet: true

    # Host name allocation
    orchester.vm.hostname = config_orchester['hostname']

    # Install Ansible and needed libraries
    orchester.vm.provision "Ansible", type: "shell" do |commons|
      commons.path = "provision/ansible.sh"
    end

  end

  # Here start config_machines builder
  domains_machine.each do |machine|
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
      mchn.vm.network "private_network", ip: "#{config_machines[machine]['ip']}"
      # , virtualbox__intnet: true

      # Host name machine allocation
      mchn.vm.hostname = "#{config_machines[machine]['hostname']}"

      # Share /var/www folder for each env
      mchn.vm.synced_folder "./sstm/#{config_machines[machine]['name']}/www", "/var/www", owner: "www-data", group: "www-data", id: "www"

      # Set ssh configuration
      mchn.vm.provision "Store key ssh", type: "shell", path: "provision/ssh.sh"

    end
  end
end
