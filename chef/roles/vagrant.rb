name  "vagrant"
description "This provisions the neccesary recipes for the vagrant box."
run_list  "recipe[apt]", "recipe[git]","recipe[zsh]", "recipe[oh-my-zsh]", "recipe[rvm::vagrant]", "recipe[rvm::system]", "recipe[mongodb::10gen_repo]", "recipe[mongodb::default]", "recipe[libcurl]"
override_attributes "rvm" => {
        "rubies" => ['1.9.3-p194'],
        "default_ruby" => "1.9.3-p194",
        "global_gems" => [
            { "name" => "bundler"},
            { "name" => "rake"},
            { "name" => "chef"}
        ],
        'vagrant' => {
            'system_chef_solo' => '/opt/vagrant_ruby/bin/chef-solo'
        }
    },
    "oh_my_zsh" => {
        "users" => [
            {
                "user_name" => 'vagrant'
            }
        ]
    }
