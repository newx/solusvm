require 'net/http'
require 'net/https'
require 'cgi'
require 'rubygems'
require 'xmlsimple'

module Solusvm
  def self.config(api_id, api_key, options={})
    @api_id       = api_id
    @api_key      = api_key
    @api_endpoint = URI.parse(options.delete(:url))
    @api_options  = options
  end

  def self.api_endpoint
    @api_endpoint
  end

  def self.api_endpoint=(value)
    @api_endpoint = value
  end

  def self.api_id
    @api_id
  end

  def self.api_id=(value)
    @api_id = value
  end

  def self.api_key
    @api_key
  end

  def self.api_key=(value)
    @api_key = value
  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'solusvm', 'exceptions')
require File.join(directory, 'solusvm', 'hash')
require File.join(directory, 'solusvm', 'base')
require File.join(directory, 'solusvm', 'general')
require File.join(directory, 'solusvm', 'client')
require File.join(directory, 'solusvm', 'server')
