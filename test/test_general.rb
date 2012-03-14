require 'helper'

class TestGeneral < Test::Unit::TestCase
  def setup
    setup_solusvm
    @general = Solusvm::General.new
  end

  def test_templates
    VCR.use_cassette "general/templates" do
      assert_equal %w(template1 template2 template3), @general.templates('xen')
    end
  end

  # TODO: Refactor so that the lib is not validating server types
  def test_templates_empty
    VCR.use_cassette "general/templates" do
      assert !@general.templates('openvz')
    end
  end

  def test_templates_with_invalid_type
    VCR.use_cassette "general/templates" do
      assert_raise Solusvm::SolusvmError do
        @general.templates('badserver')
      end
    end
  end

  def test_plans
    VCR.use_cassette "general/plans" do
      assert_equal %w(plan1 plan2 plan3 plan4), @general.plans('xen')
    end
  end

  def test_plans_empty
    VCR.use_cassette "general/plans" do
      assert !@general.plans('openvz')
    end
  end

  def test_plans_with_invalid_type
    VCR.use_cassette "general/plans" do
      assert_raise Solusvm::SolusvmError do
        @general.plans('whatever')
      end
    end
  end

  def test_isos
    VCR.use_cassette "general/isos" do
      assert_equal %w(iso1 iso2 iso3), @general.isos('xen')
    end
  end

  def test_isos_empty
    VCR.use_cassette "general/isos" do
      assert !@general.isos('openvz')
    end
  end

  def test_isos_with_invalid_type
    VCR.use_cassette "general/isos" do
      assert_raise Solusvm::SolusvmError do
        @general.isos('whatever')
      end
    end
  end
end