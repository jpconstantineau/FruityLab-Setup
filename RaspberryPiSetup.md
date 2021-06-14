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



There’s one more change that’s essential for k3s. Add the following to /boot/cmdline.txt, but make sure that you don’t add new lines.
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory


Copy or create an SSH key

on ansible master:
```
ssh-keygen
ssh-copy-id user@machinename
```

## Setup Ubuntu
## Networking

All nodes on the cluster will have a constant IP address done through DHCP IP Reservation.  On pfsense, this is done in the DHCP Leases page and adding a static mapping to the node.  This is best done one at a time so that it's clear which IP address is given to each node.



Change hostname
https://ittroubleshooter.in/change-remove-remote-hostname-using-ansible-playbook/

sudo sh -c 'echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf'


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

git clone https://github.com/jpconstantineau/MOTD.git
cd MOTD
sudo chown root:root *
sudo cp 10-display-name /etc/update-motd.d/
sudo cp 20-sysinfo /etc/update-motd.d/
sudo cp 51-kube-nodes /etc/update-motd.d/
sudo cp 52-kube-pods /etc/update-motd.d/

sudo rm /etc/update-motd.d/10-help-text
sudo rm /etc/update-motd.d/50-motd-news
sudo rm /etc/update-motd.d/88-esm-announce 
sudo rm /etc/update-motd.d/91-contract-ua-esm-status 

sudo update-motd


# no WIFI for the server
sudo systemctl disable wpa_supplicant.service



## Setup Ubuntu

refer [here](https://alexellisuk.medium.com/walk-through-install-kubernetes-to-your-raspberry-pi-in-15-minutes-84a8492dc95a/)

and [here](https://medium.com/icetek/building-a-kubernetes-cluster-on-raspberry-pi-running-ubuntu-server-8fc4edb30963) 



## Setup K3S
Run the k3s-ansible playbook