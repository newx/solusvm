module Solusvm
  class Server < Base
    def create(hostname, password, client, options = {})
      options.reverse_merge!(
        :type         => 'xen',
        :username     => client,
        :ips          => 1,
        :action       => 'vserver-create',
        :rootpassword => password,
        :hostname     => hostname
      )
      perform_request(options)
    end
  end
end