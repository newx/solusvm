module Solusvm
  class General < Base
    def nodes(type)
      type.strip!
      validate_server_type!(type)
      perform_request(:action => 'listnodes', :type => type)
      returned_paramaters['nodes']
    end

    def templates(type)
      type.strip!
      validate_server_type!(type)
      perform_request(:action => 'listtemplates', :type => type)
      returned_paramaters['templates']
    end

    def node_statistics(nodeid)
      perform_request(:action => 'node-statistics', :nodeid => nodeid)
      returned_paramaters
    end

  end
end