require 'test_helper'

class TestClient < Test::Unit::TestCase
  def setup
    @client = SolusVM::Client.new(solusvm_params)
  end

  def test_create
    stub_response 'client/create'

    options = {
      username:  'vps123',
      password:  '123456',
      email:     'email@address.com',
      firstname: 'phill',
      lastname:  'smith'
    }

    assert @client.create(options).is_a? Hash
    assert @client.successful?
  end

  def test_create_fail
    stub_response 'generic/error'

    assert !@client.create
  end

  def test_exists
    stub_response 'client/exists'

    assert @client.exists?("vps123")
    assert @client.successful?
  end

  def test_change_password
    stub_response 'client/change-password'

    assert @client.change_password("vps123","123456")
    assert @client.successful?
  end

  def test_change_password_fail
    stub_response 'generic/error'

    assert !@client.change_password("vps13","thecake")
  end

  def test_authenticate
    stub_response 'client/authenticate'

    assert @client.authenticate('u', 'p')
    assert @client.successful?
  end

  def test_authenticate_fail
    stub_response 'generic/error'

    assert !@client.authenticate('u', 'notp')
  end

  def test_delete
    stub_response 'client/delete'

    assert @client.delete("vps123")
    assert @client.successful?
  end

  def test_delete_fail
    stub_response 'generic/error'

    assert !@client.delete("novps")
  end

  def test_list
    stub_response 'client/list'

    list = @client.list

    assert list.is_a? Array
    assert_not_empty list
  end

  def test_list_empty
    stub_response 'client/list-empty'

    list = @client.list

    assert list.is_a? Array
    assert_empty @client.list
  end

  def test_list_fail
    stub_response 'generic/error'

    assert_nil @client.list
  end
end
