# Ansible Entreprise Workflow

Env builded by trstndbrtl with [RevuesdeCode.com](http://revuesdecode.com)

## Prerequisites

- [VirtualBox](https://www.virtualbox.org/) >= 5.2
- [Vagrant](https://www.vagrantup.com/) >= 2.2.4
- vagrant-hostsupdater Plugin
- vagrant-vbguest Plugin
- [Cmder](https://cmder.net/)

## About
Deployed development environments with ansible.
This box gives the possibility to manage a site park with Ansible.

``` bash
C:\Users\tdb\Playground\Vagrant\ansible-entreprise
λ vagrant status
==> vagrant: installed version: 2.2.4
Current machine states:
orchester                 running (virtualbox)
production                running (virtualbox)
staging                   running (virtualbox)
develop                   running (virtualbox)
This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

## Ping machine
Run `vagrant ssh` or `vagrant ssh orckester` et launch `ansible all -m ping`
``` yaml
vagrant@orchester:~$ ansible all -m ping
development | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
production | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
staging | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

In fact, if it is the first time that you connect to the machines, you will have to log in, machine by machine to accept the ssh authentication of each machine. Indeed, in the case of the ping of three simultaneous machine, ansible returning the three answers at the same time, you will be able to accept only the first certificate and Ansible will send errors.
``` yaml
vagrant@orchester:~$ ansible idev -m ping
The authenticity of host 'develop (192.168.1.53)' can't be established.
ECDSA key fingerprint is SHA256:FTqG/pHCTaE2i0rsQpzOLzLJrTbk+iq2EsP/JP6uOLQ.
Are you sure you want to continue connecting (yes/no)? yes
develop | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
vagrant@orchester:~$ ansible istaging -m ping
The authenticity of host 'staging (192.168.1.52)' can't be established.
ECDSA key fingerprint is SHA256:nlfqS5gs5QOAZVAihXUQj3O2ncaJs3KS3htL7ucBwHc.
Are you sure you want to continue connecting (yes/no)? yes
staging | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
vagrant@orchester:~$ ansible iprod -m ping
The authenticity of host 'production (192.168.1.51)' can't be established.
ECDSA key fingerprint is SHA256:GxgCQJzQdWNm3C8RH49qrbk6o4p+gJag7LJOCXENed4.
Are you sure you want to continue connecting (yes/no)? yes
production | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
## What happens when I launch `vagrant up`.
See [ReadMe.md](/provision/README.md) provision forlder.

## What should I do if I change the hostname of the orchester
See [ReadMe.md](/certificates/README.md) certificates forlder.

## Add a new ENV
#### Add a local environment
1. Add environment declaration in `machines.yaml` file. Add `interne` option, register an ip, a hostname.
``` yaml
# Site development
# For the name
# no special characters, no space, no dash 
# or enderscore in name machine.
mattermost: # !!! same as 'name'
  name: "mattermost"
  type: "interne"
  group: "iprod"
  subgroup: "master"
  ip: 192.168.89.38
  hostname: "mattermost.mm"
  user : mdf
  box: "ubuntu/bionic64"
  cpus: 1
  memory : 1024
```

2. Create the folder of the shared files of the environment in the `sstm` (system) folder at the root of the project.
``` yaml
ANSIBLE-ENTREPRISE
λ tree ansible-entreprise
├───.vagrant
│   ├───machines
├───certificates
├───logs
├───provision
└───sstm
    ├───develop
    ├───orchester
    ├───production
    ├───staging
    └───mattermost
        └───www
            └───docroot
```

4. Run `vagrant up` or `vagrant reload`, followed by `--provision` flag, if necessary.



#### Add a remoted environment
1. Add environment declaration in `machines.yaml` file. Add `externe` option, register an ip, a hostname and the user name with which you will connect to the remote server.
``` yaml
# Site development
# For the name
# no special characters, no space, no dash 
# or enderscore in name machine.
creativ: # !!! same as 'name'
  name: "creativ"
  type: "externe"
  group: "iprod"
  subgroup: "master"
  ip: 192.168.89.67
  hostname: "my-remote-server.mm"
  user : tristan
  box: "ubuntu/bionic64"
  cpus: null
  memory : null
```

2. Then, copy your ssh key into the file of authorized_keys (~/.ssh/authorized_keys) of your remote server so you do not have to type your password for each ansible command. Be careful to create a personal and private ssh key if you connect to a remote server.
```
ssh-rsa
AAAAB3NzaC1yc2EAAAADAQABAAABAQC0rvEnX8ihPXWWWz4U6ALlspBSsNLQA8qm1nC9ciKhik0iC
jEwZ6vgf2Xkah9UKDV197gy4jzbxIwxuNiJjP7xOL4qoErpRK8mgTxtGOUpjXc6k7mHfVWcSpAyUa
XYyd/uR+yGbjPfoSY6sl3wwN6d7QfVhNnuMJjLoLu7/vVyZ7aipKzKGyTvIFpDEsFruV7ox/o/
lDuw/hZwdzhkqesHH9wvS+rxaK/gFzXrAKeenATW+/K8w6FMX9vuFEbIN0/
e3vnzNck4YS8UrcmICnjb83EURa42Sx7+9n76t4QV3czMjH46YsOirwHMX9umzj9rHEge3g0m
+lDLU4POaEw9 vagrant@orchester.mm
```

When building the machines, the ssh address of your remote server will be added to the ansible hosts file (/etc/ansible/hosts).
``` yaml
[idev]
192.168.89.40

[iprod]
192.168.89.38
tristan@my-remote-server.mm

[istag]
192.168.89.39                                                 
```