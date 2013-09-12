module Solusvm
  # Solusvm::Client is the class for working with clients.
  class Client < Base
    # Public: Creates a client.
    #
    # options - A Hash of options:
    #           :username
    #           :password
    #           :email
    #           :firstname
    #           :lastname
    #           :company
    #
    # Returns a Hash with the new client info, or false if the client was not
    # created successfully.
    def create(options = {})
      perform_request(options.merge(action: 'client-create')) && returned_parameters
    end

    # Public: Change client password for the Solus admin.
    #
    # username     - The client's username
    # new_password - The new password
    #
    # Returns true if the client's password was successfully changed.
    def change_password(username, new_password)
      perform_request(action: "client-updatepassword", username: username, password: new_password)
    end

    # Public: Checks if a specific client exists.
    #
    # username - The client's username
    #
    # Returns true if the client exists.
    def exists?(username)
      perform_request(action: 'client-checkexists', username: username)
    end

    # Public: Verify a client's login.
    #
    # username - The client's username
    # password - The client's password
    #
    # Returns true if the given credentials are correct.
    def authenticate(username, password)
      perform_request(action: 'client-authenticate', username: username, password: password)
    end

    # Public: Deletes an existing client.
    #
    # username - The client's username
    #
    # Returns true if the client was successfully deleted.
    def delete(username)
      perform_request(action: "client-delete", username: username)
    end

    # Public: Lists existing clients.
    #
    # Returns an Array.
    def list
      perform_request({ action: "client-list" }, "client")

      if returned_parameters["clients"] && returned_parameters["clients"]["client"]
        returned_parameters["clients"]["client"]
      elsif returned_parameters["clients"]
        []
      end
    end
  end
end
