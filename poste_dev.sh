#!/bin/bash


#### Basic installations
# install python and git
sudo apt -y install python3 python3-pip python3-dev git

# install vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sleep 20
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sleep 20
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sleep 20
sudo apt install apt-transport-https
sleep 30
sudo apt update
sleep 20
sudo apt -y install code
rm packages.microsoft.gpg



#### Manage the ssh key part
sudo apt install -y sshpass

# Create a user and manage its rights
sudo useradd userjob -d /home/userjob -s /bin/bash
mkdir /home/userjob/
sudo chown userjob.userjob /home/userjob

echo -e "Mypass\nMypass\n" | passwd userjob

### ssh to web server
# Generate ssh key and manages it
sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa 

sudo ssh-keyscan -H 192.168.0.29 >> /home/userjob/.ssh/known_hosts
sudo sshpass -p "Mypass" ssh-copy-id -i /home/userjob/.ssh/id_rsa.pub -o StrictHostKeyChecking=no userjob@192.168.0.29

### ssh to jenkins server
# Generate ssh key and manages it
sudo -u userjob ssh-keygen -t rsa -b 2048 -f /home/userjob/.ssh/id_rsa 

sudo ssh-keyscan -H 192.168.0.30 >> /home/userjob/.ssh/known_hosts
sudo sshpass -p "Mypass" ssh-copy-id -i /home/userjob/.ssh/id_rsa.pub -o StrictHostKeyChecking=no userjob@192.168.0.30


##ssh authentification
 sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
 sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
 sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
 sudo service ssh restart


#### Manage Vagrant part
# install vagrant
curl -O https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb
sudo apt update
sudo apt install ./vagrant_2.2.16_x86_64.deb
rm vagrant_2.2.16_x86_64.deb

# install libvirt to run vagrant/2
# sudo apt -y install qemu libvirt-daemon-system libvirt-clients libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base qemu-utils qemu-system-x86
# vagrant plugin install vagrant-libvirt
# vagrant plugin install vagrant-mutate

# import bento/ubuntu-20.10 vagrant box and convert it to run with libvirt
# vagrant box add --provider virtualbox bento/ubuntu-20.10
# vagrant mutate bento/ubuntu-20.10 libvirt

# clone repository
cd /home/vagrant/
git clone https://github.com/vanessakovalsky/example-python.git

# on ne peut pas tester le main.py dans la vm vagrant. Mais on peut tester l'installation de python3.
cd example-python
cd vagrant
python3 main.py
