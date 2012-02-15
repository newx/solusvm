require 'helper'
require 'solusvm/cli'

class TestBaseCli < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)

    @base_cli = Solusvm::BaseCli.new
  end

  def test_should_print_multiple_lines_if_enumerable
    @base_cli.expects(:say).with("val1", nil, true).returns("val1")
    @base_cli.expects(:say).with("val2", nil, true).returns("val2")

    @base_cli.output(["val1", "val2"])
  end
end