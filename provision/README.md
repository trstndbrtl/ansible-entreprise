# Ansible Entreprise

## What happens when I launch `vagrant up`.
When I run a `vagrant up`, Vagrant builds the orchester with the ochester object of the `orchester.yml` file. It is from the orckerter that we will work with Ansible.

``` yaml
orchester:
  name: "orchester"
  box: "ubuntu/bionic64"
  ip: 192.168.1.50
  hostname: "server-machine.mm"
  cpus: 1
  memory : 1024
```

When the orchester is built, the ip and the hostname are filled in the hosts file of the orchester machine.
``` bash
C:\Users\tdb\Playground\Vagrant\ansible-entreprise
λ vagrant ssh
Welcome to Ubuntu 18.04.2 LTS (GNU/Linux 4.15.0-51-generic x86_64)
vagrant@server-machine:~$ cat /etc/hosts      
# ENV-START
192.168.1.53  develop.mm develop
192.168.1.52  staging.mm staging
192.168.1.51  production.mm production
192.168.1.50  orchester.mm orchester             
# ENV-END                                                    
```

Then, Vagrant builds all the machines that have been entered, in the `machines.yaml`. It is necessary to name the object as the environment.
``` yaml
# Site production
production:
  name: "production"
  group: "iproduction"
  box: "ubuntu/bionic64"
  ip: 192.168.1.51
  hostname: "machine.mm"
  cpus: 1
  memory : 1024
# Site staging
staging:
  name: "staging"
  group: "istaging"
  box: "ubuntu/bionic64"
  ip: 192.168.1.52
  hostname: "staging-machine.mm"
  cpus: 1
  memory : 1024
# Site development
development:
  name: "development"
  group: "idevelopment"
  box: "ubuntu/bionic64"
  ip: 192.168.1.53
  hostname: "dev-machine.mm"
  cpus: 1
  memory : 1024
```

To be built, an environment needs to be declared in the `deploy.yaml` file.
``` yaml
# environment to build
- production
- staging
- development
```