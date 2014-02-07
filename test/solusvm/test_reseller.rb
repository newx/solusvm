require 'test_helper'

class TestReseller < Test::Unit::TestCase
  def setup
    @reseller = Solusvm::Reseller.new(solusvm_params)
  end

  def test_create
    options = {
      username:  'apitest3',
      password:  '123456',
      email:     'email@address.com',
      firstname: 'Phill',
      lastname:  'Smith'
    }

    stub_response 'reseller/create'

    assert @reseller.create(options).is_a? Hash
    assert @reseller.successful?
  end

  def test_create_fail
    stub_response 'generic/error'

    assert !@reseller.create
    assert !@reseller.successful?
  end

  def test_change_resources
    stub_response 'reseller/change-resources'

    assert @reseller.change_resources("vps123", maxvps: 10).is_a? Hash
    assert @reseller.successful?
  end

  def test_change_resources_fail
    stub_response 'generic/error'

    assert !@reseller.change_resources("vps13")
    assert !@reseller.successful?
  end

  def test_info
    stub_response 'reseller/info'

    assert @reseller.info("vps123").is_a? Hash
    assert @reseller.successful?
  end

  def test_info_fail
    stub_response 'generic/error'

    assert !@reseller.info("vps13")
    assert !@reseller.successful?
  end

  def test_list
    stub_response 'reseller/list'

    list = @reseller.list

    assert list.is_a? Array
    assert_not_empty list
    assert @reseller.successful?
  end

  def test_list_empty
    stub_response 'reseller/list-empty'

    assert !@reseller.list
    assert @reseller.successful?
  end

  def test_delete
    stub_response 'reseller/delete'

    assert @reseller.delete("vps123")
    assert @reseller.successful?
  end
end
