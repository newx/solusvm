module Solusvm
  class Reseller < Base

    # Creates a reseller.
    #
    # Options:
    #
    # * <tt>:username</tt>
    # * <tt>:password</tt>
    # * <tt>:email</tt>
    # * <tt>:firstname</tt>
    # * <tt>:lastname</tt>
    # * <tt>:company</tt> - (optional)
    # * <tt>:usernameprefix</tt> - prefix for reseller client usernames (optional)
    # * <tt>:maxvps</tt> - maximum amount of virtual servers (optional)
    # * <tt>:maxusers</tt> - maximum amount of users (optional)
    # * <tt>:maxmem</tt> - maximum amount memory - (optional)
    # * <tt>:maxburst</tt> - maximum amount of burst memory or swapspace (optional)
    # * <tt>:maxdisk</tt> - maximum amount of diskspace (optional)
    # * <tt>:maxbw</tt> - maximum amount of bandwidth (optional)
    # * <tt>:maxipv4</tt> - maximum amount of ipv4 addresses (optional)
    # * <tt>:maxipv6</tt> - maximum amount of ipv6 addresses (optional)
    # * <tt>:nodegroups</tt> - comma seperated list of node groups (optional)
    # * <tt>:mediagroups</tt> - comma seperated list of media groups (optional)
    # * <tt>:openvz</tt> - y|n Allow building of openvz virtual servers (optional)
    # * <tt>:xenpv</tt> - y|n Allow building of xen pv virtual servers (optional)
    # * <tt>:xenhvm</tt> - y|n Allow building of xen hvm virtual servers (optional)
    # * <tt>:kvm</tt> - y|n Allow building of kvmvirtual servers (optional)
    def create(options ={})
      perform_request(options.merge(:action => 'reseller-create')) && returned_parameters
    end

    # Changes the available resources for a specific reseller.
    #
    # Options:
    #
    # * <tt>:maxvps</tt> - maximum amount of virtual servers (optional)
    # * <tt>:maxusers</tt> - maximum amount of users (optional)
    # * <tt>:maxmem</tt> - maximum amount memory - (optional)
    # * <tt>:maxburst</tt> - maximum amount of burst memory or swapspace (optional)
    # * <tt>:maxdisk</tt> - maximum amount of diskspace (optional)
    # * <tt>:maxbw</tt> - maximum amount of bandwidth (optional)
    # * <tt>:maxipv4</tt> - maximum amount of ipv4 addresses (optional)
    # * <tt>:maxipv6</tt> - maximum amount of ipv6 addresses (optional)
    # * <tt>:nodegroups</tt> - comma seperated list of node groups (optional)
    # * <tt>:mediagroups</tt> - comma seperated list of media groups (optional)
    # * <tt>:openvz</tt> - y|n Allow building of openvz virtual servers (optional)
    # * <tt>:xenpv</tt> - y|n Allow building of xen pv virtual servers (optional)
    # * <tt>:xenhvm</tt> - y|n Allow building of xen hvm virtual servers (optional)
    # * <tt>:kvm</tt> - y|n Allow building of kvmvirtual servers (optional)
    def change_resources(username, options={})
      perform_request(options.merge(:action => 'reseller-modifyresources', :username => username)) && returned_parameters
    end

    # Retrieves information from an existing reseller.
    def info(username)
      perform_request({:action => 'reseller-info', :username => username}) && returned_parameters
    end

    # Deletes an existing reseller.
    def delete(username)
      perform_request({:action => 'reseller-delete', :username => username})
    end

    # Lists existing resellers.
    def list
      perform_request(:action => 'reseller-list')
      parse_returned_params_as_list('usernames')
    end

  end
end