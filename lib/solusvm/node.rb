module Solusvm
  # Solusvm::Node is the class for working with nodes.
  class Node < Base

    # Lists existing nodes of a given type.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def list(type)
      validate_server_type!(type)
      perform_request(:action => 'listnodes', :type => type)
      returned_parameters['nodes'].split(',')
    end

    # Lists existing nodes ids of a given type.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def ids(type)
      validate_server_type!(type)
      perform_request(:action => 'node-idlist', :type => type)
      returned_parameters['nodes'].split(',')
    end

    # Retrieves statistics from a specific node.
    def statistics(nodeid)
      perform_request(:action => 'node-statistics', :nodeid => nodeid)
      returned_parameters
    end

    # Retrieves available xen resources from a specific node.
    def xenresources(nodeid)
      perform_request(:action => 'node-xenresources', :nodeid => nodeid)
      returned_parameters
    end

    # Retrieves a list of available IPs for a specific node.
    def available_ips(nodeid)
      perform_request(:action => 'node-iplist', :nodeid => nodeid)
      if statusmsg.match /no available ip/i
        []
      else
        returned_parameters['ips'].split(',')
      end
    end

    # Lists virtual servers from a specific node.
    def virtualservers(nodeid)
      perform_request({:action => "node-virtualservers", :nodeid => nodeid}, "virtualserver")

      if returned_parameters["virtualservers"] && returned_parameters["virtualservers"]["virtualserver"]
        returned_parameters["virtualservers"]["virtualserver"]
      elsif returned_parameters["virtualservers"]
        []
      end
    end
  end
end