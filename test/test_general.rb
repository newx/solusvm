require 'helper'

class TestGeneral < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    setup_solusvm
    @general = Solusvm::General.new
  end

  def test_nodes
    FakeWeb.register_uri(:get, "#{base_uri}&action=listnodes&type=xen", :body => load_response('general_nodes_success'))
    assert_equal %w(node1 node2 node3 node4), @general.nodes('xen')
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
    assert_equal %w(template1 template2 template3), @general.templates('xen')
  end

  def test_templates_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=listtemplates&type=whatever", :body => load_response('error'))
    begin
      @general.templates('whatever')
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end

  def test_plans
    FakeWeb.register_uri(:get, "#{base_uri}&action=listplans&type=xen", :body => load_response('general_plans_success'))
    assert_equal %w(plan1 plan2 plan3 plan4), @general.plans('xen')
  end

  def test_plans_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=listplans&type=whatever", :body => load_response('error'))
    begin
      @general.plans('whatever')
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

  def test_list_all_ips_available
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-iplist&nodeid=1", :body => load_response('general_node_list_all_ips_available'))
    assert_equal %w(123.123.123.123 124.124.124.124 125.125.125.125).sort, @general.node_available_ips(1).sort 
  end

  def test_list_all_ips_not_available
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-iplist&nodeid=1", :body => load_response('general_node_list_all_ips_not_available'))
    assert @general.node_available_ips(1).empty?
  end

  def test_nodes_ids
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-idlist&type=xen", :body => load_response('general_nodes_ids_success'))
    assert_equal %w(nodeid1 nodeid2 nodeid3 nodeid4), @general.nodes_ids('xen')
  end

  def test_nodes_ids_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-idlist&type=whatever", :body => load_response('error'))
    begin
      @general.nodes_ids('whatever')
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end

  def test_node_virtualservers
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-virtualservers&nodeid=1", :body => load_response('general_node_virtualservers_success'))

    servers = @general.node_virtualservers(1)
    assert_equal 1, servers.size

    server = servers.first
    assert_equal "theid", server["vserverid"]
    assert_equal "thexid", server["ctid-xid"]
    assert_equal "theclientid", server["clientid"]
    assert_equal "theip", server["ipaddress"]
    assert_equal "thehostname", server["hostname"]
    assert_equal "thetemplate", server["template"]
    assert_equal "thediskspace", server["hdd"]
    assert_equal "thememory", server["memory"]
    assert_equal "theswap", server["swap-burst"]
    assert_equal "thetype", server["type"]
    assert_equal "themac", server["mac"]
  end

  def test_node_virtualservers_empty
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-virtualservers&nodeid=1", :body => load_response('general_node_virtualservers_success_empty'))
    assert @general.node_virtualservers(1).empty?
  end

  def test_node_virtualservers_fail
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-virtualservers&nodeid=1", :body => load_response('error'))
    assert_nil @general.node_virtualservers(1)
  end

  def test_node_xenresources
    FakeWeb.register_uri(:get, "#{base_uri}&action=node-xenresources&nodeid=1", :body => load_response('general_node_xenresources_success'))
    node_resources = @general.node_xenresources(1)
    
    assert_equal 'thefreememory', node_resources['freememory']
    assert_equal 'thefreehdd', node_resources['freehdd']
  end
end
