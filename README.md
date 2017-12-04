Network Automation using Ansible
============================

The focus of this document is to explain the process of automating Cisco IOS network devices. I will take you through the fundamentals on Ansible and provide a user guide for this[Ansible-Networking Git repository](https://github.com/TheKnightCoder/Ansible-Networking).

The two main automation processes covered in this document are:
> - Adding/Replacing Config
> - Gathering facts/information on network devices

To understand the automation process it is important to have a brief understanding of the following libraries and frameworks:

Ansible's role in Network Automation
-----------------------------------------------------
![Ansible Logo](https://upload.wikimedia.org/wikipedia/commons/0/05/Ansible_Logo.png)

Ansible is an open source automation platform. It can help you with configuration management, application deployment, task automation and IT orchestration. For example it can install a software on hundreds of servers from a single control machine, it will not reinstall software if the same version is already installed and can make server specific configuration changes. It can also run IOS commands and config changes!

Think of Ansible as the distribution center, it will send a task to many devices from a central Ansible control machine. Ansible runs set of 'tasks' in a single 'playbook'.  A playbook is simple put a list of tasks along with some settings such as which machines to run the playbook on. A task is a command that should take place, such as create a new folder. Every task corresponds to a module, which is either in-built, community created or custom. Every module is written in the Python programming language, therefore you can run your own python code in ansible by creating a custom modules.

So if we break it down we are essentially running python code on multiple devices and Ansible is helping us do that, it is like the glue that sticks all the tools we use together.

For more information visit the [Ansible docs](http://docs.ansible.com/ansible/latest/intro_getting_started.html).

Also check out these video tutorials to gain a greater understanding of Ansible: 
	> - [Code Review Videos](https://www.codereviewvideos.com/course/ansible-tutorial) - (First 4 videos are just installation, it is recommended to use the installation guide below rather than the one in this video)
	> - [Ben's IT Lessons](https://www.youtube.com/watch?v=icR-df2Olm8&list=PLFiccIuLB0OiWh7cbryhCaGPoqjQ62NpU)

Templating with Jinja2
-------------------------------
Templating is the most important thing to know when implementing network automation, thankfully it is also the simplest. If the only thing you are interested in using network automation for is config changes then Jinja2 is all you need to know. 

An in-depth understanding of Ansible and Python is not needed for most config changes, however it can be useful when making more complex templates. An example of this is when you need to add storm control to every interface on multiple devices. One device may have 4 interfaces while the other has 7, and the interfaces may have different names such as Fa0/1 and Gi0/1. One way to solve this problem is to use a show command to dynamically get the list of interfaces and then apply the config to those interfaces, this will need comprehensive understanding of Ansible. A simpler solution to this problem would be to group the devices by model and manually list the interfaces for each group. This would require knowledge of the amount and names of each interface for each model in the network but would require no additional Ansible/Python.
N.B. This specific problem has been solved, see _X_ for more detail.
 
For more information visit the [Jinja2 docs](http://jinja.pocoo.org/docs/).

NAPALM
-------------
![NAPALM Logo](https://avatars0.githubusercontent.com/u/16415577?s=200&v=4)

NAPALM (Network Automation and Programmability Abstraction Layer with Multivendor support)
go through napalm
	how config replaced & diffs

For more information visit the [NAPALM repository](https://github.com/napalm-automation/napalm) and the [NAPALM Ansible repository](https://github.com/napalm-automation/napalm-ansible)

NTC-Ansible
-----------------
go through ntc ansible briefly 
note multiline problem
For more information visit the [NTC-Ansible repository](https://github.com/networktocode/ntc-ansible)

stup
Installation
Docker

Regex/TEXTFSM 