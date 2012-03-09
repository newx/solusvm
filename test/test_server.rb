require 'helper'

class TestServer < Test::Unit::TestCase
  def setup
    setup_solusvm
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @server = Solusvm::Server.new
  end

  def test_create
    options = {:hostname => 'server.hostname.com', :type => 'xen', :username => 'bob', :password => '123456',
               :node => 'node1', :plan => 'plan1', :template => 'mytpl', :ips => 1}
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-create&#{options.to_query}", :body => load_response('server_create_success'))
    hostname = options.delete(:hostname)
    password = options.delete(:password)
    actual = @server.create(hostname, password, options)
    assert_equal hostname, actual['hostname']
    assert_equal options[:password], actual['rootpassword']
    assert_equal '100', actual['vserverid']
    assert_equal 'console-123', actual['consoleuser']
    assert_equal '123456', actual['consolepassword']
    assert_equal '123.123.123.123', actual['mainipaddress']
    assert_equal 'vm101|101', actual['virtid']
  end

  def test_create_error
    FakeWeb.register_uri(:get, "#{base_uri}&type=xen&plan&action=vserver-create&template&hostname=&ips=1&username&password=&node", :body => load_response('error'))
    @server.create('', '')
    assert ! @server.successful?
  end

  def test_rebuild
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-rebuild&vserverid=1&template=mytpl", :body => load_response('server_rebuild_success'))
    assert @server.rebuild(1, "mytpl")
    assert_equal 'Virtual server is being rebuilt', @server.statusmsg
  end
  
  def test_boot
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-boot&vserverid=1", :body => load_response('server_boot_success'))
    assert @server.boot(1)
    assert_equal 'Virtual server booted', @server.statusmsg
  end

  def test_reboot
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-reboot&vserverid=1", :body => load_response('server_reboot_success'))
    assert @server.reboot(1)
    assert_equal 'Virtual server rebooted', @server.statusmsg
  end

  def test_suspend
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-suspend&vserverid=1", :body => load_response('server_suspend_success'))
    assert @server.suspend(1)
    assert_equal 'Virtual server suspended', @server.statusmsg
  end

  def test_resume
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-unsuspend&vserverid=1", :body => load_response('server_resume_success'))
    assert @server.resume(1)
    assert_equal 'Virtual server unsuspended', @server.statusmsg
  end

  def test_shutdown
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-shutdown&vserverid=1", :body => load_response('server_shutdown_success'))
    assert @server.shutdown(1)
    assert_equal 'Virtual server shutdown', @server.statusmsg
  end

  def test_terminate
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-terminate&vserverid=1&deleteclient=false", :body => load_response('server_terminate_success'))
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-terminate&vserverid=1&deleteclient=true", :body => load_response('server_terminate_success'))
    assert @server.terminate(1)
    assert_equal 'Virtual server terminated', @server.statusmsg

    assert @server.terminate(1, true)
    assert_equal 'Virtual server terminated', @server.statusmsg
  end

  def test_tun_enable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-tun-enable&vserverid=1", :body => load_response('server_tun_enable_success'))
    assert @server.tun_enable(1)
  end

  def test_tun_disable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-tun-disable&vserverid=1", :body => load_response('server_tun_disable_success'))
    assert @server.tun_disable(1)
  end

  def test_network_enable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-network-enable&vserverid=1", :body => load_response('server_network_enable_success'))
    assert @server.network_enable(1)
  end

  def test_network_disable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-network-disable&vserverid=1", :body => load_response('server_network_disable_success'))
    assert @server.network_disable(1)
  end

  def test_pae_enable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-pae&vserverid=1&pae=on", :body => load_response('server_pae_success'))
    assert @server.pae_enable(1)
  end

  def test_pae_disable
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-pae&vserverid=1&pae=off", :body => load_response('server_pae_success'))
    assert @server.pae_disable(1)
  end

  def test_exists
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-checkexists&vserverid=1", :body => load_response('server_exists_success'))
    assert @server.exists?(1)
    assert_equal 'Virtual server exists', @server.statusmsg
  end

  def test_status
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-status&vserverid=1", :body => load_response('server_status_success'))
    assert_equal 'online', @server.status(1)
  end

  def test_add_ip
    #flunk "This is broken on the SolusVM API Level"
  end

  def test_change_plan
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-change&vserverid=1&plan=newplan", :body => load_response('server_change_success'))
    assert @server.change_plan(1, 'newplan')
    assert_equal 'Virtual server updated', @server.statusmsg
  end

  def test_change_owner
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-changeowner&vserverid=1&clientid=2", :body => load_response('server_change_owner_success'))
    assert @server.change_owner(1, 2)
  end

  def test_change_consolepass
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-consolepass&vserverid=1&consolepassword=thepassword", :body => load_response('server_change_consolepass_success'))
    assert @server.change_consolepass(1, "thepassword")
  end

  def test_change_vncpass
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-vncpass&vserverid=1&vncpassword=thepassword", :body => load_response('server_change_vncpass_success'))
    assert @server.change_vncpass(1, "thepassword")
  end

  def test_change_rootpassword
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-rootpassword&vserverid=1&rootpassword=thepassword", :body => load_response('server_rootpassword_success'))
    assert @server.change_rootpassword(1, "thepassword")
  end

  def test_change_bootorder
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-bootorder&vserverid=1&bootorder=c", :body => load_response('server_bootorder_success'))
    assert @server.change_bootorder(1, :c)
  end

  def test_change_hostname
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-hostname&vserverid=1&hostname=thehostname", :body => load_response('server_hostname_success'))
    assert @server.change_hostname(1, "thehostname")
  end

  def test_info
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-info&vserverid=1&reboot=true", :body => load_response('server_info_success'))
    assert @server.info(1, true)

    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-info&vserverid=1&reboot=false", :body => load_response('server_info_success'))
    info = @server.info(1)

    assert info
    assert_equal '1', info['vserverid']
    assert_equal '1', info['ctid-xid']
    assert_equal '1', info['clientid']
    assert_equal 'host.example.com', info['hostname']
    assert_equal '123.123.123.123', info['ipaddress']
    assert_equal 'vps1', info['template']
    assert_equal '123456', info['hdd']
    assert_equal '123456', info['memory']
    assert_equal 'swp', info['swap-burst']
    assert_equal 'xenhvm', info['type']
  end

  def test_vnc
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-vnc&vserverid=1", :body => load_response('server_vnc_success'))
    info = @server.vnc(1)

    assert info
    assert_equal 'thetype', info['type']
    assert_equal 'thevncip', info['vncip']
    assert_equal 'thevncport', info['vncport']
    assert_equal 'thevncpassword', info['vncpassword']
  end

  def test_console
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-console&vserverid=1", :body => load_response('server_console_success'))
    info = @server.console(1)

    assert info
    assert_equal 'thetype', info['type']
    assert_equal 'theconsoleip', info['consoleip']
    assert_equal 'theconsoleport', info['consoleport']
    assert_equal 'theconsolepassword', info['consolepassword']
    assert_equal 'theconsoleusername', info['consoleusername']
  end
  
  def test_info_all
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-infoall&vserverid=1", :body => load_response('server_infoall_success'))
    info = @server.info_all(1)
    assert_equal "success", info["status"]
    assert_equal "123.123.123.123", info["mainipaddress"]
    assert_equal "tydeus", info["node"]
    assert_equal "openvz", info["type"]
    assert_equal "16106127360000,5370261749139,10735865610861,33", info["bandwidth"]
    assert_equal "1073741824,187097088,886644736,17", info["memory"]
    assert_equal "236223201280,103640707072,132582494208,44", info["hdd"]
    assert_equal "/graphs/9/214/214-8f7daef90bc75037489af4217af674a67df545ba05c8a6bcd5341d5894f2f905bf23976f52c0104415c1694135d51f204ddfd7b11bbe87c195a5de4a-86400.png", info["trafficgraph"]
    assert_equal "/graphs/9/214/214-load-8f7daef90bc75037489af4217af674a67df545ba05c8a6bcd5341d5894f2f905bf23976f52c0104415c1694135d51f204ddfd7b11bbe87c195a5de4a-86400.png", info["loadgraph"]
    assert_equal "/graphs/9/214/214-mem-8f7daef90bc75037489af4217af674a67df545ba05c8a6bcd5341d5894f2f905bf23976f52c0104415c1694135d51f204ddfd7b11bbe87c195a5de4a-86400.png", info["memorygraph"]    
  end

  def test_mountiso
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-mountiso&vserverid=1&iso=theiso", :body => load_response('server_mountiso_success'))
    assert @server.mountiso(1, "theiso")
  end

  def test_unmountiso
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-unmountiso&vserverid=1", :body => load_response('server_unmountiso_success'))
    assert @server.unmountiso(1)
  end
end
