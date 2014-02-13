require 'test_helper'

class TestServer < Test::Unit::TestCase
  def setup
    @server = SolusVM::Server.new(solusvm_params)
  end

  def test_create
    stub_response 'server/create'

    options = {
      type:     'xen',
      username: 'bob',
      node:     'node1',
      plan:     'plan1',
      template: 'mytpl',
      ips:      1
    }

    hostname = 'test.com'
    password = '123456'

    assert @server.create(hostname, password, options).is_a? Hash
    assert @server.successful?
  end

  def test_create_error
    stub_response 'generic/error'

    assert !@server.create('', '')
    assert !@server.successful?
  end

  def test_rebuild
    stub_response 'server/rebuild'

    assert @server.rebuild(1, "mytpl")
    assert @server.successful?
  end

  def test_boot
    stub_response 'server/boot'

    assert @server.boot(1)
    assert @server.successful?
  end

  def test_reboot
    stub_response 'server/reboot'

    assert @server.reboot(1)
    assert @server.successful?
  end

  def test_suspend
    stub_response 'server/suspend'

    assert @server.suspend(1)
    assert @server.successful?
  end

  def test_resume
    stub_response 'server/resume'

    assert @server.resume(1)
    assert @server.successful?
  end

  def test_shutdown
    stub_response 'server/shutdown'

    assert @server.shutdown(1)
    assert @server.successful?
  end

  def test_terminate
    stub_response "server/terminate"

    assert @server.terminate(1)
    assert @server.successful?

    assert @server.terminate(1, true)
    assert @server.successful?
  end

  def test_tun_enable
    stub_response 'server/tun-enable'

    assert @server.tun_enable(1)
    assert @server.successful?
  end

  def test_tun_disable
    stub_response 'server/tun-disable'

    assert @server.tun_disable(1)
    assert @server.successful?
  end

  def test_network_enable
    stub_response 'server/network-enable'

    assert @server.network_enable(1)
    assert @server.successful?
  end

  def test_network_disable
    stub_response 'server/network-disable'

    assert @server.network_disable(1)
    assert @server.successful?
  end

  def test_pae_enable
    stub_response 'server/pae-enable'

    assert @server.pae_enable(1)
    assert @server.successful?
  end

  def test_pae_disable
    stub_response 'server/pae-disable'

    assert @server.pae_disable(1)
    assert @server.successful?
  end

  def test_exists
    stub_response 'server/exists'

    assert @server.exists?(1)
    assert @server.successful?
  end

  def test_status
    stub_response 'server/status'

    assert_equal 'online', @server.status(1)
    assert @server.successful?
  end

  def test_add_ip
    stub_response 'server/add-ip'

    assert_equal '123.123.123.123', @server.add_ip(1)
    assert @server.successful?
  end

  def test_del_ip
    stub_response 'server/del-ip'

    assert @server.del_ip(1, '123.123.123.123')
    assert @server.successful?
  end

  def test_change_plan
    stub_response 'server/change-plan'

    assert @server.change_plan(1, 'newplan')
    assert @server.successful?
  end

  def test_change_owner
    stub_response 'server/change-owner'

    assert @server.change_owner(1, 2)
    assert @server.successful?
  end

  def test_change_vncpass
    stub_response 'server/change-vncpass'

    assert @server.change_vncpass(1, "vncpassword")
    assert @server.successful?
  end

  def test_change_rootpassword
    stub_response 'server/change-rootpassword'

    assert @server.change_rootpassword(1, "rootpassword")
    assert @server.successful?
  end

  def test_change_bootorder
    stub_response 'server/change-bootorder'

    assert @server.change_bootorder(1, :c)
    assert @server.successful?
  end

  def test_change_hostname
    stub_response 'server/change-hostname'

    assert @server.change_hostname(1, 'hostname')
    assert @server.successful?
  end

  def test_info
    stub_response 'server/info'

    assert @server.info(1, true).is_a? Hash
    assert @server.successful?

    assert @server.info(1).is_a? Hash
    assert @server.successful?
  end

  def test_vnc
    stub_response 'server/vnc'

    assert @server.vnc(1).is_a? Hash
    assert @server.successful?
  end

  def test_console
    stub_response 'server/console'

    assert @server.console(1).is_a? Hash
    assert @server.successful?

    assert @server.console(1, access: "admin", time: 1).is_a? Hash
    assert @server.successful?
  end

  def test_info_all
    stub_response 'server/info-all'

    assert @server.info_all(1).is_a? Hash
    assert @server.successful?
  end

  def test_mountiso
    stub_response 'server/mountiso'

    assert @server.mountiso(1, "theiso")
    assert @server.successful?
  end

  def test_unmountiso
    stub_response 'server/unmountiso'

    assert @server.unmountiso(1)
    assert @server.successful?
  end
end
