#This is the ultimate Ansible Image for Network Automation on Cisco IOS
#This Dockerfile has all essential tools for Automation such as NAPALM and NTC-Ansible
#It is built to be used through iteractive bash mode
#Example of docker command to run:
#docker run -v /vagrant:/ansible --rm -p 2222:22 -p 9191:9191 --name ansible -it theknightcoder/ansible-networking bash

FROM ubuntu:16.04

RUN echo "===> Adding Ansible's PPA..."  && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main" | tee /etc/apt/sources.list.d/ansible.list           && \
    echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/ansible.list    && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367    && \
    DEBIAN_FRONTEND=noninteractive  apt-get update  && \
    \
    \
    echo "===> Installing Ansible..."  && \
    apt-get update -y                  && \
    apt-get upgrade -y                 && \
    apt-get install -y ansible         && \
    \
    \
    echo "===> Installing NAPALM and NTC-Ansible..."  && \
    apt-get install -y libssl-dev libjpeg8-dev           \ 
    libffi-dev python-dev python-cffi libxslt1-dev       \
    libssl-dev python-pip zlib1g-dev libxml2-dev         \
    libxslt-dev                                       && \
    pip install --upgrade pip                         && \
    pip install setuptools --upgrade                  && \
    pip install netmiko napalm ntc-ansible            && \  
    \
    \
    echo "===> Installing handy tools (optional)..."  && \
    pip install --upgrade pywinrm                     && \
    apt-get install -y sshpass openssh-client         && \
    apt-get install git iputils-ping -y               && \
    pip install openpyxl fasteners epdb               && \
    #
    #iputils-ping - allows you to ping
    #openpyxl - create/read excel files in python 
    #fasteners - lock file so it can only be written to one at a time (Ansible runs in parallel)
    #epdb - Help debug Ansible modules
    \
    \
    echo "===> Installing ara Ansible record report (optional)..."  && \
    pip install ara && \
    #run ara server (preferrable to use seperate container)
    #ara-manage runserver -h 0.0.0.0 -p 9191
    \
    \
    echo "===> Removing Ansible PPA..."                                && \
    rm -rf /var/lib/apt/lists/*  /etc/apt/sources.list.d/ansible.list  && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    echo 'localhost' > /etc/ansible/hosts

    
    
ENV ara_location "/usr/local/lib/python2.7/dist-packages/ara"
ENV ANSIBLE_CALLBACK_PLUGINS "${ara_location}/plugins/callbacks"
ENV ANSIBLE_ACTION_PLUGINS "${ara_location}/plugins/actions"
ENV ARA_DATABASE "sqlite:////ansible/db/ara.sqlite"
    
    
# ==> Copying Ansible playbook....
WORKDIR /ansible
CMD ["bash"]