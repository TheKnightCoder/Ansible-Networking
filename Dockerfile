# Dockerfile

# ==> Choose a base image to emulate Linux distribution...
#FROM williamyeh/ansible:ubuntu16.04
FROM williamyeh/ansible:ubuntu14.04
#FROM williamyeh/ansible:ubuntu12.04
#FROM williamyeh/ansible:debian8
#FROM williamyeh/ansible:debian7
#FROM williamyeh/ansible:centos7
#FROM williamyeh/ansible:centos6
#FROM williamyeh/ansible:alpine3


# ==> Specify requirements filename;  default = "requirements.yml"
#ENV REQUIREMENTS  requirements.yml

# ==> Specify playbook filename;      default = "playbook.yml"
#ENV PLAYBOOK      playbook.yml

# ==> Specify inventory filename;     default = "/etc/ansible/hosts"
#ENV INVENTORY     inventory.ini

#long line = napalm dependencies and ntc ansible from zlib1g
RUN echo "===> Installing ..."  && \
	apt-get update -y  &&  apt-get install  && \
    sudo apt-get install git -y  && \
    sudo apt-get install -y --force-yes libssl-dev libffi-dev python-dev python-cffi libxslt1-dev libssl-dev python-pip zlib1g-dev libxml2-dev libxslt-dev && \ 
    pip install setuptools --upgrade && \
	pip install netmiko napalm ntc-ansible && \ 
	sudo apt-get -y install && \ 
	git clone https://github.com/napalm-automation/napalm-ansible.git /tmp/lib/napalm/ && \
	git clone  --recursive https://github.com/networktocode/ntc-ansible /tmp/lib/ntc-ansible/ && \
	if [ ! -f /tmp/ansible.cfg ]; then \
		echo "library = /tmp/library/" > ansible.cfg;  \
	fi \
