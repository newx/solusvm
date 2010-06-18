require 'helper'

class TestSolusvm < Test::Unit::TestCase
  def test_config
    url = 'http://www.example.com/api'
    s = Solusvm.config('api_id', 'api_key', :url => url, :something => true)
    assert_equal 'api_id', Solusvm.api_id
    assert_equal 'api_key', Solusvm.api_key
    assert_not_nil Solusvm.api_endpoint
    assert_equal URI.parse(url), Solusvm.api_endpoint
  end
end
