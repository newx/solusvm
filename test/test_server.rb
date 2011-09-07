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
    FakeWeb.register_uri(:get, "#{base_uri}&type=xen&plan=&action=vserver-create&template=&hostname=&ips=1&username=&password=&node=", :body => load_response('error'))
    @server.create('', '')
    assert ! @server.successful?
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

  def test_exists
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-checkexists&vserverid=1", :body => load_response('server_exists_success'))
    assert @server.exists?(1)
    assert_equal 'Virtual server exists', @server.statusmsg
  end

  def test_status
    #flunk "Implement this"
  end

  def test_add_ip
    #flunk "This is broken on the SolusVM API Level"
  end

  def test_change_plan
    FakeWeb.register_uri(:get, "#{base_uri}&action=vserver-change&vserverid=1&plan=newplan", :body => load_response('server_change_success'))
    assert @server.change_plan(1, 'newplan')
    assert_equal 'Virtual server updated', @server.statusmsg
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
end
