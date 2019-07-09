# Certificates

## Real Time
If you work in production, regenerate the keys.

### Configuration
To change the hostname, open the `orchester.yaml` file and change the hostname variable.
If you change the orchester hostname, you will need to regenerate the id_rsa key.

``` yaml
# Do not forget,
# Don't change the - name: "orchester" -
# And no special characters, no space, no dash 
# or enderscore
box: "ubuntu/bionic64"
ip: 192.168.1.50
hostname: "my-orchester-hostname.mm" 
cpus: 1
memory : 1024
#
```

### Regenerate the id_rsa key
cd `/drupal-entreprise/certificates`
run `ssh-keygen -t rsa -C vagrant@my-orchester-hostname.mm`,

1. Choose the correct folder.
2. Leave empty the passphrase.

``` bash
tdb@tdb:/ansible-entreprise/certificates$ ssh-keygen -t rsa -C vagrant@my-orchester-hostname.mm
Generating public/private rsa key pair.
Enter file in which to save the key (/home/tdb/.ssh/id_rsa):
c/Users/tdb/Playground/ansible-entreprise/certificates/id_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in
c/Users/tdb/Playground/ansible-entreprise/certificates/id_rsa.
Your public key has been saved in
c/Users/tdb/Playground/ansible-entreprise/certificates/id_rsa.pub.
The key fingerprint is:
SHA256:n+m5Jc0FRHEiFtrchzzDbCL6PY58zaQe+16DnTkvcLs vagrant@my-orchester-hostname.mm
The key's randomart image is:
+---[RSA 2048]----+
|          +o=..  |
|         = B +   |
|        o + @ .  |
|       . . o =   |
|      . S     .  |
|       . o =o+.o |
|        . O==oB. |
|       . +oBo.o+ |
|        ooB+o Eo.|
+----[SHA256]-----+
```

At the end, the key must contain the `vagrant` user with the desired `hostname`.
```
ssh-rsa
AAAAB3NzaC1yc2EAAAADAQABAAABAQC0rvEnX8ihPXWWWz4U6ALlspBSsNLQA8qm1nC9ciKhik0iC
jEwZ6vgf2Xkah9UKDV197gy4jzbxIwxuNiJjP7xOL4qoErpRK8mgTxtGOUpjXc6k7mHfVWcSpAyUa
XYyd/uR+yGbjPfoSY6sl3wwN6d7QfVhNnuMJjLoLu7/vVyZ7aipKzKGyTvIFpDEsFruV7ox/o/
lDuw/hZwdzhkqesHH9wvS+rxaK/gFzXrAKeenATW+/K8w6FMX9vuFEbIN0/
e3vnzNck4YS8UrcmICnjb83EURa42Sx7+9n76t4QV3czMjH46YsOirwHMX9umzj9rHEge3g0m
+lDLU4POaEw9 vagrant@my-orchester-hostname.mm
```