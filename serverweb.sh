#!/bin/bash

##ssh authentification
	sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
	sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
	sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	sudo service ssh restart

# Add User Jobs
	useradd userjob -d /home/userjob -s /bin/bash
	mkdir -p /home/userjob/
	chown userjob.userjob /home/userjob
	sudo echo -e "Mypass\nMypass\n" | passwd userjob
	sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa
	echo "userjob ALL=NOPASSWD: /usr/bin/apt-get" | sudo tee /etc/sudoers.d/userjob

	sudo apt update

# Installation Apache2, vérifier que Apache2 n est pas installer avant de lancee l'installation
	
	if ! dpkg -l |grep --quiet "ii.*apache2" ; then
		sudo apt -y install apache2
	fi

# Donner le droit lecture/ecriture pour le proprietère ainsi que le groupe www-data
# Pour verifier a laide de l commande ls +ld /var/www/html
	
	sudo chmod -R g+w /var/www/html
	sudo chown -Rv roor:www-data /var/www/html
	sudo chmod -R g+w /var/www/html
	
# création du fichier index.html
# sudo touch /var/www/html/index.html
	
	echo " !DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\">
			<html>
			<head>
			 <title>Ma première page avec du style</title>
			</head>
			<body>
			<!-- Menu de navigation du site -->
			<ul class=\"navbar\">
			 <li><a href=\"index.html\">Home page</a>
			</ul>
			<!-- Contenu principal -->
			<h1>Ma première page avec du style</h1>
			<p>Bienvenue sur ma page avec du style! 
			<p>Il lui manque des images, mais au moins, elle a du style. Et elle a des 
			liens, même s'ils ne mènent nulle part...
			Vanessa David Avril 2021&hellip;
			<p>Je devrais étayer, mais je ne sais comment encore.
			<!-- Signer et dater la page, c'est une question de politesse! -->
			<address>Fait le 22 avril 2021<br>
			 par moi.</address>
			</body>
			</html> " | sudo tee /var/www/html/index.html
			
# Installation Firewall UFW
	
	if ! dpkg -l |grep --quiet "ii.*ufw" ; then
		sudo apt-get -y install ufw
	fi
	
# configuration des ports 80 http et 443 https

	sudo ufw allow in 80/tcp
	sudo ufw allow in 443/tcp
	sudo ufw allow out 80/tcp
	sudo ufw allow out 443/tcp
	
# autoriser le trafic ssh 

	sudo ufw allow in 22/tcp
	sudo ufw allow out 25/tcp
	
# autoriser les connexions DNS

	sudo ufw allow out 53/udp
	
# protection des ports ouverts : autoriser 6 connexions ssh sur 30 sec

	sudo limit 22/tcp comment
	
# activer le Firewall

	sudo ufw --force enable
	
# verifier le statut du Firewall

	sudo ufw status verbose
#---------------------------------------------NFS----------------	
# Partie serveur NFS

## Installation SSH
	sudo apt-get install ssh

## Installation nfs-common
	
	sudo apt-get install -y nfs-common
	
## cree dossier de partage
	
	sudo mkdir -p /home/userjob/nfs_data_rw
	sudo chown root:root /home/userjob/nfs_data_rw
	sudo chmod -R g+w /home/userjob/nfs_data_rw
	
## Monterle fichier
	
	sudo mount -t nfs 192.168.0.28:/home/web  /var/www/html
	
## modifier le Fichier /etc/fstab
	
	
	sudo echo " 192.168.0.28:/home/web /var/www/html nfs _netdev,nodev,noexec 0 0 " >> /etc/fstab
	
	
