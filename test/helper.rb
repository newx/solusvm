require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'solusvm'
require 'fake_web'

class Test::Unit::TestCase
  def load_response(name)
    File.read(File.join(File.dirname(__FILE__), "fixtures/#{name}.txt"))
  end

  def base_uri
    "#{Solusvm.api_endpoint}?id=api_id&key=api_key"
  end

  def api_login
    {:id => 'api_id', :key => 'api_key'}
  end

  def setup_solusvm
    Solusvm.config(api_login[:id], api_login[:key], :url => 'http://www.example.com/api')
  end

end
