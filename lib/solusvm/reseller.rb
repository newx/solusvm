module Solusvm
  # Solusvm::Server is the class for working with reseller accounts.
  class Reseller < Base
    # Public: Creates a reseller.
    #
    # options - A Hash of options:
    #           :username
    #           :password
    #           :email
    #           :firstname
    #           :lastname
    #           :company        - (optional)
    #           :usernameprefix - prefix for reseller client usernames (optional)
    #           :maxvps         - maximum amount of virtual servers (optional)
    #           :maxusers       - maximum amount of users (optional)
    #           :maxmem         - maximum amount memory (optional)
    #           :maxburst       - maximum amount of burst memory or swapspace
    #                             (optional)
    #           :maxdisk        - maximum amount of diskspace (optional)
    #           :maxbw          - maximum amount of bandwidth (optional)
    #           :maxipv4        - maximum amount of ipv4 addresses (optional)
    #           :maxipv6        - maximum amount of ipv6 addresses (optional)
    #           :nodegroups     - comma separated list of node groups (optional)
    #           :mediagroups    - comma separated list of media groups
    #                             (optional)
    #           :openvz         - y|n Allow building of openvz virtual servers
    #                             (optional)
    #           :xenpv          - y|n Allow building of xen pv virtual servers
    #                             (optional)
    #           :xenhvm         - y|n Allow building of xen hvm virtual servers
    #                             (optional)
    #           :kvm            - y|n Allow building of kvmvirtual servers
    #                             (optional)
    #
    # Returns a Hash with the new client info, or false if the client was not
    # created successfully.
    def create(options = {})
      perform_request(options.merge(action: 'reseller-create')) && returned_parameters
    end

    # Changes the available resources for a specific reseller.
    #
    # options - A Hash of options, see `#create` for details
    #
    # Returns a Hash with the new reseller info, or false if the reseller was
    # not created successfully.
    def change_resources(username, options = {})
      perform_request(options.merge(action: 'reseller-modifyresources', username: username)) && returned_parameters
    end

    # Public: Retrieves information from an existing reseller.
    #
    # username - The reseller's username
    #
    # Returns a Hash with the reseller info, or false if the reseller was not
    # found.
    def info(username)
      perform_request(action: 'reseller-info', username: username) && returned_parameters
    end

    # Public: Deletes an existing reseller.
    #
    # Returns true if the reseller was deleted.
    def delete(username)
      perform_request(action: 'reseller-delete', username: username)
    end

    # Public: Lists existing resellers.
    #
    # Returns an Array.
    def list
      perform_request(action: 'reseller-list')
      parse_returned_params_as_list('usernames')
    end
  end
end
