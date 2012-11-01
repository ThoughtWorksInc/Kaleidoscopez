name "webserver"
description "Role to setup and install web server environment"
run_list "recipe[apt]", "recipe[git]", "recipe[rvm::system]", "recipe[mongodb::10gen_repo]", "recipe[mongodb::default]", "recipe[libcurl]", "recipe[wkhtmltoimage]", "recipe[cron]"
override_attributes "rvm" => {
    "rubies" => ['1.9.3-p194'],
    "default_ruby" => "1.9.3-p194",
    "global_gems" => [
        {"name" => "bundler"},
        {"name" => "rake"},
        {"name" => "chef"},
        {"name" => "passenger"}
    ]
}
