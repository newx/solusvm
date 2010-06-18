require 'net/http'
require 'cgi'
require 'rubygems'
require 'xmlsimple'

module Solusvm
  VALID_SERVER_TYPES = ['openvz', 'xen', 'xen hvm']

  def self.config(api_id, api_key, options={})
    @api_id       = api_id
    @api_key      = api_key
    @api_endpoint = URI.parse(options.delete(:url))
    @options      = options
  end

  def self.api_endpoint
    @api_endpoint
  end

  def self.api_endpoint=(value)
    @api_endpoint = value
  end

  def self.validate_server_type!(type)
    unless VALID_SERVER_TYPES.include?(type)
      raise SolusvmError, "Invalid Virtual Server type: #{type}"
    end
  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'solusvm', 'exceptions')
require File.join(directory, 'solusvm', 'hash')
require File.join(directory, 'solusvm', 'base')
require File.join(directory, 'solusvm', 'client')
require File.join(directory, 'solusvm', 'server')
