module Solusvm
  # Solusvm::Server is the class for working with virtual servers.
  class Server < Base

    # Public: Creates a new virtual server.
    #
    # hostname - The server hostname
    # password - The server password
    # options  - A Hash of options
    #            :type            - openvz|xen|xen hvm|kvm
    #            :node            - name of node
    #            :nodegroup       - name of nodegroup
    #            :username        - client username
    #            :plan            - plan name
    #            :template        - template or iso name
    #            :ips             - amount of ips
    #            :hvmt            - 0|1 Default is 0. This allows to define
    #                               templates & isos for Xen HVM
    #            :custommemory    - overide plan memory with this amount
    #            :customdiskspace - overide plan diskspace with this amount
    #            :custombandwidth - overide plan bandwidth with this amount
    #            :customcpu       - overide plan cpu cores with this amount
    #            :customextraip   - add this amount of extra ips
    #            :issuelicense    - 1|2 1 = cPanel monthly, 2 = cPanel yearly
    #
    # Returns a Hash with the new server info, or false if the server was not
    # created successfully.
    def create(hostname, password, options = {})
      options.reverse_merge!(
        type:         'xen',
        username:     nil,
        ips:          1,
        node:         nil,
        plan:         nil,
        template:     nil,
        password:     password,
        hostname:     hostname
      ).merge!(action: 'vserver-create')
      perform_request(options) && returned_parameters
    end

    # Public: Boots a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully booted.
    def boot(vid)
      perform_request(action: 'vserver-boot', vserverid: vid)
    end

    # Public: Reboots a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully rebooted.
    def reboot(vid)
      perform_request(action: 'vserver-reboot', vserverid: vid)
    end

    # Public: Suspends a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully suspended.
    def suspend(vid)
      perform_request(action: 'vserver-suspend', vserverid: vid)
    end

    # Public: Resumes a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully resumed.
    def resume(vid)
      perform_request(action: 'vserver-unsuspend', vserverid: vid)
    end

    # Public: Shuts down a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully shutdown.
    def shutdown(vid)
      perform_request(action: 'vserver-shutdown', vserverid: vid)
    end

    # Public: Enable TUN/TAP.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if TUN/TAP was successfully enabled.
    def tun_enable(vid)
      perform_request(action: 'vserver-tun-enable', vserverid: vid)
    end

    # Public: Disable TUN/TAP.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if TUN/TAP was successfully disabled.
    def tun_disable(vid)
      perform_request(action: 'vserver-tun-disable', vserverid: vid)
    end

    # Public: Enable Network Mode.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if Network Mode was successfully enabled.
    def network_enable(vid)
      perform_request(action: 'vserver-network-enable', vserverid: vid)
    end

    # Public: Disables Network Mode.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if Network Mode was successfully disabled.
    def network_disable(vid)
      perform_request(action: 'vserver-network-disable', vserverid: vid)
    end

    # Public: Enable PAE.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if PAE was successfully enabled.
    def pae_enable(vid)
      perform_request(action: 'vserver-pae', vserverid: vid, pae: "on")
    end

    # Public: Disables PAE.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if PAE was successfully disabled.
    def pae_disable(vid)
      perform_request(action: 'vserver-pae', vserverid: vid, pae: "off")
    end

    # Public: Terminates a server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server was successfully terminated.
    def terminate(vid, deleteclient = false)
      perform_request(action: 'vserver-terminate', vserverid: vid, deleteclient: deleteclient)
    end

    # Public: Checks if a specific server exists.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the server exists.
    def exists?(vid)
      perform_request(action: 'vserver-checkexists', vserverid: vid)
      !statusmsg.match(/Virtual server exists/i).nil?
    end

    # Public: Checks the status of specific server (disabled|online|offline).
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns the server's status.
    def status(vid)
      perform_request(action: 'vserver-status', vserverid: vid)
      statusmsg
    end

    # Public: Adds an IP address for a specific server.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns the IP as a String.
    def add_ip(vid)
      perform_request(action: 'vserver-addip', vserverid: vid)
      returned_parameters['ipaddress']
    end

    # Public: Deletes an IP address for a specific server.
    #
    # vid        - The virtual server ID in SolusVM
    # ip_address - The IP address to remove
    #
    # Returns true if the IP was successfully deleted.
    def del_ip(vid, ip_address)
      perform_request(action: 'vserver-delip', vserverid: vid, ipaddr: ip_address)
    end

    # Public: Changes server plan.
    #
    # vid  - The virtual server ID in SolusVM
    # plan - The new plan ID
    #
    # Returns true if the server's plan was successfully changed.
    def change_plan(vid, plan)
      perform_request(action: 'vserver-change', vserverid: vid, plan: plan)
    end

    # Public: Changes server owner.
    #
    # vid       - The virtual server ID in SolusVM
    # client_id - The new client ID
    #
    # Returns true if the server's owner was successfully changed.
    def change_owner(vid, client_id)
      perform_request(action: 'vserver-changeowner', vserverid: vid, clientid: client_id)
    end

    # Public: Changes server console password.
    #
    # vid          - The virtual server ID in SolusVM
    # new_password - The new console password
    #
    # Returns true if the server's console password was successfully changed.
    def change_consolepass(vid, new_password)
      perform_request(action: 'vserver-consolepass', vserverid: vid, consolepassword: new_password)
    end

    # Public: Changes server VNC password.
    #
    # vid          - The virtual server ID in SolusVM
    # new_password - The new VNC password
    #
    # Returns true if the server's VNC password was successfully changed.
    def change_vncpass(vid, new_password)
      perform_request(action: 'vserver-vncpass', vserverid: vid, vncpassword: new_password)
    end

    # Public: Changes server root password.
    #
    # vid          - The virtual server ID in SolusVM
    # new_password - The new root password
    #
    # Returns true if the server's root password was successfully changed.
    def change_rootpassword(vid, new_password)
      perform_request(action: 'vserver-rootpassword', vserverid: vid, rootpassword: new_password)
    end

    # Public: Changes server boot order
    #
    # vid       - The virtual server ID in SolusVM
    # bootorder - The boot order, one of the following:
    #             :cd - Hard Disk CDROM
    #             :dc - CDROM Hard Disk
    #             :c  - Hard Disk
    #             :d  - CDROM
    #
    # Returns true if the boot order was successfully changed.
    def change_bootorder(vid, bootorder)
      perform_request(action: 'vserver-bootorder', vserverid: vid, bootorder: bootorder.to_s)
    end

    # Public: Changes server hostname.
    #
    # vid      - The virtual server ID in SolusVM
    # hostname - The new hostname
    #
    # Returns true if the server's hostname was successfully changed.
    def change_hostname(vid, hostname)
      perform_request(action: 'vserver-hostname', vserverid: vid, hostname: hostname)
    end

    # Public: Retrieves server information.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns a Hash.
    def info(vid, reboot = false)
      perform_request(action: 'vserver-info', vserverid: vid, reboot: reboot)
      returned_parameters
    end

    # Public: Retrieves server vnc information.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns a Hash.
    def vnc(vid)
      perform_request(action: 'vserver-vnc', vserverid: vid)
      returned_parameters
    end

    # Public: Retrieves server console information.
    #
    # vid    - The virtual server ID in SolusVM
    # params - A Hash to pass optional parameters to vserver-console call:
    #          :access - A String that can be 'enable' or 'disable'
    #          :time   - An Integer that can be 1|2|3|4|5|6|7|8
    #
    # returns a Hash
    def console(vid, params = {})
      perform_request(action: 'vserver-console', vserverid: vid, access: params[:access], time: params[:time])
      returned_parameters
    end

    # Public: Retrieves all available server information.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns a Hash.
    def info_all(vid)
      perform_request(action: 'vserver-infoall', vserverid: vid)
      returned_parameters
    end

    # Public: Rebuilds a server using a given template.
    #
    # vid - The virtual server ID in SolusVM
    # template - The template to use
    #
    # Returns true if the server was successfully rebuilt.
    def rebuild(vid, template)
      perform_request(action: 'vserver-rebuild', vserverid: vid, template: template)
    end

    # Public: Mounts a given ISO image.
    #
    # vid - The virtual server ID in SolusVM
    # iso - The ISO image to mount
    #
    # Returns true if the ISO was mounted successfully.
    def mountiso(vid, iso)
      perform_request(action: 'vserver-mountiso', vserverid: vid, iso: iso)
    end

    # Public: Unmounts a given ISO image.
    #
    # vid - The virtual server ID in SolusVM
    #
    # Returns true if the ISO was unmounted successfully.
    def unmountiso(vid)
      perform_request(action: 'vserver-unmountiso', vserverid: vid)
    end
  end
end
