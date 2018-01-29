Ansible Networking
=================


<ul>
<li><a href="#network-automation-using-ansible">Network Automation using Ansible</a>
<ul>
<li><a href="#ansibles-role-in-network-automation">Ansible’s role in Network Automation</a></li>
<li><a href="#templating-with-jinja2">Templating with Jinja2</a></li>
<li><a href="#napalm">NAPALM</a></li>
<li><a href="#ntc-ansible">NTC-Ansible</a></li>
<li><a href="#regex--textfsm">Regex / TextFSM</a></li>
<li><a href="#ara-ansible-run-analysis">ARA: Ansible Run Analysis</a></li>
</ul>
</li>
<li><a href="#installation">Installation</a>
<ul>
<li><a href="#enable-virtualisation">Enable Virtualisation</a></li>
<li><a href="#install-virtual-box">Install Virtual Box</a></li>
<li><a href="#install-vagrant">Install Vagrant</a></li>
<li><a href="#running-vm--vagrant-file">Running VM / Vagrant File</a></li>
<li><a href="#startstop-vagrant-image">Start/Stop Vagrant image</a></li>
</ul>
</li>
<li><a href="#running-ansible">Running Ansible</a>
<ul>
<li><a href="#explaining-docker">Explaining Docker</a></li>
<li><a href="#running-ansible-docker-container">Running Ansible Docker Container</a></li>
</ul>
</li>
</ul>
 

Network Automation using Ansible
============================

The focus of this document is to explain the process of network automation for Cisco IOS devices. I will take you through the fundamentals of Ansible and provide a user guide for this [Ansible-Networking Git repository](https://github.com/TheKnightCoder/Ansible-Networking).

The two main automation processes covered in this document are:
> - Adding/Replacing Config
> - Gathering facts/information on network devices

To understand the automation process it is important to have a brief understanding of the following libraries and frameworks:

Ansible's role in Network Automation
----------------------------------------------
![Ansible Logo](https://upload.wikimedia.org/wikipedia/commons/0/05/Ansible_Logo.png)

Ansible is an open source automation platform. It can help you with configuration management, application deployment, task automation and IT orchestration. For example it can install a software on hundreds of servers from a single control machine, it will not reinstall software if the same version is already installed and can make server specific configuration changes. It can also run IOS commands and config changes!

Think of Ansible as the distribution center, it will send a task to many devices from a central Ansible control machine. Ansible runs tasks from a 'playbook'.  A playbook is simply put a list of tasks, along with some settings such as which machines to run the playbook on. A task is a command to be executed, such as creating a new folder. Every task corresponds to a module, which is either in-built, community created or custom. Every module is written in the Python programming language, therefore you can run your own python code in Ansible by creating a custom modules.

So if we break it down we are essentially running python code on multiple devices and Ansible is helping us do that, it is like the glue that sticks everything together.

As Cisco IOS devices cannot run python we set Ansible to run in 'local' connection mode and we access the IOS devices via SSH. The python code is run on the local machine and commands are sent and outputs to devices retrieved from the devices via SSH.

![1ansible_diagram](https://user-images.githubusercontent.com/24293640/33616163-0c3ff590-d9d4-11e7-95f4-19280b1c223c.png)

Watch these video tutorials to gain a greater understanding of Ansible: 
> - [Code Review Videos](https://www.codereviewvideos.com/course/ansible-tutorial) - (First 4 videos are just installation, it is recommended to use the installation guide below rather than the one in this video)
> - [Ben's IT Lessons](https://www.youtube.com/watch?v=icR-df2Olm8&list=PLFiccIuLB0OiWh7cbryhCaGPoqjQ62NpU)

For more information visit the [Ansible docs](http://docs.ansible.com/ansible/latest/intro_getting_started.html).

Templating with Jinja2
----------------------------
![Jinja2 Logo](http://jinja.pocoo.org/docs/2.10/_static/jinja-small.png)

Templating is the most important thing to know when automating network config, thankfully it can also be the simplest. 

A Jinja2 template is just a regular text file with a twist, it contains special notations which will be replaced with a variable. Jinja2 variables have the following notation `{{ foo }}`. When the template is processed to produce an output text file, it will replace all `{{ foo }}` with the actual 'foo' variable defined in Ansible. (foo may be replaced with any variable name).

A lot can be accomplished with the above information however Jinja2 is capable of much more with its ability to use for loops, if statements, filters and inheritance. The [Jinja2 documentation](http://jinja.pocoo.org/docs/2.10/) is very well written and can be used to learn how to implement these concepts.

An in-depth understanding of Ansible and Python is not needed for most config changes, however it can be useful when making more complex templates. An example of this is when you need to add config to every interface on multiple switches of varying models. One device may have 4 interfaces while the other has 7, and the interfaces may have different names such as Fa0/1 and Gi0/1. One way to solve this problem is to use a show command to dynamically get the list of interfaces and then apply the config to those interfaces, this will need comprehensive understanding of Ansible. A simpler solution to this problem would be to group the devices by model and manually list the interfaces for each group (in the group vars). This would require knowledge of the number and names of the interfaces for each model in the network but would require no additional Ansible/Python.

N.B. This specific problem has been solved, see _X_ for more detail.
 
For more information visit the [Jinja2 docs](http://jinja.pocoo.org/docs/).

NAPALM
------------
![NAPALM Logo](https://avatars0.githubusercontent.com/u/16415577?s=200&v=4)

NAPALM (Network Automation and Programmability Abstraction Layer with Multi-vendor support) is a Python library that implements a set of functions to interact with different network device Operating Systems using a unified API. By using NAPALM it makes it much easier to carry out tasks on network devices such as config replacement. NAPALM has Ansible modules which allows them to fully integrate.

In the Ansible Networking repository NAPALM is primarily used to install config by using the [napalm_install_config](https://github.com/napalm-automation/napalm-ansible/blob/develop/napalm_ansible/napalm_install_config.py) module. When NAPALM is used to replace/merge your config it is able to generate a diff file, this file will outline all changes that will be made on the devices which can then be verified and then committed. A backup is also automatically generated and stored in a offline location (and locally on network device) ensuring you are able to rollback changes.

NAPALM also has other useful modules. [napalm_get_facts](https://github.com/napalm-automation/napalm-ansible/blob/develop/napalm_ansible/napalm_get_facts.py) is a module that standardises the retrieval of information from network devices regardless of which vendor is being used. This means that the same code can be used and the structure of the output is known. To find out more about the information napalm_get_facts is capable of retrieving visit 'NetworkDevices' in the [docs](http://napalm.readthedocs.io/en/latest/base.html). Also see `Ansible-Networking\example-playbooks\reporting\napalm_get_facts.yml` playbook for an example of how to use 'napalm_get_facts' with Ansible.

Other useful NAPALM Modules:
- [napalm_ping](https://github.com/napalm-automation/napalm-ansible/blob/develop/napalm_ansible/napalm_ping.py) - Executes ping on the device and returns response using NAPALM
- [napalm_validate](https://github.com/napalm-automation/napalm-ansible/blob/develop/napalm_ansible/napalm_validate.py) - Validate deployments using YAML file describing the state you expect your devices to be in. See [Validating deployments docs](http://napalm.readthedocs.io/en/latest/validate/).
>Note that this is meant to validate state, meaning live data from the device, not the configuration. Because that something is configured doesn’t mean it looks as you want.

---Although the code in our repository has been designed for Cisco IOS, it can be adapted to work with other vendors by changing very little code thanks to NAPALM. 

This can be done by copying the `Ansible-Networking\lib\roles\ios` folder and adapting the code:
- Adapting the dev_os variable in `Ansible-Networking\lib\roles\ios\connect\defaults` (see [drivers names](http://napalm.readthedocs.io/en/latest/support/index.html) for supported devices) 
- Adapting ios\backup role `Ansible-Networking\lib\roles\ios\backup`
- Remove `configure archive` task in the ios\replace role.
- Changing any other IOS specific code

For more information visit the [NAPALM docs](https://napalm.readthedocs.io/en/latest/), [NAPALM repository](https://github.com/napalm-automation/napalm) and the [NAPALM Ansible repository](https://github.com/napalm-automation/napalm-ansible)

NTC-Ansible
----------------
NTC-Ansible is another library for network devices. This another library which supports IOS, Nexus and Arista. NTC-Ansible has useful modules for IOS such as outputting structured data for IOS specific show commands, copying files to the network device, updating firmware.

Useful NTC modules:
- ntc_show_command - gets structured data from devices that don't have an API
- ntc_install_os -  installs a new operating system or just sets boot options
- ntc_file_copy - copies a file from the Ansible control host to a network device.
- ntc_reboot - reboots a network device.

For more information visit the [NTC-Ansible repository](https://github.com/networktocode/ntc-ansible)

Regex / TextFSM
---------------------
Regular Expression (Regex) is another essential skill which is needed in network automation, it will give you the ability to format a 'show' command into something a computer can easily handle. Currently the Cisco IOS is built for human-readability however it is not very good for computers. For computers to be able to handle data it needs to be formatted in a way that is more appropriate such as csv, json, sql etc rather than a block of text. TextFSM will help you do just that, it will take a template file, and text input (such as command responses from the CLI of a device) and returns a list of records that contains the data parsed from the text. It is a python library which is integrated into Ansible. 
(NTC-Ansible ntc_show_commands also uses TextFSM to parse it's data.)

To create TextFSM templates you will need to know regex. This will give you the ability to parse any show command into Ansible. To learn regex I recommend watching these [videos tutorials by The Coding Train](https://www.youtube.com/watch?v=7DG3kCDx53c&list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w). The ntc_show_commands has a library of templates already written for IOS show commands. These templates can be found in `Ansible-Networking\lib\modules\ntc-ansible\ntc-templates\templates`

The ntc_show_command templates do not take into account text which spans over multiple lines in a CLI table. An example of this situation is when you have a very long hostname, which results in the initial portion of the hostname being cut off. This is a problem I faced with `show cdp neigbors`. 

![CLI table](https://user-images.githubusercontent.com/24293640/34607820-4551031e-f20d-11e7-88e7-0e89fa6b6254.png)

See section _X_ to see how a custom TextFSM templates were used to resolve this problem. Although this solution works for a span over 2 lines it may not work for more.

To learn more about regular expressions watch [The Coding Train Videos](https://www.youtube.com/watch?v=7DG3kCDx53c&list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w).

Also practice regular expressions at [regexr.com](https://regexr.com/). Make sure to turn on the multi-line flag as TextFSM uses multi-line regex.

ARA: Ansible Run Analysis
--------------------------------
![ARA Logo](https://github.com/openstack/ara/raw/master/doc/source/_static/ara-with-icon.png)

ARA records Ansible playbook runs and makes the recorded data available and intuitive for users and systems. ARA keeps a record of all playbook runs on a database. In this repository ARA has been set to save runs in a SQLite file located at `files/db/ara.sqlite`. SQLite is being used as it keeps ARA simple and portable, all data is stored in a file in the ansible folder and nothing is stored in the Docker containers or VM. 

If needed the ARA database can be changed to a centralized database by changing the ARA_DATABASE environment variable in both the ARA and Ansible containers.

![ARA screenshot](https://github.com/openstack/ara/raw/master/doc/source/_static/reports.png)

As you can see from the image above, ARA shows you a complete summary of playbooks that have been run. It gives you very useful information such as which hosts the playbook was run on, the time is took and whether the playbook was successful.

Installation
=========
Ansible only runs on linux and therefore you need a Virtual Machine (VM) if you are running Mac OSX or Windows. A VM is virtual operating system (OS) running on-top of your current OS, allowing you to run linux on Windows/OSX. This guide will assume you are running windows, if you are using Linux you will need to install docker and skip to X .

Enable Virtualisation
-------------------------
You must enable virtualisation to run Virtual Machine (VM). To do this you need to enable Intel VT-x and VT-d if available in the BIOS/UEFI. You may need to visit your system Administrator. 

1.  Turn on your computer and repeatedly press Delete, Esc, F1, F2, or F4. (Exact button depends on your PC model).
2. Find and enable Intel-VTx (The option may also be called VT-x, AMD-V, SVM, or Vanderpool).
3. If available enable Intel VT-d or AMD IOMMU

![virtualisation_bios](https://user-images.githubusercontent.com/24293640/33605215-a9727aaa-d9b0-11e7-8c28-987473d5b2ff.jpg)

Install Virtual Box
----------------------
Virtual Box is a free open-source software that allows you to run a virtual machine.  To install Virtual Box [download](https://www.virtualbox.org/wiki/Downloads) the 'Virtual box platform package', run the installer and keep hitting next until the installation is complete.

Install Vagrant
------------------
Vagrant is a tool for building and managing virtual machine environments in a single workflow. It will allow you to set up your virtual machine and install all the software packages with a single command  and the vagrant file found in this repository. By using vagrant we can ensure that all VMs using the same vagrant file is identical.

To install Vagrant [download](https://www.vagrantup.com/downloads.html) the installer, run the installer and keep hitting next until the installation is complete.

You will now need to reboot to complete the installation.

Running VM / Vagrant File
--------------------------------
1. Create a New Folder and rename it
	This is your Ansible folder, this will be where all your Ansible files are stored.
2. Download and extract the [repository](https://github.com/TheKnightCoder/Ansible-Networking/archive/master.zip) into the root of your Ansible folder.
>Make sure the actual files (vagrantfile etc.) are in the root of the Ansible folder.

3. Open command prompt and navigate to the Ansible folder's location
	- Win+R the type `cmd` then ok
	- Enter command `cd C:\Path\to\AnsibleFolder` (replace the path)
>Tip: You can `Shift + Right Click` in the file explorer and select `open command window here`
4. Type `vagrant up` to start the VM
> Note: The first time this is run the vagrant image will be downloaded and VM will be provisioned. This may take some time, it will be faster after initial launch. (Make sure you are on a network that can download the image) 
5. Type `vagrant ssh` to ssh into the VM and access it's shell
6. To exit SSH type `exit` 
7. To turn off the VM type `vagrant halt -f`
8. Synced Folders - Any files stored in the Ansible folder can be accessed by the VM via the path /vagrant

Start/Stop Vagrant image
-------------------------------
- Start VM - To start the VM you simply need to navigate to the Ansible folder and type `vagrant up`
- SSH - You can access the VM shell by entering `vagrant ssh` command. Type `exit` to exit ssh. You can ssh into the VM in multiple windows.
- Stop VM - To stop the VM either type `poweroff` from the SSH shell or `vagrant halt -f` from cmd Ansible folder.

Running Ansible
=============
To run Ansible I have created a Docker container with all the tools needed for network automation in this container. This has quite a few advantages over installing it directly onto the VM via vagrant such as being able to run network automation on any Linux machine and using less resources if multiple instances of Ansible is needed.

Watch this video on [Docker Containers](https://www.youtube.com/watch?v=pGYAg7TMmp0) to find out more about the differences between Docker and Vagrant.

Explaining Docker
----------------------
Docker is a resource friendly way to run applications in an isolated environment which is easily replicable across multiple machines. Vagrant VMs achieve a similar function however are much more resource heavy because each VM needs an entire OS. They also usually have more than one application per VM which causes instability.

![docker-vm-container](https://user-images.githubusercontent.com/24293640/33762832-02dabeca-dc06-11e7-8bde-c6be1fa530b8.png)

Docker File - A Docker file is the source code of the Docker image. It is very similar to a vagrant file and contains information on what packages to install when building the image. Once compiled it forms a Docker Image.
Docker Image - This image contains the actual packages etc that were defined in the Docker File.

Container - This is an instance of the docker image. You may have multiple containers of one image and any change in one container is not reflected in the next container.

Volume - This is the permanent storage for a container. Containers are meant to be destroyed and recreated and important  data should be kept in a volume. The volume can be accessed by the host machine and any other container that is linked to the volume. Volumes can be mapped to a specific directory on the host machine.

Port Forwarding - For the docker container to access ports on your machine you must map the ports. 

Note: This must also be define in your Vagrant file so that the VM can access your machine

In this setup we use a Vagrant Synced folder to map your Ansible folder to /vagrant. We will then map this /vagrant folder to the Docker Container using volumes resulting in a link between your machine and the Docker container.

See [this video](https://www.youtube.com/watch?v=pGYAg7TMmp0&index=1&list=PLoYCgNOIyGAAzevEST2qm2Xbe3aeLFvLc) from LearnCode.academy for a overview of docker.
For an in-depth guide on Docker see the many tutorials on YouTube.  

Running Ansible Docker Container
------------------------------------------
The Ansible networking repository has two containers that can be run. One is the container that runs Ansible itself, the source code for this container can be found in `Dockerfile`. The other is ARA web server which allows you to view a report of all Ansible playbooks that have run via the web browser, the source code for this container can be found in `ARADokcerfile`.

To run these two containers we will utilising the `docker-compose.yml` file which contains configuration for the containers such as ports and volumes.

Steps to run Ansible container:
1. SSH into vagrant VM (see [Running VM / Vagrant File](#running-vm--vagrant-file))
2. Enter the following command:
<pre>cd /vagrant && docker-compose run --service-ports -d --name ara --rm ara && docker-compose run --service-ports --rm ansible</pre>




- GNS3 as a test platform (optional)
- Host File
- host vars / group vars
- vars excel sheet
- TextFSM
- Jinja2 Templating
- Running test playbook
- Config Merge
- Config Replace
- Config Backup
- Config on interfaces / Dynamic Config
- Show Commands
- NAPALM Get Facts
- ntc_show_command 




