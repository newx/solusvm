module Solusvm
  class XmlHelper
    attr_reader :output
    def initialize(text)
      if Hash.respond_to?(:from_xml)
        @output = Hash.from_xml(text)
      else
        require 'rubygems'
        require 'xmlsimple'
        @output = XmlSimple.xml_in(text, 'ForceArray' => false)
      end
    end
  end
end