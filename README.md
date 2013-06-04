[![Build Status](https://secure.travis-ci.org/ThoughtWorksInc/Kaleidoscopez.png)](http://travis-ci.org/ThoughtWorksInc/Kaleidoscopez)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ThoughtWorksInc/Kaleidoscopez)

## Kaleidoscopez

###Vagrant Setup

1. Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/)

2. Download and add vagrant box

  `vagrant box add precise64 http://files.vagrantup.com/precise32.box`

3. Start your virtual machine

   `vagrant up`

4. Access the vagrant box

   `vagrant ssh`

### Twitter
For your twitter feeds to work you need to have these environemnt variables set in the shell you wil try to fetch items

    export TWITTER_CUSTOMER_KEY='xxxxxxxxx'
    export TWITTER_CUSTOMER_SECRET='xxxxxxxxxxx'
    export TWITTER_OAUTH_TOKEN='xxxxxxxxxxxxxxxxx'
    export TWITTER_OAUTH_TOKEN_SECRET='xxxxxxxxxxxxxxxx'

You can get these keys from [dev.twitter.com](https://dev.twitter.com)

