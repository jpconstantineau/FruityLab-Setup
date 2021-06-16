# Steps to setup a Raspberry PI 4 with Ubuntu 20.x

# The Plan...

* Prepare SD Cards and SSD Drives for USB boot
* Prepare SSH Key
* Setup Ubuntu on each node
* Install K3S
* Other things...




## Flash the initial OS

Using Raspberry PI imager, choose Ubuntu 20.04.2 LTS 64 bits (it's in the Other General Purpose OS menu).


  <img src="https://www.raspberrypi.org/homepage-9df4b/static/md-82e922d180736055661b2b9df176700c.png">

You will need to burn both a SD card and the SSD you want to boot from. (for some reason, you need to have both installed on the PI for it to boot wih Ubuntu 20.04.2 LTS 64 bit)

While you are at it, burn yourself an SD card with the bootloader update for USB boot.  In the next section, we will  change the boot order so that each node can boot from USB.
Follow the instructions [here](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md#imager)

## Setup the PI for USB Boot

* Boot the Raspberry Pi with the USB Bootloder image and wait for at least 10 seconds.
* The green activity LED will blink with a steady pattern and the HDMI display will be green on success.
* Power off the Raspberry Pi and remove the SD card.

## Networking

All nodes on the cluster will have a constant IP address done through DHCP IP Reservation.  On pfsense, this is done in the DHCP Leases page and adding a static mapping to the node.  This is best done one at a time so that it's clear which IP address is given to each node.  These instructions assume the following inventory:

```
[picluster]
192.168.1.20 ansible_user=ubuntu new_hostname=fruity-master1
192.168.1.21 ansible_user=ubuntu new_hostname=fruity-worker1
192.168.1.22 ansible_user=ubuntu new_hostname=fruity-worker2
192.168.1.23 ansible_user=ubuntu new_hostname=fruity-worker3
```
The default hostname of the image is `ubuntu`.  The Ansible setup playbook will rename the host to the `new_hostname` indicated in the inventory.

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
Since the cards are freshly re-images with the Ubutu image, you need to first log in with the default credentials:

* user: ubuntu
* password: ubuntu

```
ssh ubuntu@192.168.1.20
ssh ubuntu@192.168.1.21
ssh ubuntu@192.168.1.22
ssh ubuntu@192.168.1.23
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
ssh-copy-id ubuntu@192.168.1.20
ssh-copy-id ubuntu@192.168.1.21
ssh-copy-id ubuntu@192.168.1.22
ssh-copy-id ubuntu@192.168.1.23
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
ansible-playbook playbooks/setup_pi_cluster.yml -i inventory/picluster
```
If you run this playbook while `unattended-upgr` is still progressing, you might get a failure on the `apt upgrade` step.
If this is the case, just re-run te playbook and the failed host will go through all the steps.


## Setup k3s Cluster (Ansible playbook)

The k3s-ansible playbook assumes 



```bash
ansible-playbook k3s-ansible/site.yml -i inventory/picluster
```

## Complete post k3s steps

* add MOTD for kubectl get nodes
* add MOTD for kubectl get pods


## Setup Ubuntu



steps on ubuntu itself:

sudo apt update
sudo apt upgrade -y
sudo apt-get purge cloud-init
sudo rm -rf /etc/cloud/ && sudo rm -rf /var/lib/cloud/
sudo apt-get autoremove && apt-get autoclean



sudo apt autoremove --purge snapd gnome-software-plugin-snap
sudo rm -rf /var/cache/snapd/
rm -fr ~/snap

sudo apt-mark hold snapd
sudo apt install update-motd figlet

todo : handler:
sudo update-motd




## Setup Ubuntu

refer [here](https://alexellisuk.medium.com/walk-through-install-kubernetes-to-your-raspberry-pi-in-15-minutes-84a8492dc95a/)

and [here](https://medium.com/icetek/building-a-kubernetes-cluster-on-raspberry-pi-running-ubuntu-server-8fc4edb30963) 
