# Steps to setup a Raspberry PI 4 with Ubuntu 20.x

# The Plan...

* Prepare SD Cards and SSD Drives for USB boot
* Prepare SSH Key
* Setup Ubuntu on each node
* Install K3S
* Other things...




## Flash the initial OS

Download the latest RaspiOS Lite ARM64 image from the Raspberry PI [download site](https://downloads.raspberrypi.org/raspios_lite_arm64/images/)

Using Raspberry PI imager, burn the image to your ssd or sd card.


  <img src="https://www.raspberrypi.org/homepage-9df4b/static/md-82e922d180736055661b2b9df176700c.png">

You need to select the image manually.  In my case, I used **2021-05-07-raspios-buster-arm64-lite.zip**

Note that this image does not havve ssh enabled.  you need to add an empty ssh file into the boot partition

## Setup the PI for USB Boot

If you have an older Raspberry PI 4, you need to update the bootloader to be able to boot from USB (SSD)

* Boot the Raspberry Pi with the USB Bootloder image and wait for at least 10 seconds.
* The green activity LED will blink with a steady pattern and the HDMI display will be green on success.
* Power off the Raspberry Pi and remove the SD card.

## Networking

All nodes on the cluster will have a constant IP address done through DHCP IP Reservation.  On pfsense, this is done in the DHCP Leases page and adding a static mapping to the node.  This is best done one at a time so that it's clear which IP address is given to each node.  These instructions assume the following inventory:

```
[picluster]
192.168.1.20 ansible_user=pi new_hostname=fruity-master1
192.168.1.21 ansible_user=pi new_hostname=fruity-worker1
192.168.1.22 ansible_user=pi new_hostname=fruity-worker2
192.168.1.23 ansible_user=pi new_hostname=fruity-worker3
```
The default hostname of the ubuntu image is `ubuntu`.  The Ansible setup playbook will rename the host to the `new_hostname` indicated in the inventory.

These have been defined in the `picluster` inventory file.

## forget old ssh keys if the cluster already existed 
You don't need to do this if this is the first time you create the cluster.  If you get an alarming message indicating tht someone may be impersonating the host, this may be simply because the image generated new keys and you simply need to "forget" the old ones...

```
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "192.168.1.20"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "192.168.1.21"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "192.168.1.22"
ssh-keygen -f "/home/pi/.ssh/known_hosts" -R "192.168.1.23"
```

## Login and change passwords:
Since the cards are freshly re-images with the raspios image, you need to first log in with the default credentials:

* user: pi
* password: raspberry

```
ssh pi@192.168.1.20
ssh pi@192.168.1.21
ssh pi@192.168.1.22
ssh pi@192.168.1.23
```

## Create an SSH key for Ansible to be able to log in.
You don't need to do this if it's already been done and have a key available.

Run this on Ansible master and follow the instrucions (I don't use a passphrase):
```
ssh-keygen
```

## copy ssh key to cluster
For Ansible to play nice and not need sudo passwords, you need to copy the ssh key from the Ansible master to each of the nodes.  Enter the "new" password you entered a few steps above.

```
ssh-copy-id pi@192.168.1.20
ssh-copy-id pi@192.168.1.21
ssh-copy-id pi@192.168.1.22
ssh-copy-id pi@192.168.1.23
```


## Setup Pi cluster (Ansible playbook)

An Ansible playbook was created to perform the following steps:

* update apt cache
* apt upgrade
* disable wifi
* disable ipv6
* rename hosts
* update message of the day (MOTD)
* setup poe fan curve
* reboot

How long the playbook takes will depend on the storage you have. SD cards will be slow. SSDs will be faster.  It will also depend on how many updates are needed.

```
ansible-playbook playbooks/setup_pi_cluster.yml -i inventory/production-cluster


```
If you run this playbook while `unattended-upgr` is still progressing, you might get a failure on the `apt upgrade` step.
If this is the case, just re-run te playbook and the failed host will go through all the steps.


## Setup k3s Cluster (Ansible playbook)

The k3s-ansible playbook assumes a basic configuration.  Swich over to the k3s-ha branch to make sure you can have HA (3 masters) configuration.
To run it, simply do this:

```bash
ansible-playbook k3s-ansible/site.yml -i inventory/production-cluster
```

## Complete post k3s steps

Once k3s is installed you need to get the kubeconfig file as well as setup some basic MOTD message for the master:

* add MOTD for kubectl get nodes
* add MOTD for kubectl get pods

Run this playbook:

```
ansible-playbook playbooks/setup_kubectl.yml -i inventory/production-cluster
```

## todo 

* handler: sudo update-motd
* sudo rm -rf /etc/cloud/ && sudo rm -rf /var/lib/cloud/
* sudo apt-mark hold snapd

kubectl run -i --tty authelia --image=authelia/authelia:latest -- authelia hash-password 'yourpassword'