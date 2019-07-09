# Ansible Entreprise

## What happens when I launch `vagrant up`.
When I run a `vagrant up`, Vagrant builds the orchester with the ochester object of the `orchester.yml` file. It is from the orckerter that we will work with Ansible.
Here, it is possible to inform the vagrant image to use, the number of CPU or ram machine to use or the hostname.
If you wish to modify the hostname please take into consideration these [few observations](../certificates/README.md).

``` yaml
orchester:
  name: "orchester"
  box: "ubuntu/bionic64"
  ip: 192.168.1.50
  hostname: "server-machine.mm"
  cpus: 1
  memory : 1024
```

Then, Vagrant builds all the machines that have been entered, in the `machines.yaml`. There are only the machines declared as `internal` which are built in vagrant, the `external` machines are only controlled by the orchester.
``` yaml
production:
  name: "production"
  # 3 type of machine
  # off|interne|externe
  type: "interne"
  # Server group
  group: "iprod"
  # Server subgroup
  subgroup: "master"
  # Ip & Hostname
  ip: 192.168.89.38
  hostname: "production.mm"
  user : mdf
  # Configuration box
  box: "ubuntu/bionic64"
  cpus: 1
  memory : 1024
# Site staging
staging:
  name: "staging"
  type: "interne"
  group: "istag"
  subgroup: "drupal"
  ip: 192.168.89.39
  hostname: "staging.mm"
  user : mdf
  box: "ubuntu/bionic64"
  cpus: 1
  memory : 1024
# Site develop
develop:
  name: "develop"
  type: "interne"
  group: "idev"
  subgroup: "drupal"
  ip: 192.168.89.40
  hostname: "develop.mm"
  user : dev
  box: "ubuntu/bionic64"
  cpus: 1
  memory : 1024
```

During the time of the construction of the orchester and the machines, the Ansible host file was created and to inform with the information of each machine to recover in the file `machine.yaml`
This file is regenerated with each `vagrant up` or `vagrant provision`. To avoid losing personal configurations, an archive of the previous hosts file is made, please consult the `/sstm/orchester/etc/mm` folder, to recover your configuration after a build.

The /etc/ansible/hosts file after building machines looks like this.
``` yaml
[idev]
192.168.89.40

[iprod]
192.168.89.38

[istag]
192.168.89.39                                                 
```