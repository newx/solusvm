require 'test_helper'

class TestSolusvm < Test::Unit::TestCase
  def test_config
    setup_solusvm
    url = 'http://www.example.com/api'
    assert_equal 'api_id', Solusvm.api_id
    assert_equal 'api_key', Solusvm.api_key
    assert_not_nil Solusvm.api_endpoint
    assert_equal URI.parse(url), Solusvm.api_endpoint
  end
end
