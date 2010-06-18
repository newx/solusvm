require File.dirname(__FILE__) + '/helper'

class TestHash < Test::Unit::TestCase
  def test_reverse_merge
    defaults = { :a => "x", :b => "y", :c => 10 }.freeze
    options  = { :a => 1, :b => 2 }
    expected = { :a => 1, :b => 2, :c => 10 }

    # Should merge defaults into options, creating a new hash.
    assert_equal expected, options.reverse_merge(defaults)
    assert_not_equal expected, options

    # Should merge! defaults into options, replacing options.
    merged = options.dup
    assert_equal expected, merged.reverse_merge!(defaults)
    assert_equal expected, merged
  end

  def test_to_query
    defaults = { :a => "x", :b => "y", :c => 10 }.freeze
    expected = "a=x&b=y&c=10"
    
    assert_equal expected, defaults.to_query
  end
end