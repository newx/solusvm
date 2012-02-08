require 'helper'

class TestGeneral < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    setup_solusvm
    @general = Solusvm::General.new
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

  def test_isos
    FakeWeb.register_uri(:get, "#{base_uri}&action=listiso&type=xen", :body => load_response('general_isos_success'))
    assert_equal %w(iso1 iso2 iso3), @general.isos('xen')
  end

  def test_isos_error
    FakeWeb.register_uri(:get, "#{base_uri}&action=listiso&type=whatever", :body => load_response('error'))
    begin
      @general.isos('whatever')
      flunk "Shouldn't get here"
    rescue Solusvm::SolusvmError => e
      assert e.message.match /Invalid Virtual Server type/
    end
  end
end