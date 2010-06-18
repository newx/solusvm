require 'helper'

class TestBase < Test::Unit::TestCase

  def setup
    setup_solusvm
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @client = Solusvm::Client.new
  end

  def test_create
    options = {:username => 'vps123', :password=> '123456', :email=> 'email@address.com', :firstname => 'phill', :lastname => 'smith'}
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-create&#{options.to_query}", :body => load_response('client_create_success'))
    assert @client.create(options)

    params = @client.returned_parameters
    assert_equal options[:username], params['username']
    assert_equal options[:firstname], params['firstname']
    assert_equal options[:lastname], params['lastname']
    assert_equal options[:password], params['password']
    assert_equal options[:email], params['email']
    assert_equal 'Successfully added client', params['statusmsg']
    assert_equal 'success', params['status']
  end

  def test_create_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-create", :body => load_response('client_create_error'))
    begin
      @client.create
    rescue Solusvm::SolusvmError => e
      assert_equal 'Empty username field', e.message
    end
  end

  def test_authenticate
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-authenticate&username=u&password=p", :body => load_response('client_authenticate_success'))
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-authenticate&username=u&password=notp", :body => load_response('client_authenticate_error'))
    assert @client.authenticate('u', 'p')

    begin
      @client.authenticate('u', 'notp')
    rescue Solusvm::SolusvmError => e
      assert_equal 'invalid username or password', e.message
    end
    
  end
end