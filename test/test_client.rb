require 'helper'

class TestClient < Test::Unit::TestCase

  def setup
    setup_solusvm
    @client = Solusvm::Client.new
  end

  def test_create
    options = {:username => 'vps123', :password=> '123456', :email=> 'email@address.com', :firstname => 'phill', :lastname => 'smith'}
    VCR.use_cassette "client/create" do
      @client.create(options)
    end
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
    VCR.use_cassette "client/create" do
      assert ! @client.create
    end
    assert_equal 'Empty username field', @client.statusmsg
  end
  
  def test_exists
    VCR.use_cassette "client/exists" do
      assert @client.exists?("vps123")
    end
    assert_equal 'Client exists', @client.statusmsg    
  end
  
  def test_change_password
    VCR.use_cassette "client/change_password" do
      assert @client.change_password("vps123","123456")
    end
  end

  def test_change_password_fail
    VCR.use_cassette "client/change_password" do
      assert ! @client.change_password("vps13","thecake")
    end
  end

  def test_authenticate
    VCR.use_cassette "client/authenticate" do
      assert @client.authenticate('u', 'p')
    end
  end

  def test_authenticate_fail
    VCR.use_cassette "client/authenticate" do
      assert ! @client.authenticate('u', 'notp')
    end
    assert_equal 'invalid username or password', @client.statusmsg
  end

  def test_delete
    VCR.use_cassette "client/delete" do
      assert @client.delete("vps123")
    end
  end

  def test_delete_fail
    VCR.use_cassette "client/delete" do
      assert !@client.delete("novps")
    end
  end

  def test_list
    Solusvm.config("api_id1", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "client/list" do
      @client.list
    end

    client = @client.returned_parameters["clients"]["client"].first
    
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
    Solusvm.config("api_id2", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "client/list" do
      assert @client.list.empty?
    end
  end

  def test_list_fail
    Solusvm.config("api_id3", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "client/list" do    
      assert_nil @client.list
    end
  end
end