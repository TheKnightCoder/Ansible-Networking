# Dockerfile
 

# pull base image
FROM ubuntu:14.04

RUN echo "===> Adding Ansible's prerequisites..."   && \
    apt-get update -y            && \
    DEBIAN_FRONTEND=noninteractive  \
        apt-get install --no-install-recommends -y -q  \
                build-essential                        \
                python python-pip python-dev           \
                libxml2-dev libxslt1-dev zlib1g-dev    \
                git                                 && \
    pip install --upgrade setuptools pip wheel      && \
    pip install --upgrade pyyaml jinja2 pycrypto    && \
    pip install --upgrade pywinrm                   && \
    \
    \
    echo "===> Downloading Ansible's source tree..."            && \
    git clone git://github.com/ansible/ansible.git --recursive  && \
    \
    \
    echo "===> Compiling Ansible..."      && \
    cd ansible                            && \
    bash -c 'source ./hacking/env-setup'  && \
    \
    \
    echo "===> Moving useful Ansible stuff to /opt/ansible ..."  && \
    mkdir -p /opt/ansible                && \
    mv /ansible/bin   /opt/ansible/bin   && \
    mv /ansible/lib   /opt/ansible/lib   && \
    mv /ansible/docs  /opt/ansible/docs  && \
    rm -rf /ansible                      && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    apt-get install -y sshpass openssh-client  && \
    \
    \
    echo "===> Clean up..."                                         && \
    apt-get remove -y --auto-remove \
            build-essential python-pip python-dev git               && \
    apt-get clean                                                   && \
    rm -rf /var/lib/apt/lists/*                                     && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts


ENV PATH        /opt/ansible/bin:$PATH
ENV PYTHONPATH  /opt/ansible/lib:$PYTHONPATH
ENV MANPATH     /opt/ansible/docs/man:$MANPATH

#################################################
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
