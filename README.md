# FruityLab-Setup

<h1 align="center">
  My home Kubernetes cluster
  <br />
  <br />
  <img src="https://i.imgur.com/p1RzXjQ.png">
</h1>
<br />
<div align="left">

---

# :book:&nbsp; Overview

Welcome to my Fruity Kubernetes cluster. This repo _is_ my Kubernetes cluster in a declarative state.  

[deployments](./deployments/)

---

## :wrench:&nbsp; Tools

_Below are some of the tools I find useful for working with my cluster_


---

## :computer:&nbsp; Hardware configuration

---

## Hardware

This cluster runs on the following hardware (all nodes are running Ubuntu 20.04):

| Device                                        | Count | SD Disk Size | SSD Disk Size        | Ram  | Purpose                                          |
|-----------------------------------------------|-------|--------------|----------------------|------|--------------------------------------------------|
| Raspberry PI 4 8Gb  & POE Hat                 | 1     | 32GB         | N/A                  | 8GB  | k3s Master                                       |
| Raspberry PI 4 8Gb  & POE Hat                 | 3     | 32GB         | N/A                  | 8GB  | k3s Worker                                       |
| TP-Link 5 Port Gigabit PoE Switch TL-SG1005P  | 1     | N/A          | N/A                  | N/A  | Switch/Power                                     |


---

## :handshake:&nbsp; Thanks

A lot of inspiration for this repo came from the following people:

- [onedr0p/k3s-gitops](https://github.com/onedr0p/k3s-gitops)


A few help links to setup my k3s cluster

nfs: setup nfs on storage [server](https://vitux.com/install-nfs-server-and-client-on-ubuntu/)

### To Do

* ~~Infrastructure: Longhorn~~
  * ~~Remove default for StorageClass: **kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'**~~
  * ~~Add labels to each node for automtic creation of~~ 
* ~~Infrastructure: MetalLB~~
* Infrastructure: Traefik
* Infrastructure: Authelia
* ~~Infrastructure: cert manager~~
* Application: Bitwarden/Vaultwarden
* Application: Heimdall
  * Move PV
* Application: Xen-Orchestra (xcg-ng) x86?
* Application: mosquitto (migration)
* Application: NodeRed (migration)
* Application: InfluxDB (migration)
* Application: Grafana (migration)
* Application: ESPHome (migration) x86?
* Application: Home assistant (migration?)


### Reverse SSH

Make sure that the sshd_conf file has 

```
 GatewayPorts yes
 ```
