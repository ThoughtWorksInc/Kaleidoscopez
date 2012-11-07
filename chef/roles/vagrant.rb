name  "vagrant"
description "This provisions the neccesary recipes for the vagrant box."
run_list  "recipe[zsh]", "recipe[oh-my-zsh]","role[webserver]"
override_attributes "oh_my_zsh" => {
        "users" => [
            {
                "user_name" => 'vagrant'
            }
        ]
    }
