require 'net/http'
require 'net/https'
require 'cgi'

module Solusvm
  class << self
    attr_accessor :api_endpoint, :api_id, :api_key

    # Sepcifies the login and url for making requests
    #
    # example:
    #
    #   Solusvm.config('id', 'key', :url => 'http://www.example.com/api')
    #
    def config(api_id, api_key, options={})
      @api_id       = api_id
      @api_key      = api_key
      @api_endpoint = URI.parse(options.delete(:url))
      @api_options  = options
    end
  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'solusvm', 'exceptions')
require File.join(directory, 'solusvm', 'xml_helper')
require File.join(directory, 'solusvm', 'hash')
require File.join(directory, 'solusvm', 'base')
require File.join(directory, 'solusvm', 'general')
require File.join(directory, 'solusvm', 'client')
require File.join(directory, 'solusvm', 'server')
