# -*- mode: ruby -*-
# vi: set ft=ruby :
# THIS VAGRANTFILE IS TO BE USED WITH VBOX
# *** NOTE *** Plugins used for this vagrant File, vagrant-proxyconf and vagrant-vbguest,vagrant-winnfsd however the vbguest is for images where the guest addtions are not installed and winnfsd is only for Windows
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
     # General Vagrant VM configuration.
    if Vagrant.has_plugin?("vagrant-proxyconf")
        #config.proxy.http     = "http://ip:port/"
        #config.proxy.https    = "http://ip:port/"
        #config.proxy.no_proxy = "localhost,127.0.0.1,192.168.60.4,192.168.60.5,rketest1,rketest2"
        config.proxy.enabled = false # Uncomment only this line to disable the plugin
    end
    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.installer_options = { allow_kernel_upgrade: true } #this is needed for the vbguest plugin uncomment if you need it
        config.vbguest.auto_update = true
        config.vbguest.auto_reboot = true
        #config.vbguest.auto_update = false # Uncomment this line to disable the plugin 
    end
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true # This is for the plugin vagrant-hostmanager https://github.com/devopsgroup-io/vagrant-hostmanager
        config.hostmanager.manage_host = true # This is for the plugin vagrant-hostmanager https://github.com/devopsgroup-io/vagrant-hostmanager
        config.hostmanager.manage_guest = true # This is for the plugin vagrant-hostmanager https://github.com/devopsgroup-io/vagrant-hostmanager
    end
    if Vagrant.has_plugin?("vagrant-winnfsd") # Plugin that supports NFS on Windows so if you are on WSL2 or MAC you won't have this plugin
        config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: %w{rw,async,fsc,nolock,vers=3,udp,rsize=32768,wsize=32768,hard,noatime,actimeo=2}
    else
        #config.vm.synced_folder ".", "/vagrant", disabled: true # To disable shared folder use this
        config.vm.synced_folder ".", "/vagrant"
    end
    config.vm.box = "centos/7"
    config.ssh.insert_key = false
    config.vm.provision "ansible_local" do |ansible|
        #ansible.verbose =  "v" # Uncomment this line if you want to add or increase debug
        #ansible.galaxy_command = "sudo ansible-galaxy collection install ansible.posix"  # Just applicable to ansible > v2.9
        ansible.playbook = "main_vagrant.yml"
        ansible.provisioning_path = "/vagrant"
    end
    
    # RKE Boxes specific options
    boxes = [
        { :name => "rketest1", :ip => "192.168.60.4", :mem => "4500"},
        { :name => "rketest2", :ip => "192.168.60.5", :mem => "4500"}
    ]

    boxes.each do |rke|
        config.vm.define rke[:name] do |opts|
            opts.vm.hostname =  rke[:name]
            opts.vm.network :private_network, ip: rke[:ip]
            opts.vm.provider :virtualbox do |v|
                v.memory = rke[:mem]
                v.linked_clone = true
                v.cpus = 2
                v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] # Helps slow downloads in Vagrant/VirtualBox https://www.mkwd.net/improve-vagrant-performance/
                v.customize ["modifyvm", :id, "--natdnsproxy1", "on"] # Helps slow downloads in Vagrant/VirtualBox https://www.mkwd.net/improve-vagrant-performance/
                v.customize ["modifyvm", :id, "--ioapic", "on"] # Enables VM to use multuple CPU's https://www.mkwd.net/improve-vagrant-performance/ 
                v.customize ["modifyvm", :id, "--paravirtprovider", "hyperv"]  #Enables Paravirtualization using Hyper-V API
                v.customize ["modifyvm", :id, "--cpuexecutioncap", "60"] # Set cpu utilization cap
            end
        end
    end
end