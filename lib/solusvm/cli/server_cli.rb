module Solusvm
  class ServerCli < BaseCli

    desc "status VSERVERID", "Checks the status of a server"
    def status(vserverid)
      say server.status(vserverid)
    end

    desc "changeplan VSERVERID NEWPLAN", "Changes the plan of a server"
    def changeplan(vserverid, newplan)
      say server.change_plan(vserverid, newplan)
    end

    desc "addip VSERVERID", "Adds an ip to the server"
    def addip(vserverid)
      say server.add_ip(vserverid)
    end

    desc "boot VSERVERID", "Boots up a server"
    def boot(vserverid)
      say server.boot(vserverid)
    end

    desc "reboot VSERVERID", "Reboots a server"
    def reboot(vserverid)
      say server.reboot(vserverid)
    end

    desc "shutdown VSERVERID", "Shuts down a server"
    def shutdown(vserverid)
      say server.shutdown(vserverid)
    end

    desc "suspend VSERVERID", "Suspends a server"
    def suspend(vserverid)
      say server.suspend(vserverid)
    end

    desc "resume VSERVERID", "Resumes a server"
    def resume(vserverid)
      say server.resume(vserverid)
    end

    desc "check-exists VSERVERID", "Checks if a server exists"
    def check_exists(vserverid)
      say server.check_exists(vserverid)
    end

    desc "terminate VSERVERID", "Terminates a server"
    def terminate(vserverid)
      say server.terminate(vserverid)
    end

    desc "rebuild VSERVERID", "Rebuilds a server"
    method_option :template, :type => :string, :desc => "VPS template to boot from",  :aliases => ["-t", "--template"]
    def rebuild(vserverid)
      say server.rebuild(vserverid, {:template => options[:template]})
    end

    desc "create HOSTNAME PASSWORD", "Creates a new server"
    method_option :plan, :type => :string, :desc => "Plan to use",  :aliases => ["-p", "--plan"]
    method_option :ips,  :type => :string, :desc => "Number of ips to add to the vps",  :aliases => ["-i", "--ips"]
    method_option :kind, :type => :string, :desc => "Type of VPS (#{Solusvm::Server::VALID_SERVER_TYPES.join(',')})",  :aliases => ["-k", "--kind"]
    method_option :username, :type => :string, :desc => "The client to put the VPS under",  :aliases => ["-u", "--username"]
    method_option :template, :type => :string, :desc => "VPS template to boot from",  :aliases => ["-t", "--template"]
    method_option :node, :type => :string, :desc => "Node to provision on",  :aliases => ["-n", "--node"]
    def create(hostname, password)
      server.create(hostname, password, {
        :plan => options[:plan], :ips => options[:ips], :type => options[:kind], 
        :username => options[:username], :template => options[:template], :node => options[:node]
      })
    end

    private

    def server
      @server ||= begin
        configure
        Solusvm::Server.new
      end
    end
  end
end