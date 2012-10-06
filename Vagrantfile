# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise64"
  config.vm.forward_port 9292, 9292
  config.vm.forward_port 8888, 8888
  config.ssh.forward_agent = true
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.add_recipe("apt")
    chef.add_recipe("git::source")
    #chef.add_recipe("zsh")
    #chef.add_recipe("ohmyzsh")
    chef.add_recipe("rvm::vagrant")
    chef.add_recipe("rvm::system")
    chef.add_recipe("mongodb::10gen_repo")
    chef.add_recipe("mongodb::default")
#    chef.cookbooks_path = "chef/site-cookbooks"
  #  chef.add_recipe("libcurl")

    chef.json= {
        :oh_my_zsh => {
            :users => [
                {:user_name => 'vagrant'}
            ]
        },
        :rvm => {
            :rubies => ['1.9.3-p194'],
            :default_ruby => "1.9.3-p194",
            :global_gems => [
                { :name => "bundler"},
                { :name => "rake"},
                { :name => "chef"}
            ],
            'vagrant' => {
                'system_chef_solo' => '/opt/vagrant_ruby/bin/chef-solo'
            }
        }
    }

  end

  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]
  config.vm.provision :shell, :inline => 'sudo chown -R vagrant /usr/local/rvm'
end