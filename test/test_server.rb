require File.dirname(__FILE__) + '/helper'

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
end