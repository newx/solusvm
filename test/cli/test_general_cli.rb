require 'helper'
require 'solusvm/cli'

class TestGeneralCli < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)
  end

  def test_should_delegate_templates_to_general
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::General.stubs(:new => mock{ expects(:templates).with("type").returns("thetemplates")})

    $stdout.expects(:puts).with("thetemplates")
    Solusvm::Cli.start(cli_expand_base_arguments(["general", "templates", "type"]))
  end
end