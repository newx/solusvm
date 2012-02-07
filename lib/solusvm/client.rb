module Solusvm
  # Solusvm::Client is the class for working with clients
  class Client < Base
    # Creates a client
    #
    # Options:
    # * <tt>:username</tt>
    # * <tt>:password</tt>
    # * <tt>:email</tt>
    # * <tt>:firstname</tt>
    # * <tt>:lastname</tt>
    def create(options ={})
      options.merge!(:action => 'client-create')
      perform_request(options)
    end

    # Change client password for the solus admin
    def change_password(username, password)
      perform_request({:action => "client-updatepassword", :username => username, :password => password})
      statusmsg.match /success/i
    end

    # Checks wether a specific client exists
    def exists?(username)
      perform_request({:action => 'client-checkexists', :username => username})
      statusmsg.match /client exists/i
    end

    # Verify a clients login. Returns true when the specified login is correct
    def authenticate(username, password)
      perform_request({:action => 'client-authenticate', :username => username, :password => password})
      statusmsg.match /validated/i
    end

    # Deletes a client
    def delete(username)
      perform_request({:action => "client-delete", :username => username})
      successful?
    end
  end
end
