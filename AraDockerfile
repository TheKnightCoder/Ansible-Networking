FROM python:2

LABEL Summary="ARA records Ansible Playbook runs and reports on Web browser"
LABEL URL="https://github.com/openstack/ara"

RUN pip install git+https://git.openstack.org/openstack/ara
CMD /usr/local/bin/ara-manage runserver -h 0.0.0.0 -p 9191
EXPOSE 9191