# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise32"
  config.vm.forward_port 3000, 3000
  config.ssh.forward_agent = true
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.add_recipe("apt")
    chef.add_recipe("rvm::system")
    chef.add_recipe("git")
    chef.add_recipe("zsh")
    chef.add_recipe("ohmyzsh")
    chef.add_recipe("mongodb::10gen_repo")
    chef.add_recipe("mongodb::default")

    chef.json= {
                :rvm => {
                    :default_ruby => "1.9.3-p194",
                    :global_gems => [
                        { :name => "bundler"},
                        { :name => "rake"},
                        { :name => "chef"}
                    ]
                },
                :oh_my_zsh => {
                    :users => [
                        {:user_name => 'vagrant'}
                    ]
               }

  end

  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]

end
