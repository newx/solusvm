require File.dirname(__FILE__) + '/helper'

class TestGeneral < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    setup_solusvm
    @general = Solusvm::General.new
  end

  def test_nodes
    FakeWeb.register_uri(:get, "#{base_uri}&action=listnodes&type=xen", :body => load_response('general_nodes_success'))
    actual_nodes = @general.nodes('xen')
    expected_nodes = %w(node1 node2 node3 node4)
    assert_equal expected_nodes, actual_nodes
  end

  def test_nodes_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=listnodes&type=whatever", :body => load_response('error'))
    begin
      @general.nodes('whatever')
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end
end