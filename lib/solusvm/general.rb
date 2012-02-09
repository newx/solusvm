module Solusvm
  # Solusvm::General is the class for retrieving general information.
  class General < Base
    
    # Lists available templates.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def templates(type)
      validate_server_type!(type)
      perform_request(:action => 'listtemplates', :type => type)
      parse_returned_params_as_list('templates')
    end

    # Lists available plans.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def plans(type)
      validate_server_type!(type)
      perform_request(:action => 'listplans', :type => type)
      parse_returned_params_as_list('plans')
    end

    # Lists available isos.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def isos(type)
      validate_server_type!(type)
      perform_request(:action => 'listiso', :type => type)
      parse_returned_params_as_list('iso')
    end
  end
end
