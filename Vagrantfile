# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :


#-------------- Serveur NFS



Vagrant.configure('2') do |config|



	config.vm.box_check_update = false

	config.vm.define "srvnfs" do |srvnfs|
		srvnfs.vm.box = "debian/buster64"
		srvnfs.vm.hostname = "srvnfs"
		srvnfs.vm.box_url = "debian/buster64"
		srvnfs.vm.network :public_network, ip: "192.168.0.28"
		
		srvnfs.vm.provider :virtualbox do |v|
			v.memory = '1000'
		end
		
		srvnfs.vm.provision "shell", inline: <<-SHELL
		echo "192.168.0.29 srvweb" >> /etc/hosts
		echo "192.168.0.30 srvjenkins" >> /etc/hosts
		SHELL
		
		#srvnfs.vm.provision "shell", inline: <<-SHELL
		#echo "192.168.0.30 srvjenkins" >> /etc/hosts
		#SHELL
		
		srvnfs.vm.provision 'shell', path: 'nfs2.sh'
	end


end


#-------------- Serveur Web



Vagrant.configure('2') do |config|



	config.vm.box_check_update = false

	config.vm.define "srvweb" do |machine|
		machine.vm.box = "debian/buster64"
		machine.vm.hostname = "srvweb"
		machine.vm.box_url = "debian/buster64"
		machine.vm.network :public_network, ip: "192.168.0.29"
		
		machine.vm.provider :virtualbox do |v|
			v.memory = '1000'
		end
		
		machine.vm.provision 'shell', path: 'serverweb.sh'
	end


end


Vagrant.configure('2') do |config|

#------------------ Serveur Jenkins  
    # config.vm.box = "puppetlabs/debian-7.8-64-puppet"
    config.vm.box_check_update = false
        #config.vm.network "public_network", ip: "192.168.0.20"
                # Mettre en place un cache pour APT
                # config.vm.synced_folder 'v-cache', '/var/cache/apt'
                config.vm.define 'srvjenkins' do |machine|
				    machine.vm.box = 'debian/buster64'
                    machine.vm.hostname = 'srvjenkins'
                    machine.vm.network :public_network, ip: "192.168.0.30"
                    machine.vm.provider 'virtualbox' do |vb|
						vb.memory = '1000'
						# UNCOMMENT FOR MORE DISKS
						disk2_vdi = 'disk2.vdi'
						# Creer les fichiers au bon format pour VBox s'ils n'existent pas
						unless File.exist?(disk2_vdi)
						vb.customize ['createhd', '--filename', disk2_vdi, '--size', 20 * 1024]
                        end
        
				    # On attache les fichiers 'disque' sur la VM
				    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller','--port', 1, '--device', 0, '--type', 'hdd', '--medium',disk2_vdi]
				    end
	            config.vm.provision 'shell', path: 'provision_jenkins.sh'
                #config.vm.provision "shell", inline: <<-SHELL
                #  sudo cat /var/jenkins_home/secrets/initialAdminPassword
                #SHELL
                end
 end
 
	
#-------------- Serveur Dev1
 Vagrant.configure('2') do |config|

   config.vm.box_check_update = false
	config.vm.define "srvdev1" do |srvdev|
		srvdev.vm.box = "debian/buster64"
		srvdev.vm.hostname = "srvdev1"
		srvdev.vm.box_url = "debian/buster64"
		srvdev.vm.network :public_network, ip: "192.168.0.31"
		srvdev.vm.provider :virtualbox do |v|
		   v.memory = '512'
		   # On autorise la virtualisation imbriquée pour pouvoir lancer une vm vagrant sur le poste de dev
		   v.customize ['modifyvm',:id,'--nested-hw-virt','on']
		end
		
		srvdev.vm.provision "shell", inline: <<-SHELL
		echo "192.168.0.29 srvweb" >> /etc/hosts
		echo "192.168.0.30 srvjenkins" >> /etc/hosts
		SHELL
	    srvdev.vm.provision 'shell', path: 'poste_dev.sh'
	end
	
end
	
	
#-------------- Serveur Dev2

Vagrant.configure('2') do |config|

    config.vm.box_check_update = false
	
	config.vm.define "srvdev2" do |srvdev|
    srvdev.vm.box = "debian/buster64"
    srvdev.vm.hostname = "srvdev2"
    srvdev.vm.box_url = "debian/buster64"
    srvdev.vm.network :public_network, ip: "192.168.0.32"
    srvdev.vm.provider :virtualbox do |v|
      v.memory = '512'
	  # On autorise la virtualisation imbriquée pour pouvoir lancer une vm vagrant sur le poste de dev
	  v.customize ['modifyvm',:id,'--nested-hw-virt','on']
    end
    srvdev.vm.provision "shell", inline: <<-SHELL
	echo "192.168.0.29 srvweb" >> /etc/hosts
    echo "192.168.0.30 srvjenkins" >> /etc/hosts
    SHELL
    srvdev.vm.provision 'shell', path: 'poste_dev.sh'
  end
  
  
end


#-------------- Serveur Dev3

Vagrant.configure('2') do |config|

    config.vm.box_check_update = false
	
	config.vm.define "srvdev3" do |srvdev|
    srvdev.vm.box = "debian/buster64"
    srvdev.vm.hostname = "srvdev3"
    srvdev.vm.box_url = "debian/buster64"
    srvdev.vm.network :public_network, ip: "192.168.0.33"
    srvdev.vm.provider :virtualbox do |v|
      v.memory = '512'
	  # On autorise la virtualisation imbriquée pour pouvoir lancer une vm vagrant sur le poste de dev
	  v.customize ['modifyvm',:id,'--nested-hw-virt','on']
    end
    srvdev.vm.provision "shell", inline: <<-SHELL
	echo "192.168.0.29 srvweb" >> /etc/hosts
    echo "192.168.0.30 srvjenkins" >> /etc/hosts
    SHELL
    srvdev.vm.provision 'shell', path: 'poste_dev.sh'
  end
  
  
end

