Network Automation using Ansible
============================



<div class="toc">*   [Network Automation using Ansible](#network-automation-using-ansible)*   [Ansible’s role in Network Automation](#ansibles-role-in-network-automation)
    *   [Templating with Jinja2](#templating-with-jinja2)
    *   [NAPALM](#napalm)
    *   [NTC-Ansible](#ntc-ansible)
    *   [Regex / TextFSM](#regex-textfsm)
*   [Installation](#installation)*   [Enable Virtualisation](#enable-virtualisation)
    *   [Install Virtual Box](#install-virtual-box)
    *   [Install Vagrant](#install-vagrant)

</div>

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

So if we break it down we are essentially running python code on multiple devices and Ansible is helping us do that, it is like the glue that sticks everything together.

Also check out these video tutorials to gain a greater understanding of Ansible: 
> - [Code Review Videos](https://www.codereviewvideos.com/course/ansible-tutorial) - (First 4 videos are just installation, it is recommended to use the installation guide below rather than the one in this video)
> - [Ben's IT Lessons](https://www.youtube.com/watch?v=icR-df2Olm8&list=PLFiccIuLB0OiWh7cbryhCaGPoqjQ62NpU)

For more information visit the [Ansible docs](http://docs.ansible.com/ansible/latest/intro_getting_started.html).

Templating with Jinja2
-------------------------------
![Jinja2 Logo](http://jinja.pocoo.org/docs/2.10/_static/jinja-small.png)

Templating is the most important thing to know when implementing network automation, thankfully it can also be the simplest. If the only thing that interests you is config changes then Jinja2 is all you need to know. 

A Jinja2 template is a regular text file with a twist, it contains special notations which will replace the block with a variable. Jinja2 variables have the following notation `{{ foo }}`. When the template is processed to produce an output text file, it will replace all `{{ foo }}` with the actual 'foo' variable defined in Ansible. (foo may be replaced with any variable name).

A lot can be accomplished with the above information however Jinja2 is capable of much more with its ability to use for loops, if statements, filters and inheritance. The [Jinja2 documentation](http://jinja.pocoo.org/docs/2.10/) is very well written and can be used to learn how to implement these concepts

An in-depth understanding of Ansible and Python is not needed for most config changes, however it can be useful when making more complex templates. An example of this is when you need to add storm control to every interface on multiple switches. One device may have 4 interfaces while the other has 7, and the interfaces may have different names such as Fa0/1 and Gi0/1. One way to solve this problem is to use a show command to dynamically get the list of interfaces and then apply the config to those interfaces, this will need comprehensive understanding of Ansible. A simpler solution to this problem would be to group the devices by model and manually list the interfaces for each group (in the group vars). This would require knowledge of the number and names of the interfaces for each model in the network but would require no additional Ansible/Python.
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

Regex / TextFSM
-------------------------
Regular Expression (Regex) is another essential skill which is needed in network automation, it will give you the ability to format a 'show' command into something a computer can easily handle. Currently the Cisco IOS is built for human-readability however it is not very good for computers. For computers to be able to handle data it needs to be formatted in a way that is more appropriate such as csv, json, sql etc rather than a block of text. TextFSM will help you do just that, TextFSM will help you format blocks of text. It is a python library which is also integrated into Ansible and also the method NTC-Ansible ntc_show_commands parse it's data.

TextFSM parses data is using regex, you will need to know regex to create TextFSM templates so that you parse any show command. To learn regex I recommend watching these [YouTube videos](https://www.youtube.com/watch?v=7DG3kCDx53c&list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w) by The Coding Train. The ntc_show_commands has many templates already written for IOS show commands.

The ntc_show_command templates do not take into account text which spans over multiple lines in a CLI table. An example of this situation is when you have a very long hostname, which results in the initial portion of the hostname being cut off. This is a problem I faced with `show cdp neigbors`. 

![CLI table](https://user-images.githubusercontent.com/24293640/33603702-5f0f8cf0-d9ab-11e7-9d32-bbd03ff0b7c0.png)

See section _X_ to see how a custom template was used to resolve this problem. Although this solution works for a span over 2 lines it may not work for more.

To learn more about regular expressions watch [The Coding Train Videos](https://www.youtube.com/watch?v=7DG3kCDx53c&list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w) 

Also practice regular expressions at [regexr.com](https://regexr.com/). Make sure to turn on the multi-line flag as TextFSM uses multi-line regex.


----------

Installation
=========
Ansible only runs on linux and therefore needs Virtual Machine (VM) if you are running Mac OSX or Windows. A VM is second virtual operating system (OS) running on-top of your current OS. This guide will assume you are running windows, if you are using Linux you will need to install docker and skip to X .

Enable Virtualisation
-----------------------------
You must enable virtualisation to run Virtual Machine (VM). To do this you need to enable Intel VT-x and VT-d if available in the BIOS/UEFI. You may need to visit your system Administrator. 

1.  Turn on your computer and repeatedly press Delete, Esc, F1, F2, or F4. (Exact button depends on the model).
2. Find and enable Intel-VTx (The option may also be called VT-x, AMD-V, SVM, or Vanderpool).
3. If available enable Intel VT-d or AMD IOMMU

![virtualisation_bios](https://user-images.githubusercontent.com/24293640/33605215-a9727aaa-d9b0-11e7-8c28-987473d5b2ff.jpg)

See [this guide](http://bce.berkeley.edu/enabling-virtualization-in-your-pc-bios.html) detailing the steps on enabling virtualisation.

Install Virtual Box
--------------------------
Virtual Box is a free open-source software that allows you to run a virtual machine.  To install Virtual Box [download](https://www.virtualbox.org/wiki/Downloads) the ['Virtual box platform package'](https://www.virtualbox.org/wiki/Downloads), run the installer and keep hitting next until the installation is complete.

Install Vagrant
--------------------
Vagrant is a tool for building and managing virtual machine environments in a single workflow. It will allow you to set up your virtual machine and install all the software packages with a single command `vagrant up` and the vagrant file found in this repository. 

 To install Vagrant [download](https://www.vagrantup.com/downloads.html) the [installer](https://www.vagrantup.com/downloads.html), run the installer and keep hitting next until the installation is complete.

You will now need to reboot to complete the installation.
