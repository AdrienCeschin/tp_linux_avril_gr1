#!/bin/bash
sudo apt install -y sshpass

# creation user
sudo useradd userjob -d /home/userjob -s /bin/bash
sudo mkdir -p /home/userjob/
sudo chown userjob.userjob /home/userjob
# creation mot de passe pour le user et connexion
echo -e "Mypass\nMypass\n" | sudo passwd userjob

## ssh to serverweb
sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa

sudo ssh-keyscan -H 192.168.0.29 >> /home/userjob/.ssh/known_hosts
sudo sshpass -p "Mypass" ssh-copy-id -i /home/userjob/.ssh/id_rsa.pub -o StrictHostKeyChecking=no userjob@192.168.0.29

## ssh to server jenkins
sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa

sudo ssh-keyscan -H 192.168.0.30 >> /home/userjob/.ssh/known_hosts
sudo sshpass -p "Mypass" ssh-copy-id -i /home/userjob/.ssh/id_rsa.pub -o StrictHostKeyChecking=no userjob@192.168.0.30

##ssh authentification
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart


	sudo apt update

# Install SSH

	sudo apt install ssh
	
# Installation nfs en tant que serveur , vérifier que nfs n est pas installer avant de lancer l'installation
	
	
	sudo apt install -y nfs-kernel-server nfs-common portmap
	
# Installation NFS cote client avec la commande : apt install nfs-common
# Creation du dossier de partage sous /var et donnee les droits pour l'utilisateur root
	
	sudo mkdir -p /home/web
	sudo mkdir -p /home/server_ic
	sudo chmod -R 755 /home/web
	sudo chmod -R 755 /home/server_ic
	
# ajouter une ligne sur /etc/exports

	sudo echo "/home/web 192.168.0.29(rw)" >>/etc/exports
	sudo echo "/home/server_ic 192.168.0.30(rw)" >>/etc/exports
	
	sleep 30
# redemmarage du service
 
	sudo /etc/init.d/nfs-kernel-server restart
 

