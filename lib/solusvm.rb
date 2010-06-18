require 'net/http'
require 'cgi'
require 'rubygems'
require 'xmlsimple'

module Solusvm
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
end

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory, 'solusvm', 'hash')
require File.join(directory, 'solusvm', 'base')
require File.join(directory, 'solusvm', 'server')
