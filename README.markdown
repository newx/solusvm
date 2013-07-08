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

    server = Solusvm::Server.new(api_key: 'key', api_id: 'id', url: 'url')

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

    Tasks:
        solusvm client <command>    # Client commands
        solusvm general <command>   # General commands
        solusvm help [TASK]         # Describe available tasks or one specific task
        solusvm node <command>      # Node commands
        solusvm reseller <command>  # Reseller commands
        solusvm server <command>    # Server commands
        solusvm version             # Outputs the current program version

        solusvm client authenticate USERNAME NEWPASSWORD     # Verify a clients login. Returns true when the specified login is correct
        solusvm client change-password USERNAME NEWPASSWORD  # Changes the password of an existing client
        solusvm client check-exists USERNAME                 # Checks if a client exists
        solusvm client create                                # Creates a new client
        solusvm client delete USERNAME                       # Deletes an existing client
        solusvm client help [COMMAND]                        # Describe subcommands or one specific subcommand
        solusvm client list                                  # Lists existing clients

        solusvm general help [COMMAND]  # Describe subcommands or one specific subcommand
        solusvm general isos TYPE       # Lists existing isos for a given type [openvz|xen|xen hvm|kvm]
        solusvm general plans TYPE      # Lists existing plans for a given type [openvz|xen|xen hvm|kvm]
        solusvm general templates TYPE  # Lists existing templates for a given type [openvz|xen|xen hvm|kvm]

        solusvm node available-ips VSERVERID   # Lists the available ips for a given node
        solusvm node help [COMMAND]            # Describe subcommands or one specific subcommand
        solusvm node list TYPE                 # Lists existing nodes for a given type [openvz|xen|xen hvm|kvm]
        solusvm node list-ids TYPE             # Lists existing nodes ids for a given type [openvz|xen|xen hvm|kvm]
        solusvm node stats VSERVERID           # Lists statistics for a given node
        solusvm node virtualservers VSERVERID  # Lists the virtual servers for a given node
        solusvm node xenresources VSERVERID    # Lists xen resources for a given node

        solusvm reseller change           # Changes the available resources of a reseller
        solusvm reseller create           # Creates a new reseller
        solusvm reseller delete USERNAME  # Deletes an existing reseller
        solusvm reseller help [COMMAND]   # Describe subcommands or one specific subcommand
        solusvm reseller info USERNAME    # Retrieves information from an existing reseller
        solusvm reseller list             # Lists existing resellers

        solusvm server addip VSERVERID                            # Adds an ip to the server
        solusvm server boot VSERVERID                             # Boots up a server
        solusvm server change-bootorder VSERVERID BOOTORDER       # Changes the boot order of a server [cd(Hard Disk CDROM)|dc(CDROM Hard Disk)|c(Hard Di...
        solusvm server change-consolepass VSERVERID NEWPASSWORD   # Changes the console password of a server
        solusvm server change-hostname VSERVERID HOSTNAME         # Changes the hostname of a server
        solusvm server change-owner VSERVERID CLIENTID            # Changes the owner of a server
        solusvm server change-plan VSERVERID NEWPLAN              # Changes the plan of a server
        solusvm server change-rootpass VSERVERID NEWPASSWORD      # Changes the root password of a server
        solusvm server change-vncpass VSERVERID NEWPASSWORD       # Changes the vnc password of a server
        solusvm server check-exists VSERVERID                     # Checks if a server exists
        solusvm server console VSERVERID                          # Retrieves console information from a server
        solusvm server create HOSTNAME PASSWORD                   # Creates a new server
        solusvm server help [COMMAND]                             # Describe subcommands or one specific subcommand
        solusvm server info VSERVERID                             # Retrieves information from a server
        solusvm server info-all VSERVERID                         # Retrieves all availavle information from a server
        solusvm server mountiso VSERVERID ISO                     # Mounts an iso
        solusvm server network-switcher VSERVERID SWITCH(on|off)  # Enable/Disable Network mode
        solusvm server pae-switcher VSERVERID SWITCH(on|off)      # Enable/Disable PAE
        solusvm server reboot VSERVERID                           # Reboots a server
        solusvm server rebuild VSERVERID                          # Rebuilds a server
        solusvm server resume VSERVERID                           # Resumes a server
        solusvm server shutdown VSERVERID                         # Shuts down a server
        solusvm server status VSERVERID                           # Checks the status of a server
        solusvm server suspend VSERVERID                          # Suspends a server
        solusvm server terminate VSERVERID                        # Terminates a server
        solusvm server tun-switcher VSERVERID SWITCH(on|off)      # Enable/Disable TUN/TAP
        solusvm server unmountiso VSERVERID                       # Unmounts an iso
        solusvm server vnc VSERVERID                              # Retrieves vnc information from a server

    Options:
        -I, --api-login, [--api-login=API_LOGIN]  # API ID. Required.
        -K, --api-key, [--api-key=API_KEY]        # API KEY. Required.
        -U, --api-url, [--api-url=API_URL]        # API URL. Required.


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
* [Rubem Nakamura](http://github.com/rubemz)

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

Copyright (c) 2010-2013 Site5.com. See LICENSE for details.
