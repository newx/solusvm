module Solusvm
  class General < Base
    def nodes(type)
      parse_list 'listnodes', type, 'nodes'
    end

    def nodes_ids(type)
      parse_list 'node-idlist', type, 'nodes'
    end

    def templates(type)
      parse_list 'listtemplates', type, 'templates'
    end

    def plans(type)
      parse_list 'listplans', type, 'plans'
    end

    def isos(type)
      parse_list 'listiso', type, 'iso'
    end

    def node_statistics(nodeid)
      perform_request(:action => 'node-statistics', :nodeid => nodeid)
      returned_parameters
    end

    def node_xenresources(nodeid)
      perform_request(:action => 'node-xenresources', :nodeid => nodeid)
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

    private

    def parse_list(action, type, xmlelement)
      validate_server_type!(type)
      perform_request(:action => action, :type => type)
      returned_parameters[xmlelement].split(',')
    end
  end
end
