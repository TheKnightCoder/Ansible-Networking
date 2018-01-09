#This vagrantfile is built to run Ansible via Docker
#and any other docker images required.

Vagrant.configure(2) do |config|
  config.vm.box = "alpine/alpine64" #Alpine is a lite VM 
  
  #Port forwarding for ARA Playbook Reporting access on via 127.0.0.1:9191
  config.vm.network "forwarded_port", guest: 9191, host: 9191
  
  #Docker installation
  config.vm.provision "shell", inline: "sudo apk update"
  config.vm.provision "shell", inline: "sudo apk add docker"
  config.vm.provision "shell", inline: "sudo rc-update add docker boot"
  config.vm.provision "shell", inline: "sudo service docker start"

  #Download latest Ansible-Networking Docker Image
  config.vm.provision "shell", inline: "sudo docker pull theknightcoder/ansible-networking"

  #Install Docker Compose
  config.vm.provision "shell", inline: "apk add py-pip"
  config.vm.provision "shell", inline: "pip install docker-compose"
  
  #These commands will run everytime a shell is started
  # 1. sudo su - become superuser
  # 2. cd /vagrant - cd to Ansible folder
  config.vm.provision "shell", inline: "echo 'sudo su' >> /home/vagrant/startup.sh"
  config.vm.provision "shell", inline: "echo 'cd /vagrant' >> /home/vagrant/startup.sh"
  config.vm.provision "shell", inline: "sudo echo '. /home/vagrant/startup.sh' >> /home/vagrant/.profile"  
end