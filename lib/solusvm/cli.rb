require 'solusvm'
require 'yaml'
require 'thor'

module Solusvm
  class Cli < Thor

    # Retrieves default options coming from a configuration file, if any.
    def self.default_option(key)
      @@yaml ||= begin
        file = File.join(File.expand_path(ENV['HOME']), '.solusvm.yml')
        if File.exists?(file)
          YAML::load(File.open(file))
        else
          {}
        end
      end

      @@yaml[key.to_s]
    end
    
    class_option :api_login, :type => :string, :desc => "API ID. Required.",  :aliases => ["-I", "--api-login"], :default => default_option(:id)
    class_option :api_key,   :type => :string, :desc => "API KEY. Required.", :aliases => ["-K", "--api-key"], :default => default_option(:key)
    class_option :api_url,   :type => :string, :desc => "API URL. Required.", :aliases => ["-U", "--api-url"], :default => default_option(:url)

    desc "server-status VSERVERID", "Checks the status of a server"
    def server_status(vserverid)
      server.status(vserverid)
    end

    desc "server-changeplan VSERVERID NEWPLAN", "Changes the plan of a server"
    def server_changeplan(vserverid, newplan)
      server.change_plan(vserverid, newplan)
    end

    desc "server-addip VSERVERID", "Adds an ip to the server"
    def server_addip(vserverid)
      server.add_ip(vserverid)
    end

    desc "server-boot VSERVERID", "Boots up a server"
    def server_boot(vserverid)
      server.boot(vserverid)
    end

    desc "server-reboot VSERVERID", "Reboots a server"
    def server_reboot(vserverid)
      server.reboot(vserverid)
    end

    desc "server-shutdown VSERVERID", "Shuts down a server"
    def server_shutdown(vserverid)
      server.shutdown(vserverid)
    end

    desc "server-suspend VSERVERID", "Suspends a server"
    def server_suspend(vserverid)
      server.suspend(vserverid)
    end

    desc "server-resume VSERVERID", "Resumes a server"
    def server_resume(vserverid)
      server.resume(vserverid)
    end

    desc "server-check-exists VSERVERID", "Checks if a server exists"
    def server_check_exists(vserverid)
      server.check_exists(vserverid)
    end

    desc "server-terminate VSERVERID", "Terminates a server"
    def server_terminate(vserverid)
      server.terminate(vserverid)
    end

    desc "server-rebuild VSERVERID", "Rebuilds a server"
    method_option :template, :type => :string, :desc => "VPS template to boot from",  :aliases => ["-t", "--template"]
    def server_rebuild(vserverid)
      server.rebuild(vserverid, {:template => options[:template]})
    end

    desc "server-create HOSTNAME PASSWORD", "Creates a new server"
    method_option :plan, :type => :string, :desc => "Plan to use",  :aliases => ["-p", "--plan"]
    method_option :ips,  :type => :string, :desc => "Number of ips to add to the vps",  :aliases => ["-i", "--ips"]
    method_option :kind, :type => :string, :desc => "Type of VPS (#{Solusvm::Server::VALID_SERVER_TYPES.join(',')})",  :aliases => ["-k", "--kind"]
    method_option :username, :type => :string, :desc => "The client to put the VPS under",  :aliases => ["-u", "--username"]
    method_option :template, :type => :string, :desc => "VPS template to boot from",  :aliases => ["-t", "--template"]
    method_option :node, :type => :string, :desc => "Node to provision on",  :aliases => ["-n", "--node"]
    def server_create(hostname, password)
      server.create(hostname, password, {
        :plan => options[:plan], :ips => options[:ips], :type => options[:kind], 
        :username => options[:username], :template => options[:template], :node => options[:node]
      })
    end

    desc "node-available-ips VSERVERID", "Lists the available ips for a given node"
    def node_available_ips(vserverid)
      general.node_available_ips(vserverid).join("\n")
    end

    desc "node-stats VSERVERID", "Lists statistics for a given node"
    def node_stats(vserverid)
      general.node_statistics(vserverid).map{|k, v| "#{k} => #{v}" }.join("\n")
    end

    private

    def configure
      Solusvm.config(options[:api_login], options[:api_key], :url => options[:api_url])
    end

    def server
      @server ||= begin
        configure
        Solusvm::Server.new
      end
    end

    def general
      @general ||= begin
        configure
        Solusvm::General.new
      end
    end

  end
end
