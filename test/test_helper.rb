$:.unshift("#{File.dirname(__FILE__)}/../lib")

require 'test/unit'
require 'solusvm'
require 'fake_web'
require 'mocha'
require 'vcr'
require 'set'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :fakeweb
  c.register_request_matcher :uri_with_unordered_params do |request1, request2|
    path1, params1 = request1.uri.split('?')
    path2, params2 = request2.uri.split('?')
    path1 == path2 && Set.new(params1.to_s.split('&')) == Set.new(params2.to_s.split('&'))
  end
  c.default_cassette_options = { :record => :none, :match_requests_on => [:method, :uri_with_unordered_params] }
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
