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
  end
end