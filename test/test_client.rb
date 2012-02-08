require 'helper'

class TestClient < Test::Unit::TestCase

  def setup
    setup_solusvm
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @client = Solusvm::Client.new
  end

  def test_create
    options = {:username => 'vps123', :password=> '123456', :email=> 'email@address.com', :firstname => 'phill', :lastname => 'smith'}
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-create&#{options.to_query}", :body => load_response('client_create_success'))

    params = @client.create(options)
    assert params
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
    assert ! @client.create
    assert_equal 'Empty username field', @client.statusmsg
  end
  
  def test_exists
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-checkexists&username=vps123", :body => load_response('client_exists_success'))
    assert @client.exists?("vps123")
    assert_equal 'Client exists', @client.statusmsg    
  end
  
  def test_change_password
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-updatepassword&username=vps123&password=123456", :body => load_response('client_change_password_success'))    
    assert @client.change_password("vps123","123456")
  end

  def test_change_password_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-updatepassword&username=vps13&password=thecake", :body => load_response('client_change_password_error'))
    assert !@client.change_password("vps13","thecake")
  end

  def test_authenticate
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-authenticate&username=u&password=p", :body => load_response('client_authenticate_success'))
    assert @client.authenticate('u', 'p')
  end

  def test_authenticate_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-authenticate&username=u&password=notp", :body => load_response('client_authenticate_error'))
    assert ! @client.authenticate('u', 'notp')
    assert_equal 'invalid username or password', @client.statusmsg
  end

  def test_delete
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-delete&username=vps123", :body => load_response('client_delete_success'))
    assert @client.delete("vps123")
  end

  def test_delete_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-delete&username=vps123", :body => load_response('error'))
    assert !@client.delete("vps123")
  end

  def test_list
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-list", :body => load_response('client_list_success'))

    clients = @client.list
    assert_equal 1, clients.size

    client = clients.first
    assert_equal "1", client["id"]
    assert_equal "vps123", client["username"]
    assert_equal "vps123@email.com", client["email"]
    assert_equal "phill", client["firstname"]
    assert_equal "smith", client["lastname"]
    assert_equal "VPS Co", client["company"]
    assert_equal "Client", client["level"]
    assert_equal "Active", client["status"]
    assert_equal "2009-01-01", client["created"]
    assert_equal "2010-04-23", client["lastlogin"]
  end

  def test_list_empty
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-list", :body => load_response('client_list_success_empty'))
    assert @client.list.empty?
  end

  def test_list_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=client-list", :body => load_response('error'))
    assert_nil @client.list
  end
end
