#This vagrantfile is built to run Ansible via Docker
#and any other docker images required.

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64" 
    
  #Port forwarding for ARA Playbook Reporting access on via 127.0.0.1:9191
  config.vm.network "forwarded_port", guest: 9191, host: 9191
  
  #Docker installation
  config.vm.provision "shell", inline: "sudo apt-get update && sudo apt-get -y upgrade"
  config.vm.provision "shell", inline: "sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual"
  config.vm.provision "shell", inline: "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common"
  config.vm.provision "shell", inline: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
  config.vm.provision "shell", inline: "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu trusty stable'"
  config.vm.provision "shell", inline: "sudo apt-get update"
  config.vm.provision "shell", inline: "sudo apt-get -y install docker-ce"
  
  
  #Download latest Ansible-Networking Docker Image
  config.vm.provision "shell", inline: "sudo docker pull theknightcoder/ansible-networking"

  #Install Docker Compose
  config.vm.provision "shell", inline: "sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose"
  config.vm.provision "shell", inline: "sudo chmod +x /usr/local/bin/docker-compose"
  
  #These commands will run everytime a shell is started
  # 1. sudo su - become superuser
  # 2. cd /vagrant - cd to Ansible folder
  
  config.vm.provision "shell", inline: "echo 'sudo su' >> /home/vagrant/startup.sh"
  config.vm.provision "shell", inline: "sudo echo '. /home/vagrant/startup.sh' >> /home/vagrant/.profile"
end