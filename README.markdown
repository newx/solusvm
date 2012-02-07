SolusVM [![SolusVM Build Status][Build Icon]][Build Status]
===========================================================

SolusVM allows for easy interaction with the [SolusVM Admin::API][].
This library was first created for internal use at [Site5 LLC][].

SolusVM has been tested on MRI 1.8.7, MRI 1.9.2, MRI 1.9.3 Preview 1,
Rubinius 2.0, and JRuby 1.6.2.

[Site5 LLC]: http://www.site5.com
[SolusVM Admin::API]: http://wiki.solusvm.com/index.php/API:Admin
[Build Status]: http://travis-ci.org/site5/solusvm
[Build Icon]: https://secure.travis-ci.org/site5/solusvm.png?branch=master

Basic Examples
--------------

    Solusvm.config('api_id', 'api_password', :url => 'http://www.example.com/api')
    server = Solusvm::Server.new

    # 200 is the id of the virtual server
    server.shutdown(200) # => true
    server.boot(200) # => true
    server.reboot(200) # => true
    server.suspend(200) # => true
    server.resume(200) # => true

Server creation
---------------

    options = {:type => 'xen', :username => 'bob', :node => 'node1', :plan => 'plan1', :template => 'mytpl', :ips => 1}
    result = sever.create('server.hostname.com', 'password', options}
    p server.successful?
    => true

    p result
    => {"mainipaddress"=>"127.0.0.1", "consoleuser"=>"console-user", "vserverid"=>"10", 
    "statusmsg"=>"Virtual server created", "virtid"=>"vm10", "consolepassword"=>"myPassisL33t", 
    "extraipaddress"=>{}, "hostname"=>"server.hostname", "rootpassword"=>"password", "status"=>"success"}

Command Line Usage
------------------

  There are commands to run server and node actions. To check all available actions, you can execute the
  following command:

    solusvm server
    solusvm node

  To check the available options for a given action, you can execute the following command:

    solusvm server help create

Default Config for Command Line
--------------------------------

The command line utility, solusvm, will look for a .solusvm.yml file in ~/. You can specify some defaults. 

    ~/.solusvm.yml
    id: api_id
    key: api_key
    # URL to the API endpoint
    url: https://portal.yoursite.com/api/admin/command.php
    # Default client to put servers under
    username: bob

Requirements
------------

* xml-simple

Documentation
-------------

* http://solusvm.rubyforge.org/solusvm/

Installation
------------

    gem install solusvm

Contributors
------------

* [Justin Mazzi](http://github.com/jmazzi)
* [Maran H.](http://github.com/maran)
* [Joshua Priddle](http://github.com/itspriddle)
* [Vince Stratful](http://github.com/Vincepbell)

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Add yourself to the Contributors list
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010-2011 Site5. See LICENSE for details.
