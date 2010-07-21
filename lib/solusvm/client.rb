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
    
    def exists?(username)
      perform_request({:action => 'client-checkexists', :username => username})
      !statusmsg.match(/Client exists/i).nil?
    end

    # Verify a clients login. Returns true when the specified login is correct
    def authenticate(username, password)
      perform_request({:action => 'client-authenticate', :username => username, :password => password})
      statusmsg.match /validated/i
    end
  end
end