module Solusvm
  class General < Base
    def nodes(type)
      validate_server_type!(type)
      perform_request(:action => 'listnodes', :type => type)
      returned_parameters['nodes'].split(',')
    end

    def nodes_ids(type)
      validate_server_type!(type)
      perform_request(:action => 'node-idlist', :type => type)
      returned_parameters['nodes'].split(',')
    end

    def templates(type)
      validate_server_type!(type)
      perform_request(:action => 'listtemplates', :type => type)
      returned_parameters['templates'].split(',')
    end

    def node_statistics(nodeid)
      perform_request(:action => 'node-statistics', :nodeid => nodeid)
      returned_parameters
    end

    # List a nodes available IPs
    def node_available_ips(nodeid)
      perform_request(:action => 'node-iplist', :nodeid => nodeid)
      if statusmsg.match /no available ip/i
        []
      else
        returned_parameters['ips'].split(',')
      end
    end

    # List the node virtual servers
    def node_virtualservers(nodeid)
      perform_request({:action => "node-virtualservers", :nodeid => nodeid}, "virtualserver")

      if returned_parameters["virtualservers"] && returned_parameters["virtualservers"]["virtualserver"]
        returned_parameters["virtualservers"]["virtualserver"]
      elsif returned_parameters["virtualservers"]
        []
      end
    end
  end
end
