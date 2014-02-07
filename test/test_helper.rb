$:.unshift("#{File.dirname(__FILE__)}/../lib")

require 'test/unit'
require 'solusvm'
require 'mocha/setup'
require 'sham_rack'
require 'set'
require 'json'

class Test::Unit::TestCase
  # Public: Stubs a JSON reponse using ShamRack.
  #
  # name - The name of a JSON file in `test/sham_rack_stubs/`
  #
  # Returns Sinatra::Wrapper.
  def stub_response(name)
    setup_sham_rack do
      path = File.expand_path("../sham_rack_stubs/#{name}.json", __FILE__)
      File.read(path)
    end
  end

  # Public: Setup a ShamRack response using Sinatra.
  #
  # block - Required block, passed to Sinatra's `get` method when setting up a
  #         the `/api` route
  #
  # Returns Sinatra::Wrapper.
  def setup_sham_rack(&block)
    ShamRack.at(URI.parse(solusvm_params[:url]).host).sinatra do
      get("/api", &block)
    end
  end

  def api_login
    {id: 'api_id', key: 'api_key'}
  end

  def solusvm_params
    {
      api_id:  api_login[:id],
      api_key: api_login[:key],
      url:     'http://www.example.com/api'
    }
  end

  def cli_expand_base_arguments(options)
    arguments = ["--api-login", "api_id", "--api-key", "api_key", "--api-url", "http://www.example.com/api"]
    options + arguments
  end
end
