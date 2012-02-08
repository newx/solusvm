module Solusvm
  class General < Base
    
    def templates(type)
      validate_server_type!(type)
      perform_request(:action => 'listtemplates', :type => type)
      returned_parameters['templates'].split(',')
    end

    def plans(type)
      validate_server_type!(type)
      perform_request(:action => 'listplans', :type => type)
      returned_parameters['plans'].split(',')
    end

    def isos(type)
      validate_server_type!(type)
      perform_request(:action => 'listiso', :type => type)
      returned_parameters['iso'].split(',')
    end
  end
end
