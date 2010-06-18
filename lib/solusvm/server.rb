module Solusvm
  class Server < Base
    def create(hostname, password, client, options = {})
      options.reverse_merge!(
        :type         => 'xen',
        :username     => client,
        :ips          => 1,
        :node         => nil,
        :plan         => nil,
        :template     => nil,
        :rootpassword => password,
        :hostname     => hostname
      ).merge!(:action => 'vserver-create')
      perform_request(options)
    end

    def boot(vid)
      perform_request(:action => 'vserver-boot', :vserver => vid)
    end

    def reboot(vid)
      perform_request(:action => 'vserver-reboot', :vserver => vid)
    end

    def suspend(vid)
      perform_request(:action => 'vserver-suspend', :vserver => vid)
    end

    def resume(vid)
      perform_request(:action => 'vserver-unsuspend', :vserver => vid)
    end

    def shutdown(vid)
      perform_request(:action => 'vserver-shutdown', :vserver => vid)
    end

    def terminate(vid, deleteclient = false)
      perform_request(:action => 'vserver-shutdown', :vserver => vid, :deleteclient => deleteclient)
    end

    def exists?(vid)
      perform_request(:action => 'vserver-checkexists', :vserverid => vid)
      statusmsg.match /Virtual server exists/
    end

    def status(vid)
      perform_request(:action => 'vserver-status', :vserverid => vid)
      statusmsg
    end

    def add_ip(vid)
      perform_request(:action => 'vserver-addip', :vserver => vid)
    end

    def change_plan(vid, plan)
      perform_request(:action => 'vserver-change', :vserver => vid, :plan => plan)
    end
  end
end