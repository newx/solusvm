require 'test_helper'

class TestServer < Test::Unit::TestCase
  def setup
    setup_solusvm
    @server = Solusvm::Server.new
  end

  def test_create
    options = {:hostname => 'server.hostname.com', :type => 'xen', :username => 'bob', :password => '123456',
               :node => 'node1', :plan => 'plan1', :template => 'mytpl', :ips => 1}
    hostname = options.delete(:hostname)
    password = options.delete(:password)
    VCR.use_cassette "server/create" do
      @server.create(hostname, password, options)
    end
    actual = @server.returned_parameters
    assert_equal hostname, actual['hostname']
    assert_equal options[:password], actual['rootpassword']
    assert_equal '100', actual['vserverid']
    assert_equal 'console-123', actual['consoleuser']
    assert_equal '123456', actual['consolepassword']
    assert_equal '123.123.123.123', actual['mainipaddress']
    assert_equal 'vm101|101', actual['virtid']
  end

  def test_create_error
    VCR.use_cassette "server/create" do
      @server.create('', '')
    end
    assert ! @server.successful?
  end

  def test_rebuild
    VCR.use_cassette "server/rebuild" do
      assert @server.rebuild(1, "mytpl")
    end
    assert_equal 'Virtual server is being rebuilt', @server.statusmsg
  end
  
  def test_boot
    VCR.use_cassette "server/boot" do
      assert @server.boot(1)
    end
    assert_equal 'Virtual server booted', @server.statusmsg
  end

  def test_reboot
    VCR.use_cassette "server/reboot" do
      assert @server.reboot(1)
    end
    assert_equal 'Virtual server rebooted', @server.statusmsg
  end

  def test_suspend
    VCR.use_cassette "server/suspend" do
      assert @server.suspend(1)
    end
    assert_equal 'Virtual server suspended', @server.statusmsg
  end

  def test_resume
    VCR.use_cassette "server/resume" do
      assert @server.resume(1)
    end
    assert_equal 'Virtual server unsuspended', @server.statusmsg
  end

  def test_shutdown
    VCR.use_cassette "server/shutdown" do
      assert @server.shutdown(1)
    end
    assert_equal 'Virtual server shutdown', @server.statusmsg
  end

  def test_terminate
    VCR.use_cassette "server/terminate" do
      assert @server.terminate(1)
      assert_equal 'Virtual server terminated', @server.statusmsg

      assert @server.terminate(1, true)
      assert_equal 'Virtual server terminated', @server.statusmsg
    end
  end

  def test_tun_enable
    VCR.use_cassette "server/tun_enable" do
      assert @server.tun_enable(1)
    end
  end

  def test_tun_disable
    VCR.use_cassette "server/tun_disable" do
      assert @server.tun_disable(1)
    end
  end

  def test_network_enable
    VCR.use_cassette "server/network_enable" do
      assert @server.network_enable(1)
    end
  end

  def test_network_disable
    VCR.use_cassette "server/network_disable" do
      assert @server.network_disable(1)
    end
  end

  def test_pae_enable
    VCR.use_cassette "server/pae_enable" do
      assert @server.pae_enable(1)
    end
  end

  def test_pae_disable
    VCR.use_cassette "server/pae_disable" do
      assert @server.pae_disable(1)
    end
  end

  def test_exists
    VCR.use_cassette "server/exists" do
      assert @server.exists?(1)
    end
    assert_equal 'Virtual server exists', @server.statusmsg
  end

  def test_status
    VCR.use_cassette "server/status" do
      assert_equal 'online', @server.status(1)
    end
  end

  def test_add_ip
    VCR.use_cassette "server/add_ip" do
      assert_equal '123.123.123.123', @server.add_ip(1)
    end
    assert_equal 'Ip address added', @server.statusmsg
  end

  def test_del_ip
    VCR.use_cassette "server/del_ip" do
      assert @server.del_ip(1, '123.123.123.123')
    end
  end

  def test_change_plan
    VCR.use_cassette "server/change_plan" do
      assert @server.change_plan(1, 'newplan')
    end
    assert_equal 'Virtual server updated', @server.statusmsg
  end

  def test_change_owner
    VCR.use_cassette "server/change_owner" do
      assert @server.change_owner(1, 2)
    end
  end

  def test_change_consolepass
    VCR.use_cassette "server/change_consolepass" do
      assert @server.change_consolepass(1, "thepassword")
    end
  end

  def test_change_vncpass
    VCR.use_cassette "server/change_vncpass" do
      assert @server.change_vncpass(1, "thepassword")
    end
  end

  def test_change_rootpassword
    VCR.use_cassette "server/change_rootpassword" do
      assert @server.change_rootpassword(1, "thepassword")
    end
  end

  def test_change_bootorder
    VCR.use_cassette "server/change_bootorder" do
      assert @server.change_bootorder(1, :c)
    end
  end

  def test_change_hostname
    VCR.use_cassette "server/change_hostname" do
      assert @server.change_hostname(1, "thehostname")
    end
  end

  def test_info
    VCR.use_cassette "server/info" do
      assert @server.info(1, true)
    end
    VCR.use_cassette "server/info" do
      @server.info(1)
    end
    info = @server.returned_parameters
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
    VCR.use_cassette "server/vnc" do
      @server.vnc(1)
    end
    info = @server.returned_parameters
    assert_equal 'thetype', info['type']
    assert_equal 'thevncip', info['vncip']
    assert_equal 'thevncport', info['vncport']
    assert_equal 'thevncpassword', info['vncpassword']
  end

  def test_console
    VCR.use_cassette "server/console" do
      @server.console(1)
    end
    info = @server.returned_parameters
    assert_equal 'thetype', info['type']
    assert_equal 'theconsoleip', info['consoleip']
    assert_equal 'theconsoleport', info['consoleport']
    assert_equal 'theconsolepassword', info['consolepassword']
    assert_equal 'theconsoleusername', info['consoleusername']
  end
  
  def test_info_all
    VCR.use_cassette "server/info_all" do
      @server.info_all(1)
    end
    info = @server.returned_parameters
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
    VCR.use_cassette "server/mountiso" do
      assert @server.mountiso(1, "theiso")
    end
  end

  def test_unmountiso
    VCR.use_cassette "server/unmountiso" do
      assert @server.unmountiso(1)
    end
  end
end