module Solusvm
  class NodeCli < BaseCli

    desc "list TYPE", "Lists existing nodes for a given type [openvz|xen|xen hvm|kvm]"
    def list(type)
      output api.list(type)
    end

    desc "list-ids TYPE", "Lists existing nodes ids for a given type [openvz|xen|xen hvm|kvm]"
    def list_ids(type)
      output api.ids(type)
    end

    desc "available-ips VSERVERID", "Lists the available ips for a given node"
    def available_ips(vserverid)
      output api.available_ips(vserverid)
    end

    desc "stats VSERVERID", "Lists statistics for a given node"
    def stats(vserverid)
      output api.statistics(vserverid)
    end

    desc "xenresources VSERVERID", "Lists xen resources for a given node"
    def xenresources(vserverid)
      output api.xenresources(vserverid)
    end

    desc "virtualservers VSERVERID", "Lists the virtual servers for a given node"
    def virtualservers(vserverid)
      output api.virtualservers(vserverid)
    end

    private

    def api
      @node ||= begin
        configure
        Solusvm::Node.new
      end
    end
  end
end