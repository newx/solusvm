require 'stringio'
require 'test/unit'
require 'solusvm'
require 'mocha/setup'
require 'sham_rack'
require 'set'

module Kernel
  # Public: Redirect $stdout to an instance of StringIO.
  #
  # Returns the captured output as a StringIO.
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end

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

  # Public: API login credentials.
  #
  # Returns a Hash.
  def api_login
    {
      id:  'api_id',
      key: 'api_key'
    }
  end

  # Public: Parameters used when sending a request to the SolusVM API.
  #
  # Returns a Hash.
  def solusvm_params
    {
      api_id:  api_login[:id],
      api_key: api_login[:key],
      url:     'http://www.example.com/api'
    }
  end

  # Public: Arguments used for testing CLI.
  #
  # options - Extra arguments to use
  #
  # Returns an Array.
  def cli_expand_base_arguments(options)
    options + [
      "--api-login", "#{solusvm_params[:api_id]}",
      "--api-key", "#{solusvm_params[:api_key]}",
      "--api-url", "#{solusvm_params[:url]}"
    ]
  end
end
