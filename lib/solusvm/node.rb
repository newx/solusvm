module Solusvm
  # Solusvm::Node is the class for working with nodes.
  class Node < Base
    # Public: Lists existing nodes of a given type.
    #
    # type - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    #
    # Returns an Array.
    def list(type)
      validate_server_type(type) do
        perform_request(action: 'listnodes', type: type)
        parse_returned_params_as_list('nodes')
      end
    end

    # Public: Lists existing node groups
    #
    # Returns an Array.
    def list_groups
      perform_request(action: 'listnodegroups')

      # return list of node groups with numeric values excluded
      returned_parameters['nodegroups'].to_s.split(',').map {|group| group.split('|')[1]}
    end

    # Public: Lists existing nodes ids of a given type.
    #
    # type - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    #
    # Returns an Array.
    def ids(type)
      validate_server_type(type) do
        perform_request(action: 'node-idlist', type: type)
        parse_returned_params_as_list('nodes')
      end
    end

    # Public: Retrieves statistics from a specific node.
    #
    # nodeid - The node ID
    #
    # Returns a Hash.
    def statistics(nodeid)
      perform_request(action: 'node-statistics', nodeid: nodeid)
      returned_parameters
    end

    # Retrieves available xen resources from a specific node.
    #
    # nodeid - The node ID
    #
    # Returns a Hash.
    def xenresources(nodeid)
      perform_request(action: 'node-xenresources', nodeid: nodeid)
      returned_parameters
    end

    # Public: Retrieves a list of available IPs for a specific node.
    #
    # nodeid - The node ID
    #
    # Returns an Array.
    def available_ips(nodeid)
      perform_request(action: 'node-iplist', nodeid: nodeid)
      if statusmsg.match /no available ip/i
        []
      else
        parse_returned_params_as_list('ips')
      end
    end

    # Public: Lists virtual servers from a specific node.
    #
    # nodeid - The node ID
    #
    # Returns an Array.
    def virtualservers(nodeid)
      perform_request({ action: "node-virtualservers", nodeid: nodeid }, "virtualserver")

      if returned_parameters["virtualservers"] && returned_parameters["virtualservers"]["virtualserver"]
        returned_parameters["virtualservers"]["virtualserver"]
      elsif returned_parameters["virtualservers"]
        []
      end
    end
  end
end
