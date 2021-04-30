#!/bin/bash

sudo apt-get update  
sudo apt-get -y install open-iscsi
sudo apt-get -y install lvm2
sudo apt-get -y install gnupg gnupg2 gnupg3

mkfs.ext4 /dev/sdb
mkdir -p /backup1
echo "/dev/sdb   /backup1  ext4   defaults    0   0">> /etc/fstab
mount /backup1

##ssh authentification
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart

useradd userjob -d /home/userjob -s /bin/bash
mkdir -p /home/userjob/
chown userjob.userjob /home/userjob
sudo echo -e "Mypass\nMypass\n" | passwd userjob
sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa 
echo "userjob  ALL=NOPASSWD: /usr/bin/apt-get" | sudo tee /etc/sudoers.d/userjob


## java for jenkins
sudo apt -y update
sudo apt -y install ca-certificates
sudo apt -y install openjdk-11-jdk
sudo apt -y install openjdk-11-jdk
#installer gnup
sudo apt -y install gnupg

## Jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
	
sudo apt-get update
sudo apt-get -y install jenkins
#
#start du service kenkins
sudo service jenkins start
# installation pare feu  iptables
sudo apt-get update
sudo apt-get install -y iptables
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install -y iptables-persistent

#ajout regle firewall
sudo iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables-save -f /etc/iptables/rules.v4

sleep 10

#==================Installation NFS===========================



sudo apt-get install ssh
sudo apt-get install -y nfs-common

# creation du dossier jenkins. Pas deja cree car pas encore de job sur le serveur.
sudo mkdir -p /usr/local/jenkins
sudo chmod -R 777 /usr/local/jenkins
sudo mount -t nfs 192.168.0.28:/home/server_ic /usr/local/jenkins
sudo echo "192.168.0.28:/home/server_ic /usr/local/jenkins nfs _netdev,nodev,noexec 0 0" >> /etc/fstab

#==============Fin de l'installation NFS========================

sudo cat /var/lib/jenkins/secrets/initialAdminPassword