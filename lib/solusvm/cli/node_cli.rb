module Solusvm 
  class NodeCli < BaseCli

    desc "list TYPE", "Lists existing nodes for a given type [openvz|xen|xen hvm|kvm]"
    def list(type)
      say node.list(type)
    end

    desc "list-ids TYPE", "Lists existing nodes ids for a given type [openvz|xen|xen hvm|kvm]"
    def list_ids(type)
      say node.ids(type)
    end

    desc "available-ips VSERVERID", "Lists the available ips for a given node"
    def available_ips(vserverid)
      say node.available_ips(vserverid).join("\n")
    end

    desc "stats VSERVERID", "Lists statistics for a given node"
    def stats(vserverid)
      say node.statistics(vserverid).map{|k, v| "#{k} => #{v}" }.join("\n")
    end

    desc "xenresources VSERVERID", "Lists xen resources for a given node"
    def xenresources(vserverid)
      say node.xenresources(vserverid).map{|k, v| "#{k} => #{v}" }.join("\n")
    end

    desc "virtualservers VSERVERID", "Lists the virtual servers for a given node"
    def virtualservers(vserverid)
      say node.virtualservers(vserverid)
    end

    private

    def node
      @node ||= begin
        configure
        Solusvm::Node.new
      end
    end
  end
end