require 'test/unit'
require 'solusvm'
require 'fake_web'
require 'mocha'
require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = { :record => :none }
end

# Use TURN if available
begin
  require 'turn' if ENV['TURN']
rescue LoadError
end

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

  def cli_expand_base_arguments(options)
    arguments = ["--api-login", "thelogin", "--api-key", "thekey", "--api-url", "theurl"]
    options + arguments
  end

end
