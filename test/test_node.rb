require 'helper'

class TestNode < Test::Unit::TestCase
  def setup
    setup_solusvm
    @nodes = Solusvm::Node.new
  end

  def test_list
    VCR.use_cassette "node/list" do
      assert_equal %w(node1 node2 node3 node4), @nodes.list('xen')
    end
  end

  def test_list_empty
    VCR.use_cassette "node/list" do    
      assert !@nodes.list('openvz')
    end
  end

  def test_nodes_with_invalid_type
    assert_raise Solusvm::SolusvmError do
      @nodes.list('whatever')
    end
  end

  def test_statistics
    VCR.use_cassette "node/statistics" do
      @nodes.statistics(1)
    end
    
    node_statistics = @nodes.returned_parameters
    
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
    Solusvm.config("api_id1", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "node/available_ips" do
      assert_equal %w(123.123.123.123 124.124.124.124 125.125.125.125).sort, @nodes.available_ips(1).sort 
    end
  end

  def test_list_all_ips_not_available
    Solusvm.config("api_id2", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "node/available_ips" do
      assert @nodes.available_ips(1).empty?
    end
  end

  def test_ids
    VCR.use_cassette "node/ids" do
      assert_equal %w(nodeid1 nodeid2 nodeid3 nodeid4), @nodes.ids('xen')
    end
  end

  def test_nodes_ids_error
    assert_raise Solusvm::SolusvmError do
      @nodes.ids('whatever')
    end
  end

  def test_virtualservers
    Solusvm.config("api_id1", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "node/virtualservers" do
      @nodes.virtualservers(1)
    end
    
    server = @nodes.returned_parameters["virtualservers"]["virtualserver"].first
    
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

  def test_virtualservers_empty
    Solusvm.config("api_id2", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "node/virtualservers" do
      assert @nodes.virtualservers(1).empty?
    end
  end

  def test_virtualservers_fail
    Solusvm.config("api_id3", api_login[:key], :url => 'http://www.example.com/api')
    VCR.use_cassette "node/virtualservers" do
      assert_nil @nodes.virtualservers(1)
    end
  end

  def test_xenresources
    VCR.use_cassette "node/xenresources" do
      @nodes.xenresources(1)
    end
    
    node_resources = @nodes.returned_parameters
    
    assert_equal 'thefreememory', node_resources['freememory']
    assert_equal 'thefreehdd', node_resources['freehdd']
  end
end
