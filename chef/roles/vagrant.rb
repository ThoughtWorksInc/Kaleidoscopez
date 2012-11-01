name  "vagrant"
description "This provisions the neccesary recipes for the vagrant box."
run_list  "role[webserver]","recipe[zsh]", "recipe[oh-my-zsh]"
override_attributes "oh_my_zsh" => {
        "users" => [
            {
                "user_name" => 'vagrant'
            }
        ]
    }
