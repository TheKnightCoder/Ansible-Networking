<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ansible Networking</title>
  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__left">
    <div class="stackedit__toc">
      
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
</ul>
</li>
</ul>

    </div>
  </div>
  <div class="stackedit__right">
    <div class="stackedit__html">
      <h1 id="network-automation-using-ansible">Network Automation using Ansible</h1>
<p>[TOC]</p>
<ul>
<li><a href="#network-automation-using-ansible">Network Automation using Ansible</a>
<ul>
<li><a href="#ansibles-role-in-network-automation">Ansible’s role in Network Automation</a></li>
<li><a href="#templating-with-jinja2">Templating with Jinja2</a></li>
<li><a href="#napalm">NAPALM</a></li>
<li><a href="#ntc-ansible">NTC-Ansible</a></li>
<li><a href="#regex-textfsm">Regex / TextFSM</a></li>
</ul>
</li>
<li><a href="#installation">Installation</a>
<ul>
<li><a href="#enable-virtualisation">Enable Virtualisation</a></li>
<li><a href="#install-virtual-box">Install Virtual Box</a></li>
<li><a href="#install-vagrant">Install Vagrant</a></li>
<li><a href="#running-vm-vagrant-file">Running VM / Vagrant File</a></li>
<li><a href="#startstop-vagrant-image">Start/Stop Vagrant image</a></li>
</ul>
</li>
<li><a href="#running-ansible">Running Ansible</a>
<ul>
<li><a href="#explaining-docker">Explaining Docker</a></li>
</ul>
</li>
</ul>
<p>The focus of this document is to explain the process of network automation for Cisco IOS devices. I will take you through the fundamentals of Ansible and provide a user guide for this <a href="https://github.com/TheKnightCoder/Ansible-Networking">Ansible-Networking Git repository</a>.</p>
<p>The two main automation processes covered in this document are:</p>
<blockquote>
<ul>
<li>Adding/Replacing Config</li>
<li>Gathering facts/information on network devices</li>
</ul>
</blockquote>
<p>To understand the automation process it is important to have a brief understanding of the following libraries and frameworks:</p>
<h2 id="ansibles-role-in-network-automation">Ansible’s role in Network Automation</h2>
<p><img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Ansible_Logo.png" alt="Ansible Logo"></p>
<p>Ansible is an open source automation platform. It can help you with configuration management, application deployment, task automation and IT orchestration. For example it can install a software on hundreds of servers from a single control machine, it will not reinstall software if the same version is already installed and can make server specific configuration changes. It can also run IOS commands and config changes!</p>
<p>Think of Ansible as the distribution center, it will send a task to many devices from a central Ansible control machine. Ansible runs tasks from a ‘playbook’.  A playbook is simply put a list of tasks, along with some settings such as which machines to run the playbook on. A task is a command to be executed, such as creating a new folder. Every task corresponds to a module, which is either in-built, community created or custom. Every module is written in the Python programming language, therefore you can run your own python code in Ansible by creating a custom modules.</p>
<p>So if we break it down we are essentially running python code on multiple devices and Ansible is helping us do that, it is like the glue that sticks everything together.</p>
<p>As Cisco IOS devices cannot run python we set Ansible to run in ‘local’ connection mode and we access the IOS devices via SSH. The python code is run on the local machine and commands are sent and outputs retrieved from the devices via SSH.</p>
<p><img src="https://user-images.githubusercontent.com/24293640/33616163-0c3ff590-d9d4-11e7-95f4-19280b1c223c.png" alt="1ansible_diagram"></p>
<p>Watch these video tutorials to gain a greater understanding of Ansible:</p>
<blockquote>
<ul>
<li><a href="https://www.codereviewvideos.com/course/ansible-tutorial">Code Review Videos</a> - (First 4 videos are just installation, it is recommended to use the installation guide below rather than the one in this video)</li>
<li><a href="https://www.youtube.com/watch?v=icR-df2Olm8&amp;list=PLFiccIuLB0OiWh7cbryhCaGPoqjQ62NpU">Ben’s IT Lessons</a></li>
</ul>
</blockquote>
<p>For more information visit the <a href="http://docs.ansible.com/ansible/latest/intro_getting_started.html">Ansible docs</a>.</p>
<h2 id="templating-with-jinja2">Templating with Jinja2</h2>
<p><img src="http://jinja.pocoo.org/docs/2.10/_static/jinja-small.png" alt="Jinja2 Logo"></p>
<p>Templating is the most important thing to know when implementing network automation, thankfully it can also be the simplest. If the only thing that interests you is simple config changes then Jinja2 is all you need to know.</p>
<p>A Jinja2 template is just a regular text file with a twist, it contains special notations which will be replaced with a variable. Jinja2 variables have the following notation <code>{{ foo }}</code>. When the template is processed to produce an output text file, it will replace all <code>{{ foo }}</code> with the actual ‘foo’ variable defined in Ansible. (foo may be replaced with any variable name).</p>
<p>A lot can be accomplished with the above information however Jinja2 is capable of much more with its ability to use for loops, if statements, filters and inheritance. The <a href="http://jinja.pocoo.org/docs/2.10/">Jinja2 documentation</a> is very well written and can be used to learn how to implement these concepts</p>
<p>An in-depth understanding of Ansible and Python is not needed for most config changes, however it can be useful when making more complex templates. An example of this is when you need to add config to every interface on multiple switches of varying models. One device may have 4 interfaces while the other has 7, and the interfaces may have different names such as Fa0/1 and Gi0/1. One way to solve this problem is to use a show command to dynamically get the list of interfaces and then apply the config to those interfaces, this will need comprehensive understanding of Ansible. A simpler solution to this problem would be to group the devices by model and manually list the interfaces for each group (in the group vars). This would require knowledge of the number and names of the interfaces for each model in the network but would require no additional Ansible/Python.</p>
<p>N.B. This specific problem has been solved, see <em>X</em> for more detail.</p>
<p>For more information visit the <a href="http://jinja.pocoo.org/docs/">Jinja2 docs</a>.</p>
<h2 id="napalm">NAPALM</h2>
<p><img src="https://avatars0.githubusercontent.com/u/16415577?s=200&amp;v=4" alt="NAPALM Logo"></p>
<p>NAPALM (Network Automation and Programmability Abstraction Layer with Multivendor support)</p>
<p>go through napalm how config replaced &amp; diffs</p>
<p>For more information visit the <a href="https://github.com/napalm-automation/napalm">NAPALM repository</a> and the <a href="https://github.com/napalm-automation/napalm-ansible">NAPALM Ansible repository</a></p>
<h2 id="ntc-ansible">NTC-Ansible</h2>
<p>go through ntc ansible briefly<br>
note multiline problem</p>
<p>For more information visit the <a href="https://github.com/networktocode/ntc-ansible">NTC-Ansible repository</a></p>
<p>setup<br>
Installation<br>
Docker</p>
<h2 id="regex--textfsm">Regex / TextFSM</h2>
<p>Regular Expression (Regex) is another essential skill which is needed in network automation, it will give you the ability to format a ‘show’ command into something a computer can easily handle. Currently the Cisco IOS is built for human-readability however it is not very good for computers. For computers to be able to handle data it needs to be formatted in a way that is more appropriate such as csv, json, sql etc rather than a block of text. TextFSM will help you do just that, it will take a template file, and text input (such as command responses from the CLI of a device) and returns a list of records that contains the data parsed from the text. It is a python library which is integrated into Ansible.<br>
(NTC-Ansible ntc_show_commands also uses TextFSM to parse it’s data.)</p>
<p>To create TextFSM templates you will need to know regex. This will give you the ability to parse any show command into Ansible. To learn regex I recommend watching these <a href="https://www.youtube.com/watch?v=7DG3kCDx53c&amp;list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w">videos tutorials by The Coding Train</a>. The ntc_show_commands has a library of templates already written for IOS show commands. These templates can be found in <code>Ansible-Networking\lib\modules\ntc-ansible\ntc-templates\templates</code></p>
<p>The ntc_show_command templates do not take into account text which spans over multiple lines in a CLI table. An example of this situation is when you have a very long hostname, which results in the initial portion of the hostname being cut off. This is a problem I faced with <code>show cdp neigbors</code>.</p>
<p><img src="https://user-images.githubusercontent.com/24293640/34607820-4551031e-f20d-11e7-88e7-0e89fa6b6254.png" alt="CLI table"></p>
<p>See section <em>X</em> to see how a custom TextFSM templates were used to resolve this problem. Although this solution works for a span over 2 lines it may not work for more.</p>
<p>To learn more about regular expressions watch <a href="https://www.youtube.com/watch?v=7DG3kCDx53c&amp;list=PLRqwX-V7Uu6YEypLuls7iidwHMdCM6o2w">The Coding Train Videos</a></p>
<p>Also practice regular expressions at <a href="https://regexr.com/">regexr.com</a>. Make sure to turn on the multi-line flag as TextFSM uses multi-line regex.</p>
<h2 id="ara-ansible-run-analysis">ARA: Ansible Run Analysis</h2>
<p><img src="https://github.com/openstack/ara/raw/master/doc/source/_static/ara-with-icon.png" alt="ARA Logo"></p>
<p>ARA records Ansible playbook runs and makes the recorded data available and intuitive for users and systems. ARA keeps a record of all playbook runs on a database. In this repository ARA has been set to save runs in a SQLite file located at <code>files/db/ara.sqlite</code>. SQLite is being used as it keeps ARA simple and portable, all data is stored in a file in the ansible folder and nothing is stored in the Docker containers or VM.</p>
<p>If needed the ARA database can be changed to a centralized database by changing the ARA_DATABASE environment variable in both the ARA and Ansible containers.</p>
<p><img src="https://github.com/openstack/ara/raw/master/doc/source/_static/reports.png" alt="ARA screenshot"></p>
<p>As you can see from the image above, ARA shows you a complete summary of playbooks that have been run. It gives you very useful information such as which hosts the playbook was run on, the time is took and whether the playbook was successful.</p>
<h1 id="installation">Installation</h1>
<p>Ansible only runs on linux and therefore you need a Virtual Machine (VM) if you are running Mac OSX or Windows. A VM is virtual operating system (OS) running on-top of your current OS, allowing you to run linux on Windows/OSX. This guide will assume you are running windows, if you are using Linux you will need to install docker and skip to X .</p>
<h2 id="enable-virtualisation">Enable Virtualisation</h2>
<p>You must enable virtualisation to run Virtual Machine (VM). To do this you need to enable Intel VT-x and VT-d if available in the BIOS/UEFI. You may need to visit your system Administrator.</p>
<ol>
<li>Turn on your computer and repeatedly press Delete, Esc, F1, F2, or F4. (Exact button depends on your PC model).</li>
<li>Find and enable Intel-VTx (The option may also be called VT-x, AMD-V, SVM, or Vanderpool).</li>
<li>If available enable Intel VT-d or AMD IOMMU</li>
</ol>
<p><img src="https://user-images.githubusercontent.com/24293640/33605215-a9727aaa-d9b0-11e7-8c28-987473d5b2ff.jpg" alt="virtualisation_bios"></p>
<h2 id="install-virtual-box">Install Virtual Box</h2>
<p>Virtual Box is a free open-source software that allows you to run a virtual machine.  To install Virtual Box <a href="https://www.virtualbox.org/wiki/Downloads">download</a> the ‘Virtual box platform package’, run the installer and keep hitting next until the installation is complete.</p>
<h2 id="install-vagrant">Install Vagrant</h2>
<p>Vagrant is a tool for building and managing virtual machine environments in a single workflow. It will allow you to set up your virtual machine and install all the software packages with a single command  and the vagrant file found in this repository. By using vagrant we can ensure that all VMs using the same vagrant file is identical.</p>
<p>To install Vagrant <a href="https://www.vagrantup.com/downloads.html">download</a> the installer, run the installer and keep hitting next until the installation is complete.</p>
<p>You will now need to reboot to complete the installation.</p>
<h2 id="running-vm--vagrant-file">Running VM / Vagrant File</h2>
<ol>
<li>Create a New Folder and rename it<br>
This is your Ansible folder, this will be where all your Ansible files are stored.</li>
<li>Download and extract the <a href="https://github.com/TheKnightCoder/Ansible-Networking/archive/master.zip">repository</a> into the root of your Ansible folder.</li>
</ol>
<blockquote>
<p>Make sure the actual files (vagrantfile etc.) are in the root of the Ansible folder.</p>
</blockquote>
<ol start="3">
<li>Open command prompt and navigate to the Ansible folder’s location
<ul>
<li>Win+R the type <code>cmd</code> then ok</li>
<li>Enter command <code>cd C:\Path\to\AnsibleFolder</code> (replace the path)</li>
</ul>
</li>
</ol>
<blockquote>
<p>Tip: You can <code>Shift + Right Click</code> in the file explorer and select <code>open command window here</code></p>
</blockquote>
<ol start="4">
<li>Type <code>vagrant up</code> to start the VM</li>
</ol>
<blockquote>
<p>Note: The first time this is run the vagrant image will be downloaded and VM will be provisioned. This may take some time, it will be faster after initial launch. (Make sure you are on a network that can download the image)</p>
</blockquote>
<ol start="5">
<li>Type <code>vagrant ssh</code> to ssh into the VM and access it’s shell</li>
<li>To exit SSH type <code>exit</code></li>
<li>To turn off the VM type <code>vagrant halt -f</code></li>
<li>Synced Folders - Any files stored in the Ansible folder can be accessed by the VM via the path /vagrant</li>
</ol>
<h2 id="startstop-vagrant-image">Start/Stop Vagrant image</h2>
<ul>
<li>Start VM - To start the VM you simply need to navigate to the Ansible folder and type <code>vagrant up</code></li>
<li>SSH - You can access the VM shell by entering <code>vagrant ssh</code> command. Type <code>exit</code> to exit ssh. You can ssh into the VM in multiple windows.</li>
<li>Stop VM - To stop the VM either type <code>poweroff</code> from the SSH shell or <code>vagrant halt -f</code> from cmd Ansible folder.</li>
</ul>
<h1 id="running-ansible">Running Ansible</h1>
<p>To run Ansible I have created a Docker container with all the tools needed for network automation in this container. This has quite a few advantages over installing it directly onto the VM via vagrant such as being able to run network automation on any Linux machine and using less resources if multiple instances of Ansible is needed.</p>
<p>Watch this video on <a href="https://www.youtube.com/watch?v=pGYAg7TMmp0">Docker Containers</a> to find out more about the differences between Docker and Vagrant.</p>
<h2 id="explaining-docker">Explaining Docker</h2>
<p>Docker is a resource friendly way to run applications in an isolated environment which is easily replicable across multiple machines. Vagrant VMs achieve a similar function however are much more resource heavy because each VM needs an entire OS. They also usually have more than one application per VM which causes instability.</p>
<p><img src="https://user-images.githubusercontent.com/24293640/33762832-02dabeca-dc06-11e7-8bde-c6be1fa530b8.png" alt="docker-vm-container"></p>
<p>Docker File - A Docker file is the source code of the Docker image. It is very similar to a vagrant file and contains information on what packages to install when building the image. Once compiled it forms a Docker Image.<br>
Docker Image - This image contains the actual packages etc that were defined in the Docker File.</p>
<p>Container - This is an instance of the docker image. You may have multiple containers of one image and any change in one container is not reflected in the next container.</p>
<p>Volume - This is the permanent storage for a container. Containers are meant to be destroyed and recreated and important  data should be kept in a volume. The volume can be accessed by the host machine and any other container that is linked to the volume. Volumes can be mapped to a specific directory on the host machine.</p>
<p>Port Forwarding - For the docker container to access ports on your machine you must map the ports.<br>
Note: This must also be define in your Vagrant file so that the VM can access your machine</p>
<p>(In this setup we use a Vagrant Synced folder to map your Ansible folder to /vagrant. We will then map this /vagrant folder to the Docker Container using volumes resulting in a link between your machine and the Docker container).</p>
<p>docker exec -it ansible  bash</p>
<p>docker run -v /vagrant:/ansible -p 2222:22 -p 8081:9191 --name ansible -it theknightcoder/ansible-networking bash</p>

    </div>
  </div>
</body>

</html>
