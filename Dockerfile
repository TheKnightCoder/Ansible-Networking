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

WORKDIR /ansible

#long line = napalm dependencies and ntc ansible from zlib1g
RUN echo "===> Installing ..."  && \
	apt-get update -y  &&  apt-get -y install  && \
    	sudo apt-get install git -y  && \
    	sudo apt-get install -y --force-yes libssl-dev libffi-dev python-dev python-cffi libxslt1-dev libssl-dev python-pip zlib1g-dev libxml2-dev libxslt-dev && \ 
    	pip install setuptools --upgrade && \
	pip install netmiko napalm ntc-ansible && \ 
	git clone https://github.com/napalm-automation/napalm-ansible.git /usr/share/ansible/napalm/ && \
	git clone  --recursive https://github.com/networktocode/ntc-ansible /usr/share/ansible/ntc-ansible/ && \
	pip install openpyxl fasteners

# ==> Copying Ansible playbook...

CMD ["bash"]
