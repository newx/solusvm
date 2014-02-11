require 'test_helper'

class TestBase < Test::Unit::TestCase
  def setup
    @base = SolusVM::Base.new(solusvm_params)
  end

  def test_valid_server_types
    assert_equal 3, SolusVM::Base::VALID_SERVER_TYPES.size
    assert_equal ['openvz', 'xen', 'xen hvm'].sort, SolusVM::Base::VALID_SERVER_TYPES.sort
  end

  def test_parse_response
    assert_nil @base.returned_parameters

    stub_response 'base/parse-response'

    assert @base.perform_request(action: 'test', vserverid: 1)

    res = @base.returned_parameters
    assert res.is_a? Hash
    assert_not_empty res
  end

  def test_successful
    stub_response 'base/parse-response'

    @base.perform_request(action: 'testsuccess', vserverid: 1)
    assert @base.successful?

    stub_response 'generic/error'

    @base.perform_request(action: 'testsuccess', vserverid: 1)
    assert !@base.successful?
  end

  def test_api_login
    assert_equal api_login, @base.api_login
  end

  def test_statusmsg
    stub_response 'base/parse-response'

    assert @base.perform_request(action: 'testsuccess')
    assert_equal 'The status message', @base.statusmsg
  end

  def test_validate_server_type
    SolusVM::Base::VALID_SERVER_TYPES.each do |type|
      assert @base.validate_server_type(type) { true }
    end

    assert !@base.validate_server_type('bob') { true }
    assert !@base.successful?
    assert_equal "Invalid Virtual Server type: bob", @base.statusmsg
  end

  def test_unautorized_ip
    setup_sham_rack { "Invalid ipaddress" }

    assert_raise SolusVM::AuthenticationError do
      assert !@base.perform_request(action: 'unauthorized')
    end
  end

  def test_invalid_key_or_id
    setup_sham_rack { "Invalid id or key" }

    assert_raise SolusVM::AuthenticationError do
      assert !@base.perform_request(action: 'badkey')
    end
  end

  def test_node_does_not_exist
    setup_sham_rack { "Node not found" }

    assert !@base.perform_request(action: 'nodeexist')
    assert_equal "Node does not exist", @base.statusmsg
  end

  def test_invalid_http_status
    setup_sham_rack { status 404 }

    assert !@base.perform_request(action: 'httperror')
    assert_equal "Bad HTTP Status: 404", @base.statusmsg
  end
end
