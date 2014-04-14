require 'test_helper'
require 'solusvm/cli'

class TestGeneralCLI < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)
  end

  def test_should_delegate_templates_to_general
    SolusVM::General.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:templates).with("type").returns("thetemplates")
    end)

    out = capture_stdout do
      SolusVM::CLI.start(cli_expand_base_arguments(["general", "templates", "type"]))
    end
    assert_match "thetemplates", out.string
  end

  def test_should_delegate_plans_to_general
    SolusVM::General.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:plans).with("type").returns("theplans")
    end)

    out = capture_stdout do
      SolusVM::CLI.start(cli_expand_base_arguments(["general", "plans", "type"]))
    end
    assert_match "theplans", out.string
  end

  def test_should_delegate_isos_to_general
    SolusVM::General.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:isos).with("type").returns("theisos")
    end)

    out = capture_stdout do
      SolusVM::CLI.start(cli_expand_base_arguments(["general", "isos", "type"]))
    end
    assert_match "theisos", out.string
  end
end
