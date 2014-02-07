require 'test_helper'

class TestGeneral < Test::Unit::TestCase
  def setup
    @general = Solusvm::General.new(solusvm_params)
  end

  def test_templates
    stub_response 'general/templates'

    list = @general.templates('xen')

    assert list.is_a? Array
    assert_not_empty list
    assert @general.successful?
  end

  # TODO: Refactor so that the lib is not validating server types
  def test_templates_empty
    stub_response 'general/templates-empty'

    assert !@general.templates('xen')
    assert @general.successful?
  end

  def test_templates_with_invalid_type
    assert !@general.templates('badserver')
  end

  def test_plans
    stub_response 'general/plans'

    list = @general.plans('xen')

    assert list.is_a? Array
    assert_not_empty list
    assert @general.successful?
  end

  def test_plans_empty
    stub_response 'general/plans-empty'

    assert !@general.plans('xen')
    assert @general.successful?
  end

  def test_plans_with_invalid_type
    assert !@general.plans('whatever')
  end

  def test_isos
    stub_response 'general/isos'

    list = @general.isos('xen')

    assert list.is_a? Array
    assert_not_empty list
    assert @general.successful?
  end

  def test_isos_empty
    stub_response 'general/isos-empty'

    assert !@general.isos('xen')
    assert @general.successful?
  end

  def test_isos_with_invalid_type
    assert !@general.isos('whatever')
  end
end
