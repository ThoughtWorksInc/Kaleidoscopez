    name  "default-role"
    description "This provisions the neccesary recipes for the vagrant box."
    run_list  "recipe[apt]", "recipe[git::source]", "recipe[rvm::vagrant]", "recipe[rvm::system]", "recipe[mongodb::10gen_repo]", "recipe[mongodb::default]", "recipe[libcurl]"

