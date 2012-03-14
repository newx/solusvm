require 'helper'

class TestReseller < Test::Unit::TestCase

  def setup
    setup_solusvm
    @reseller = Solusvm::Reseller.new
  end

  def test_create
    options = {:username => 'reseller123', :password=> '123456', :email=> 'reseller3@email.com', :firstname => 'Phill', :lastname => 'Smith'}
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-create&#{options.to_query}", :body => load_response('reseller_create_success'))
    
    VCR.use_cassette "reseller/create" do
      @reseller.create(options) 
    end
    
    params = @reseller.returned_parameters

    assert params
    assert_equal options[:username], params['username']
    assert_equal options[:firstname], params['firstname']
    assert_equal options[:lastname], params['lastname']
    assert_equal options[:password], params['password']
    assert_equal options[:email], params['email']
  end

  def test_create_fail
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-create", :body => load_response('error'))
    VCR.use_cassette "reseller/create" do
      assert ! @reseller.create
    end
    assert_equal 'error message', @reseller.statusmsg
  end

  def test_change_resources
    options = {:maxvps => 10}
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-modifyresources&username=vps123&#{options.to_query}", :body => load_response('reseller_change_resources_success'))    
    VCR.use_cassette "reseller/change_resources" do
      @reseller.change_resources("vps123", options)
    end
    
    params = @reseller.returned_parameters
    
    assert params
    assert "10", params['maxvps']
  end

  def test_change_resources_fail
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-modifyresources&username=vps13", :body => load_response('error'))
    VCR.use_cassette "reseller/change_resources" do
      assert !@reseller.change_resources("vps13")
    end
  end

  def test_info
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-info&username=vps123", :body => load_response('reseller_info_success'))    
    VCR.use_cassette "reseller/info" do
      @reseller.info("vps123")
    end
    
    params = @reseller.returned_parameters
    
    assert params
    assert_equal "reseller123", params['username']
    assert_equal "Phill", params['firstname']
    assert_equal "Smith", params['lastname']
    assert_equal "123456", params['password']
    assert_equal "reseller3@email.com", params['email']
  end

  def test_info_fail
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-info&username=vps13", :body => load_response('error'))
    VCR.use_cassette "reseller/info" do
      assert !@reseller.info("vps13")
    end
  end

  def test_list
    Solusvm.config("api_id1", api_login[:key], :url => 'http://www.example.com/api')
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-list", :body => load_response('reseller_list_success'))
    VCR.use_cassette "reseller/list" do
      assert_equal %w(username1 username2 username3), @reseller.list
    end
  end

  def test_list_empty
    Solusvm.config("api_id2", api_login[:key], :url => 'http://www.example.com/api')
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-list", :body => load_response('error'))
    VCR.use_cassette "reseller/list" do
      assert !@reseller.list
    end
  end

  def test_delete
    #FakeWeb.register_uri(:get, "#{base_uri}&action=reseller-delete&username=vps123", :body => load_response('reseller_delete_success'))    
    VCR.use_cassette "reseller/delete" do
      assert @reseller.delete("vps123")
    end
  end

end