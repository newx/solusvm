require 'yaml'
require 'thor'
require 'thor/group'
require 'solusvm'
require 'solusvm/version'

module Solusvm
  class BaseCli < Thor
    include Thor::Actions

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

    # Convenience method to get the namespace from the class name. It's the
    # same as Thor default except that the "_cli" at the end of the class
    # is removed.
    def self.namespace(name=nil)
      return super if name
      @namespace ||= super.sub(/_cli$/, '')
    end
    
    class_option :api_login, :type => :string, :desc => "API ID. Required.",  :aliases => ["-I", "--api-login"], :default => default_option(:id)
    class_option :api_key,   :type => :string, :desc => "API KEY. Required.", :aliases => ["-K", "--api-key"], :default => default_option(:key)
    class_option :api_url,   :type => :string, :desc => "API URL. Required.", :aliases => ["-U", "--api-url"], :default => default_option(:url)

    # Overrides the default banner implementation to output the whole command
    def self.banner(task, namespace = true, subcommand = false)
      "#{self.namespace.split(":").join(" ")} #{task.formatted_usage(self, false, false)}"
    end

    protected

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
  end

  class NodeCli < BaseCli

    desc "available-ips VSERVERID", "Lists the available ips for a given node"
    def available_ips(vserverid)
      say general.node_available_ips(vserverid).join("\n")
    end

    desc "stats VSERVERID", "Lists statistics for a given node"
    def stats(vserverid)
      say general.node_statistics(vserverid).map{|k, v| "#{k} => #{v}" }.join("\n")
    end
  end

  class Cli < Thor
    register(ServerCli, 'server', 'server <command>', 'Server commands')
    register(NodeCli,   'node',   'node <command>',   'Node commands')

    desc "version", "Outputs the current program version"
    def version
      say Solusvm::VERSION
    end
  end
end
