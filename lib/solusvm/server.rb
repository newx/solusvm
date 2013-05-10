module Solusvm
  # Solusvm::Server is the class for working with servers.
  class Server < Base

    # Creates a server.
    #
    # Options:
    #
    # * <tt>:type</tt> - openvz|xen|xen hvm|kvm
    # * <tt>:node</tt> - name of node
    # * <tt>:nodegroup</tt> - name of nodegroup
    # * <tt>:username</tt> - client username
    # * <tt>:plan</tt> - plan name
    # * <tt>:template</tt> - template or iso name
    # * <tt>:ips</tt> - amount of ips
    # * <tt>:hvmt</tt> - 0|1 Default is 0. This allows to define templates & isos for Xen HVM
    # * <tt>:custommemory</tt> - overide plan memory with this amount
    # * <tt>:customdiskspace</tt> - overide plan diskspace with this amount
    # * <tt>:custombandwidth</tt> - overide plan bandwidth with this amount
    # * <tt>:customcpu</tt> - overide plan cpu cores with this amount
    # * <tt>:customextraip</tt> - add this amount of extra ips
    # * <tt>:issuelicense</tt> - 1|2 1 = cPanel monthly 2= cPanel yearly
    def create(hostname, password, options = {})
      options.reverse_merge!(
        :type         => 'xen',
        :username     => nil,
        :ips          => 1,
        :node         => nil,
        :plan         => nil,
        :template     => nil,
        :password     => password,
        :hostname     => hostname
      ).merge!(:action => 'vserver-create')
      perform_request(options) && returned_parameters
    end

    # Boots a server.
    def boot(vid)
      perform_request(:action => 'vserver-boot', :vserverid => vid)
    end

    # Reboots a server.
    def reboot(vid)
      perform_request(:action => 'vserver-reboot', :vserverid => vid)
    end

    # Suspends a server.
    def suspend(vid)
      perform_request(:action => 'vserver-suspend', :vserverid => vid)
    end

    # Resumes a server.
    def resume(vid)
      perform_request(:action => 'vserver-unsuspend', :vserverid => vid)
    end

    # Shuts down a server.
    def shutdown(vid)
      perform_request(:action => 'vserver-shutdown', :vserverid => vid)
    end

    # Enable TUN/TAP.
    def tun_enable(vid)
      perform_request(:action => 'vserver-tun-enable', :vserverid => vid)
    end

    # Disable TUN/TAP.
    def tun_disable(vid)
      perform_request(:action => 'vserver-tun-disable', :vserverid => vid)
    end

    # Enable Network Mode.
    def network_enable(vid)
      perform_request(:action => 'vserver-network-enable', :vserverid => vid)
    end

    # Disables Network Mode.
    def network_disable(vid)
      perform_request(:action => 'vserver-network-disable', :vserverid => vid)
    end

    # Enable PAE.
    def pae_enable(vid)
      perform_request(:action => 'vserver-pae', :vserverid => vid, :pae => "on")
    end

    # Disables PAE.
    def pae_disable(vid)
      perform_request(:action => 'vserver-pae', :vserverid => vid, :pae => "off")
    end

    # Terminates a server.
    def terminate(vid, deleteclient = false)
      perform_request(:action => 'vserver-terminate', :vserverid => vid, :deleteclient => deleteclient)
    end

    # Checks if a specific server exists.
    def exists?(vid)
      perform_request(:action => 'vserver-checkexists', :vserverid => vid)
      !statusmsg.match(/Virtual server exists/i).nil?
    end

    # Checks the status of specific server (disabled|online|offline).
    def status(vid)
      perform_request(:action => 'vserver-status', :vserverid => vid)
      statusmsg
    end

    # Adds an IP address for a specific server.
    def add_ip(vid)
      perform_request(:action => 'vserver-addip', :vserverid => vid)
    end

    # Deletes an IP address for a specific server.
    def del_ip(vid, ip_address)
      perform_request(:action => 'vserver-delip', :vserverid => vid, :ipaddr => ip_address)
    end

    # Changes server plan.
    def change_plan(vid, plan)
      perform_request(:action => 'vserver-change', :vserverid => vid, :plan => plan)
    end

    # Changes server owner.
    def change_owner(vid, client_id)
      perform_request(:action => 'vserver-changeowner', :vserverid => vid, :clientid => client_id)
    end

    # Changes server console password.
    def change_consolepass(vid, new_password)
      perform_request(:action => 'vserver-consolepass', :vserverid => vid, :consolepassword => new_password)
    end

    # Changes server vnc password.
    def change_vncpass(vid, new_password)
      perform_request(:action => 'vserver-vncpass', :vserverid => vid, :vncpassword => new_password)
    end

    # Changes server root password.
    def change_rootpassword(vid, new_password)
      perform_request(:action => 'vserver-rootpassword', :vserverid => vid, :rootpassword => new_password)
    end

    # Changes server boot order [cd(Hard Disk CDROM)|dc(CDROM Hard Disk)|c(Hard Disk)|d(CDROM)].
    def change_bootorder(vid, bootorder)
      perform_request(:action => 'vserver-bootorder', :vserverid => vid, :bootorder => bootorder.to_s)
    end

    # Changes server hostname.
    def change_hostname(vid, hostname)
      perform_request(:action => 'vserver-hostname', :vserverid => vid, :hostname => hostname)
    end

    # Retrieves server information.
    def info(vid, reboot = false)
      perform_request(:action => 'vserver-info', :vserverid => vid, :reboot => reboot)
      returned_parameters
    end

    # Retrieves server vnc information.
    def vnc(vid)
      perform_request(:action => 'vserver-vnc', :vserverid => vid)
      returned_parameters
    end

    # Retrieves server console information.
    def console(vid)
      perform_request(:action => 'vserver-console', :vserverid => vid)
      returned_parameters
    end
    
    # Retrieves all available server information.
    def info_all(vid)
      perform_request(:action => 'vserver-infoall', :vserverid => vid)
      returned_parameters
    end

    # Rebuilds a server using a given template.
    def rebuild(vid, template)
      perform_request(:action => 'vserver-rebuild', :vserverid => vid, :template => template)
    end

    # Mounts a given iso.
    def mountiso(vid, iso)
      perform_request(:action => 'vserver-mountiso', :vserverid => vid, :iso => iso)
    end

    # Unmounts a given iso.
    def unmountiso(vid)
      perform_request(:action => 'vserver-unmountiso', :vserverid => vid)
    end
  end
end
