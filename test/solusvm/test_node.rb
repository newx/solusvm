require 'test_helper'

class TestNode < Test::Unit::TestCase
  def setup
    @nodes = SolusVM::Node.new(solusvm_params)
  end

  def test_list
    stub_response 'node/list'

    list = @nodes.list('xen')

    assert @nodes.successful?
    assert list.is_a? Array
    assert_not_empty list
  end

  def test_list_empty
    stub_response 'node/list-empty'

    assert !@nodes.list('openvz')
    assert @nodes.successful?
  end

  def test_nodes_with_invalid_type
    assert !@nodes.list('whatever')
    assert !@nodes.successful?
  end

  def test_list_groups
    stub_response 'node/list-groups'

    list = @nodes.list_groups

    assert @nodes.successful?
    assert list.is_a? Array
    assert_not_empty list
  end

  def test_statistics
    stub_response 'node/statistics'

    stats = @nodes.statistics(1)

    assert @nodes.successful?
    assert stats.is_a? Hash
    assert_not_empty stats
  end

  def test_list_all_ips_available
    stub_response 'node/available-ips'

    list = @nodes.available_ips(1)

    assert @nodes.successful?
    assert list.is_a? Array
    assert_not_empty list
  end

  def test_list_all_ips_not_available
    stub_response 'node/available-ips-empty'

    assert_empty @nodes.available_ips(1)
    assert @nodes.successful?
  end

  def test_ids
    stub_response 'node/ids'

    list = @nodes.ids('xen')

    assert @nodes.successful?
    assert list.is_a? Array
    assert_not_empty list
  end

  def test_nodes_ids_error
    assert !@nodes.ids('whatever')
    assert !@nodes.successful?
  end

  def test_virtualservers
    stub_response 'node/virtualservers'

    servers = @nodes.virtualservers(1)

    assert @nodes.successful?
    assert servers.is_a? Array
    assert servers.all? { |s| s.is_a? Hash }
  end

  def test_virtualservers_empty
    stub_response 'node/virtualservers-empty'

    assert_empty @nodes.virtualservers(1)
    assert @nodes.successful?
  end

  def test_virtualservers_fail
    stub_response 'generic/error'

    assert_nil @nodes.virtualservers(1)
    assert !@nodes.successful?
  end

  def test_xenresources
    stub_response 'node/xenresources'

    node_resources = @nodes.xenresources(1)

    assert @nodes.successful?
    assert node_resources.is_a? Hash
    assert_not_empty node_resources
  end
end
