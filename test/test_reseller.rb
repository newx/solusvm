require 'helper'

class TestReseller < Test::Unit::TestCase

  def setup
    setup_solusvm
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @reseller = Solusvm::Reseller.new
  end

  def test_create
    options = {:username => 'reseller123', :password=> '123456', :email=> 'reseller3@email.com', :firstname => 'Phill', :lastname => 'Smith'}
    FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-create&#{options.to_query}", :body => load_response('reseller_create_success'))

    params = @reseller.create(options) 

    assert params
    assert_equal options[:username], params['username']
    assert_equal options[:firstname], params['firstname']
    assert_equal options[:lastname], params['lastname']
    assert_equal options[:password], params['password']
    assert_equal options[:email], params['email']
  end

  def test_create_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-create", :body => load_response('error'))
    assert ! @reseller.create
    assert_equal 'error message', @reseller.statusmsg
  end

  def test_change_resources
    options = {:maxvps => 10}
    FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-modifyresources&username=vps123&#{options.to_query}", :body => load_response('reseller_change_resources_success'))    
    
    params = @reseller.change_resources("vps123", options)
    
    assert params
    assert "10", params['maxvps']
  end

  def test_change_resources_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-modifyresources&username=vps13", :body => load_response('error'))
    assert !@reseller.change_resources("vps13")
  end

end