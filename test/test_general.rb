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
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end

  def test_templates
    FakeWeb.register_uri(:get, "#{base_uri}&action=listtemplates&type=xen", :body => load_response('general_templates_success'))
    actual_templates = @general.templates('xen')
    expected_templates = %w(template1 template2 template3)
    assert_equal expected_templates, actual_templates
  end

  def test_template_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=listtemplates&type=whatever", :body => load_response('error'))
    begin
      @general.templates('whatever')
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end

  def test_node_statistics
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-statistics&nodeid=1", :body => load_response('general_node_statistics_success'))
    node_statistics = @general.node_statistics(1)
    
    assert_equal '1000', node_statistics['freedisk']
    assert_equal '22', node_statistics['sshport']
    assert_equal 'city', node_statistics['city']
    assert_equal 'name', node_statistics['name']
    assert_equal '0', node_statistics['freeips']
    assert_equal 'country', node_statistics['country']
    assert_equal 'x86_64', node_statistics['arch']
    assert_equal '1', node_statistics['id']
    assert_equal '10', node_statistics['freememory']
    assert_equal '2', node_statistics['virtualservers']
    assert_equal '127.0.0.1', node_statistics['ip']
    assert_equal 'hostname.com', node_statistics['hostname']
    assert_equal 'success', node_statistics['status']
  end
end