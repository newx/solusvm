require 'test_helper'
require 'solusvm/cli'

class TestGeneralCli < Test::Unit::TestCase

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

    $stdout.expects(:puts).with("thetemplates")
    SolusVM::Cli.start(cli_expand_base_arguments(["general", "templates", "type"]))
  end

  def test_should_delegate_plans_to_general
    SolusVM::General.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:plans).with("type").returns("theplans")
    end)

    $stdout.expects(:puts).with("theplans")
    SolusVM::Cli.start(cli_expand_base_arguments(["general", "plans", "type"]))
  end

  def test_should_delegate_isos_to_general
    SolusVM::General.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:isos).with("type").returns("theisos")
    end)

    $stdout.expects(:puts).with("theisos")
    SolusVM::Cli.start(cli_expand_base_arguments(["general", "isos", "type"]))
  end
end
