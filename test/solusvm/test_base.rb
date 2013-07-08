require 'test_helper'

class TestBase < Test::Unit::TestCase

  def setup
    setup_solusvm
    @base = Solusvm::Base.new
  end

  def test_valid_server_types
    assert_equal 3, Solusvm::Base::VALID_SERVER_TYPES.size
    assert_equal ['openvz', 'xen', 'xen hvm'].sort, Solusvm::Base::VALID_SERVER_TYPES.sort
  end

  def test_parse_response
    assert_nil @base.returned_parameters
    VCR.use_cassette "base/parse_response" do
      @base.perform_request(action: 'test', vserverid: 1)
    end
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
    VCR.use_cassette "base/successful" do
      @base.perform_request(action: 'testsuccess', vserverid: 1)
      assert @base.successful?

      @base.perform_request(action: 'testfail', vserverid: 1)
      assert_equal "error message", @base.statusmsg

      @base.perform_request(action: 'testnostatus', vserverid: 1)
      assert @base.successful?
    end
  end

  def test_api_login
    assert_equal api_login, @base.api_login
  end

  def test_statusmsg
    VCR.use_cassette "base/statusmsg" do
      @base.perform_request(action: 'testsuccess', vserverid: 1)
    end
    assert_equal 'Virtual server created', @base.statusmsg
  end

  def test_validate_server_type
    Solusvm::Base::VALID_SERVER_TYPES.each do |type|
      assert @base.validate_server_type(type) { true }
    end

    assert !@base.validate_server_type('bob') { true }
    assert !@base.successful?
    assert_equal "Invalid Virtual Server type: bob", @base.statusmsg
  end

  def test_unautorized_ip
    VCR.use_cassette "base/unauthorized_ip" do
      @base.perform_request(action: 'unauthorized')

      assert !@base.successful?
      assert_equal "This IP is not authorized to use the API", @base.statusmsg
    end
  end

  def test_invalid_key_or_id
    VCR.use_cassette "base/invalid_key" do
      @base.perform_request(action: 'badkey')

      assert !@base.successful?
      assert_equal "Invalid ID or key", @base.statusmsg
    end
  end

  def test_node_does_not_exist
    VCR.use_cassette "base/nonexistent_node" do
      @base.perform_request(action: 'nodeexist')

      assert !@base.successful?
      assert_equal "Node does not exist", @base.statusmsg
    end
  end

  def test_invalid_http_status
    VCR.use_cassette "base/invalid_status" do
      @base.perform_request(action: 'httperror')

      assert !@base.successful?
      assert_equal "Bad HTTP Status: 404", @base.statusmsg
    end
  end
end
