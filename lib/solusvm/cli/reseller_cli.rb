module Solusvm
  class ResellerCli < BaseCli

    desc "create", "Creates a new reseller"
    method_option :username, :type => :string, :desc => "Username",  :aliases => ["-u", "--username"]
    method_option :password, :type => :string, :desc => "Password",  :aliases => ["-p", "--password"]
    method_option :email, :type => :string, :desc => "Email",  :aliases => ["-e", "--email"]
    method_option :firstname, :type => :string, :desc => "Firstname",  :aliases => ["-f", "--firstname"]
    method_option :lastname, :type => :string, :desc => "Lastname",  :aliases => ["-l", "--lastname"]
    method_option :company, :type => :string, :desc => "Company",  :aliases => ["-c", "--company"]
    method_option :usernameprefix, :type => :string, :desc => "Prefix for reseller client usernames (optional)",  :aliases => ["-up", "--usernameprefix"]
    method_option :maxvps, :type => :string, :desc => "Maximum amount of virtual servers (optional)",  :aliases => ["-mvps", "--maxvps"]
    method_option :maxusers, :type => :string, :desc => "Maximum amount of users (optional)",  :aliases => ["-mu", "--maxusers"]
    method_option :maxmem, :type => :string, :desc => "Maximum amount of memory (optional)",  :aliases => ["-mm", "--maxmem"]
    method_option :maxburst, :type => :string, :desc => "Maximum amount of burst memory or swapspace (optional)",  :aliases => ["-mb", "--maxburst"]
    method_option :maxbw, :type => :string, :desc => "Maximum amount of bandwith (optional)",  :aliases => ["-mb", "--maxbw"]
    method_option :maxdisk, :type => :string, :desc => "Maximum amount of disk (optional)",  :aliases => ["-mb", "--maxdisk"]
    method_option :maxipv4, :type => :string, :desc => "Maximum amount of ipv4 addresses (optional)",  :aliases => ["-mipv4", "--maxipv4"]
    method_option :maxipv6, :type => :string, :desc => "Maximum amount of ipv6 addresses (optional)",  :aliases => ["-mipv6", "--maxipv6"]
    method_option :nodegroups, :type => :string, :desc => "Comma separated list of node groups (optional)",  :aliases => ["-ng", "--nodegroups"]
    method_option :mediagroups, :type => :string, :desc => "Comma separated list of media groups (optional)",  :aliases => ["-mg", "--mediagroups"]
    method_option :openvz, :type => :string, :desc => "y|n Allow building of openvz virtual servers (optional)",  :aliases => ["-ovz", "--openvz"]
    method_option :xenpv, :type => :string, :desc => "y|n Allow building of xen pv virtual servers (optional)",  :aliases => ["-xpv", "--xenpv"]
    method_option :xenhvm, :type => :string, :desc => "y|n Allow building of xen hvm virtual servers (optional)",  :aliases => ["-xhvm", "--xenhvm"]
    method_option :kvm, :type => :string, :desc => "y|n Allow building of kvmvirtual servers (optional)",  :aliases => ["-kvm"]
    def create
      output api.create(options)
    end

    desc "change", "Changes the available resources of a reseller"
    method_option :maxvps, :type => :string, :desc => "Maximum amount of virtual servers (optional)",  :aliases => ["-mvps", "--maxvps"]
    method_option :maxusers, :type => :string, :desc => "Maximum amount of users (optional)",  :aliases => ["-mu", "--maxusers"]
    method_option :maxmem, :type => :string, :desc => "Maximum amount of memory (optional)",  :aliases => ["-mm", "--maxmem"]
    method_option :maxburst, :type => :string, :desc => "Maximum amount of burst memory or swapspace (optional)",  :aliases => ["-mb", "--maxburst"]
    method_option :maxbw, :type => :string, :desc => "Maximum amount of bandwith (optional)",  :aliases => ["-mb", "--maxbw"]
    method_option :maxdisk, :type => :string, :desc => "Maximum amount of disk (optional)",  :aliases => ["-mb", "--maxdisk"]
    method_option :maxipv4, :type => :string, :desc => "Maximum amount of ipv4 addresses (optional)",  :aliases => ["-mipv4", "--maxipv4"]
    method_option :maxipv6, :type => :string, :desc => "Maximum amount of ipv6 addresses (optional)",  :aliases => ["-mipv6", "--maxipv6"]
    method_option :nodegroups, :type => :string, :desc => "Comma separated list of node groups (optional)",  :aliases => ["-ng", "--nodegroups"]
    method_option :mediagroups, :type => :string, :desc => "Comma separated list of media groups (optional)",  :aliases => ["-mg", "--mediagroups"]
    method_option :openvz, :type => :string, :desc => "y|n Allow building of openvz virtual servers (optional)",  :aliases => ["-ovz", "--openvz"]
    method_option :xenpv, :type => :string, :desc => "y|n Allow building of xen pv virtual servers (optional)",  :aliases => ["-xpv", "--xenpv"]
    method_option :xenhvm, :type => :string, :desc => "y|n Allow building of xen hvm virtual servers (optional)",  :aliases => ["-xhvm", "--xenhvm"]
    method_option :kvm, :type => :string, :desc => "y|n Allow building of kvmvirtual servers (optional)",  :aliases => ["-kvm"]
    def change_resources
      output api.change_resources(options)
    end

    desc "info USERNAME", "Retrieves information from an existing reseller"
    def info(username)
      output api.info(username)
    end

    desc "delete USERNAME", "Deletes an existing reseller"
    def delete(username)
      output api.delete(username)
    end

    desc "list", "Lists existing resellers"
    def list
      output api.list
    end

    private

    def api
      @reseller ||= begin
        configure
        Solusvm::Reseller.new
      end
    end
  end
end