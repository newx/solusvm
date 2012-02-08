module Solusvm
  # Solusvm::Client is the class for working with clients.
  class Client < Base
    # Creates a client.
    #
    # Options:
    #
    # * <tt>:username</tt>
    # * <tt>:password</tt>
    # * <tt>:email</tt>
    # * <tt>:firstname</tt>
    # * <tt>:lastname</tt>
    # * <tt>:company</tt>
    def create(options ={})
      perform_request(options.merge(:action => 'client-create')) && returned_parameters
    end

    # Change client password for the solus admin.
    def change_password(username, new_password)
      perform_request({:action => "client-updatepassword", :username => username, :password => new_password})
    end

    # Checks wether a specific client exists.
    def exists?(username)
      perform_request({:action => 'client-checkexists', :username => username})
    end

    # Verify a clients login. Returns true when the specified login is correct.
    def authenticate(username, password)
      perform_request({:action => 'client-authenticate', :username => username, :password => password})
    end

    # Deletes an existing client.
    def delete(username)
      perform_request({:action => "client-delete", :username => username})
    end

    # Lists existing clients.
    def list
      perform_request({:action => "client-list"}, "client")

      if returned_parameters["clients"] && returned_parameters["clients"]["client"]
        returned_parameters["clients"]["client"]
      elsif returned_parameters["clients"]
        []
      end
    end
  end
end
