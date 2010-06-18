module Solusvm
  class Client < Base
    # username   [username]
    # password   [password]
    # email      [email address]
    # firstname  [first name]
    # lastname   [last name]
    def create(options ={})
      options.merge!(:action => 'client-create')
      perform_request(options)
    end

    def authenticate(username, password)
      perform_request({:action => 'client-authenticate', :username => username, :password => password})
      statusmsg.match /validated/i
    end
  end
end