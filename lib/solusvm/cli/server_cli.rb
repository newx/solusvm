module Solusvm
  class ServerCli < BaseCli

    desc "status VSERVERID", "Checks the status of a server"
    def status(vserverid)
      output api.status(vserverid)
    end

    desc "info VSERVERID", "Retrieves information from a server"
    def info(vserverid)
      output api.info(vserverid)
    end

    desc "vnc VSERVERID", "Retrieves vnc information from a server"
    def vnc(vserverid)
      output api.vnc(vserverid)
    end

    desc "console VSERVERID", "Retrieves console information from a server"
    def console(vserverid)
      output api.console(vserverid)
    end

    desc "info-all VSERVERID", "Retrieves all availavle information from a server"
    def info_all(vserverid)
      output api.info_all(vserverid)
    end

    desc "change-plan VSERVERID NEWPLAN", "Changes the plan of a server"
    def change_plan(vserverid, newplan)
      output api.change_plan(vserverid, newplan)
    end

    desc "change-owner VSERVERID CLIENTID", "Changes the owner of a server"
    def change_owner(vserverid, clientid)
      output api.change_owner(vserverid, clientid)
    end

    desc "change-consolepass VSERVERID NEWPASSWORD", "Changes the console password of a server"
    def change_consolepass(vserverid, newpassword)
      output api.change_consolepass(vserverid, newpassword)
    end

    desc "change-vncpass VSERVERID NEWPASSWORD", "Changes the vnc password of a server"
    def change_vncpass(vserverid, newpassword)
      output api.change_vncpass(vserverid, newpassword)
    end

    desc "change-rootpass VSERVERID NEWPASSWORD", "Changes the root password of a server"
    def change_rootpass(vserverid, newpassword)
      output api.change_rootpassword(vserverid, newpassword)
    end

    desc "change-bootorder VSERVERID BOOTORDER", "Changes the boot order of a server [cd(Hard Disk CDROM)|dc(CDROM Hard Disk)|c(Hard Disk)|d(CDROM)]"
    def change_bootorder(vserverid, newbootorder)
      output api.change_bootorder(vserverid, newbootorder)
    end

    desc "change-hostname VSERVERID HOSTNAME", "Changes the hostname of a server"
    def change_hostname(vserverid, newhostname)
      output api.change_hostname(vserverid, newhostname)
    end

    desc "addip VSERVERID", "Adds an ip to the server"
    def addip(vserverid)
      output api.add_ip(vserverid)
    end

    desc "boot VSERVERID", "Boots up a server"
    def boot(vserverid)
      output api.boot(vserverid)
    end

    desc "reboot VSERVERID", "Reboots a server"
    def reboot(vserverid)
      output api.reboot(vserverid)
    end

    desc "shutdown VSERVERID", "Shuts down a server"
    def shutdown(vserverid)
      output api.shutdown(vserverid)
    end

    desc "suspend VSERVERID", "Suspends a server"
    def suspend(vserverid)
      output api.suspend(vserverid)
    end

    desc "resume VSERVERID", "Resumes a server"
    def resume(vserverid)
      output api.resume(vserverid)
    end

    desc "check-exists VSERVERID", "Checks if a server exists"
    def check_exists(vserverid)
      output api.exists?(vserverid)
    end

    desc "terminate VSERVERID", "Terminates a server"
    def terminate(vserverid)
      output api.terminate(vserverid)
    end

    desc "rebuild VSERVERID", "Rebuilds a server"
    method_option :template, type: :string, desc: "VPS template to boot from",  aliases: ["-t", "--template"]
    def rebuild(vserverid)
      output api.rebuild(vserverid, {template: options[:template]})
    end

    desc "tun-switcher VSERVERID SWITCH(on|off)", "Enable/Disable TUN/TAP"
    def tun_switcher(vserverid, switch)
      output switch(vserverid, switch, :tun_enable, :tun_disable)
    end

    desc "network-switcher VSERVERID SWITCH(on|off)", "Enable/Disable Network mode"
    def network_switcher(vserverid, switch)
      output switch(vserverid, switch, :network_enable, :network_disable)
    end

    desc "pae-switcher VSERVERID SWITCH(on|off)", "Enable/Disable PAE"
    def pae_switcher(vserverid, switch)
      output switch(vserverid, switch, :pae_enable, :pae_disable)
    end

    desc "mountiso VSERVERID ISO", "Mounts an iso"
    def mountiso(vserverid, iso)
      output api.mountiso(vserverid, iso)
    end

    desc "unmountiso VSERVERID", "Unmounts an iso"
    def unmountiso(vserverid)
      output api.unmountiso(vserverid)
    end

    desc "create HOSTNAME PASSWORD", "Creates a new server"
    method_option :plan, type: :string, desc: "Plan to use",  aliases: ["-p", "--plan"]
    method_option :ips,  type: :string, desc: "Number of ips to add to the vps",  aliases: ["-i", "--ips"]
    method_option :kind, type: :string, desc: "Type of VPS (#{Solusvm::Server::VALID_SERVER_TYPES.join(',')})",  aliases: ["-k", "--kind"]
    method_option :username, type: :string, desc: "The client to put the VPS under",  aliases: ["-u", "--username"]
    method_option :template, type: :string, desc: "VPS template to boot from",  aliases: ["-t", "--template"]
    method_option :node, type: :string, desc: "Node to provision on",  aliases: ["-n", "--node"]
    def create(hostname, password)
      output api.create(hostname, password, {
        plan: options[:plan], ips: options[:ips], type: options[:kind],
        username: options[:username], template: options[:template], node: options[:node]
      })
    end

    private

    def api
      @server ||= begin
        configure
        Solusvm::Server.new
      end
    end

    def switch(vserverid, switch_value, on_method, off_method)
      if switch_value == "on"
        api.send(on_method, vserverid)
      elsif switch_value == "off"
        api.send(off_method, vserverid)
      else
        "Invalid switch value. Valid values are on|off"
      end
    end
  end
end