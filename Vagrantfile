# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.forward_port 9292, 9292
  config.vm.forward_port 8888, 8888
  config.ssh.forward_agent = true
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks","chef/site-cookbooks"]
    chef.roles_path = "chef/roles"
    chef.add_role "vagrant"
  end

  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]
end
