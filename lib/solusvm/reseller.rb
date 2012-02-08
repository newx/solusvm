module Solusvm
  class Reseller < Base

    def create(options ={})
      perform_request(options.merge(:action => 'reseller-create')) && returned_parameters
    end

    def change_resources(username, options={})
      perform_request(options.merge(:action => 'reseller-modifyresources', :username => username)) && returned_parameters
    end

    def info(username)
      perform_request({:action => 'reseller-info', :username => username}) && returned_parameters
    end

  end
end