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
      returned_parameters['templates'].split(',')
    end

    # Lists available plans.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def plans(type)
      validate_server_type!(type)
      perform_request(:action => 'listplans', :type => type)
      returned_parameters['plans'].split(',')
    end

    # Lists available isos.
    #
    # Parameters:
    #
    # * +type+ - a valid virtualization type; e.g: [openvz|xen|xen hvm|kvm]
    def isos(type)
      validate_server_type!(type)
      perform_request(:action => 'listiso', :type => type)
      returned_parameters['iso'].split(',')
    end
  end
end
