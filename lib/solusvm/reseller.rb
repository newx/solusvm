module Solusvm
  class Reseller < Base

    def create(options ={})
      perform_request(options.merge(:action => 'reseller-create')) && returned_parameters
    end

  end
end