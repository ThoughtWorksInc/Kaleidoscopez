maintainer "Peter Klein"
maintainer_email "peter.j.klein@gmail.com"
license "Apache 2.0"
description "Installs/Configures oh-my-zsh"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.0.1"

depends "git"
depends "zsh"
%w( ubuntu debian ).each do |os|
  supports os
end
