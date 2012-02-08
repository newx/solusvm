module Solusvm
  class Node < Base
    def list(type)
      validate_server_type!(type)
      perform_request(:action => 'listnodes', :type => type)
      returned_parameters['nodes'].split(',')
    end

    def ids(type)
      validate_server_type!(type)
      perform_request(:action => 'node-idlist', :type => type)
      returned_parameters['nodes'].split(',')
    end

    def statistics(nodeid)
      perform_request(:action => 'node-statistics', :nodeid => nodeid)
      returned_parameters
    end

    def xenresources(nodeid)
      perform_request(:action => 'node-xenresources', :nodeid => nodeid)
      returned_parameters
    end

    # List a nodes available IPs
    def available_ips(nodeid)
      perform_request(:action => 'node-iplist', :nodeid => nodeid)
      if statusmsg.match /no available ip/i
        []
      else
        returned_parameters['ips'].split(',')
      end
    end

    # List the node virtual servers
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