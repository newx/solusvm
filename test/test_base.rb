require 'helper'

class TestBase < Test::Unit::TestCase

  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    setup_solusvm
    @base = Solusvm::Base.new
  end

  def test_valid_server_types
    assert_equal 3, Solusvm::Base::VALID_SERVER_TYPES.size
    assert_equal ['openvz', 'xen', 'xen hvm'].sort, Solusvm::Base::VALID_SERVER_TYPES.sort
  end

  def test_parse_response
    FakeWeb.register_uri(:get, "#{base_uri}&action=test&vserverid=1", :body => load_response('server_create_success'))
    assert_nil @base.returned_parameters
    @base.perform_request(:action => 'test', :vserverid => 1)
    params = @base.returned_parameters

    assert_equal 10, params.size
    assert_equal '123.123.123.123', params['mainipaddress']
    assert_equal 'console-123', params['consoleuser']
    assert_equal '100', params['vserverid']
    assert_equal 'Virtual server created', params['statusmsg']
    assert_equal 'vm101|101', params['virtid']
    assert_equal '123456', params['consolepassword']
    assert_equal '122.122.122.122,111.111.111.111', params['extraipaddress']
    assert_equal 'server.hostname.com', params['hostname']
    assert_equal '123456', params['rootpassword']
    assert_equal 'success', params['status']
  end

  def test_successful
    FakeWeb.register_uri(:get, "#{base_uri}&action=testsuccess&vserverid=1", :body => load_response('server_create_success'))
    FakeWeb.register_uri(:get, "#{base_uri}&action=testfail&vserverid=1", :body => load_response('error'))

    @base.perform_request(:action => 'testsuccess', :vserverid => 1)
    assert @base.successful?

    assert ! @base.perform_request(:action => 'testfail', :vserverid => 1)
    assert_equal "error message", @base.statusmsg
  end

  def test_api_login
    assert_equal api_login, @base.api_login
  end

  def test_statusmsg
    FakeWeb.register_uri(:get, "#{base_uri}&action=testsuccess&vserverid=1", :body => load_response('server_create_success'))
    @base.perform_request(:action => 'testsuccess', :vserverid => 1)
    assert_equal 'Virtual server created', @base.statusmsg
  end

  def test_validate_server_type
    Solusvm::Base::VALID_SERVER_TYPES.each do |type|
      assert_nothing_raised do
        @base.validate_server_type!(type)
      end
    end

    begin
      @base.validate_server_type!('bob')
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert_equal 'Invalid Virtual Server type: bob', e.message
    end
  end

  def test_unautorized_ip
    FakeWeb.register_uri(:get, "#{base_uri}&action=unauthorized", :body => load_response('base_unauthorized_ip'))
    message = ""
    begin
      @base.perform_request(:action => 'unauthorized')
    rescue Exception => e
      message = e
    end
    assert_equal "This IP is not authorized to use the API", message.to_s
  end

  def test_invalid_key_or_id
    FakeWeb.register_uri(:get, "#{base_uri}&action=badkey", :body => load_response('base_bad_key'))
    message = ""
    begin
      @base.perform_request(:action => 'badkey')
    rescue Exception => e
      message = e
    end
    assert_equal "Invalid ID or key", message.to_s
  end

  def test_node_does_not_exist
    FakeWeb.register_uri(:get, "#{base_uri}&action=nodeexist", :body => load_response('base_node_does_not_exist'))
    message = ""
    begin
      @base.perform_request(:action => 'nodeexist')
    rescue Exception => e
      message = e
    end
    assert_equal "Node does not exist", message.to_s
  end

  def test_invalid_http_status
    FakeWeb.register_uri(:get, "#{base_uri}&action=httperror", :body => "", :status => ["404", "Not Found"])
    message = ""
    begin
      @base.perform_request(:action => 'httperror')
    rescue Solusvm::SolusvmError => e
      message = e
    end
    assert_equal "Bad HTTP Status: 404", message.to_s
  end
end
