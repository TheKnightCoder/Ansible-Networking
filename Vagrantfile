# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "alpine/alpine64"
  config.vm.provision "shell", inline: "sudo apk update"
  config.vm.provision "shell", inline: "sudo apk add docker"
  config.vm.provision "shell", inline: "sudo rc-update add docker boot"
  config.vm.provision "shell", inline: "sudo service docker start"
  config.vm.provision "shell", inline: "sudo docker pull theknightcoder/ansible-networking"
  config.vm.provision "shell", inline: "echo 'sudo su' >> /home/vagrant/start-ansible.sh"
  config.vm.provision "shell", inline: "echo 'cd /vagrant' >> /home/vagrant/start-ansible.sh"
  #docker run -v /vagrant:/ansible --rm -p 2222:22 -it theknightcoder/ansible-networking bash' >> /home/vagrant/start-ansible.sh"
  config.vm.provision "shell", inline: "sudo echo '. /home/vagrant/start-ansible.sh' >> /home/vagrant/.profile"  
end