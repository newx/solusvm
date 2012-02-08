require 'helper'
require 'solusvm/cli'

class TestServerCli < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)
  end

  def test_should_delegate_server_status_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:status).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "status", "thevserverid"]))
  end

  def test_should_delegate_server_changeplan_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_plan).with("thevserverid", "thenewplan").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "changeplan", "thevserverid", "thenewplan"]))
  end

  def test_should_delegate_server_add_ip_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:add_ip).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "addip", "thevserverid"]))
  end

  def test_should_delegate_server_boot_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:boot).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "boot", "thevserverid"]))
  end

  def test_should_delegate_server_reboot_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:reboot).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "reboot", "thevserverid"]))
  end

  def test_should_delegate_server_shutdown_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:shutdown).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "shutdown", "thevserverid"]))
  end

  def test_should_delegate_server_suspend_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:suspend).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "suspend", "thevserverid"]))
  end

  def test_should_delegate_server_resume_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:resume).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "resume", "thevserverid"]))
  end

  def test_should_delegate_server_check_exists_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:check_exists).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "check-exists", "thevserverid"]))
  end

  def test_should_delegate_server_terminate_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:terminate).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "terminate", "thevserverid"]))
  end

  def test_should_delegate_server_rebuild_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:rebuild).with(
      "thevserverid", :template => "thetemplate").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "rebuild", "thevserverid", "--template", "thetemplate"]))
  end

  def test_should_delegate_server_create_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:create).with(
      "thehostname", "thepassword", 
      :plan => "theplan", :ips => "theips", :type => "thekind", 
      :username => "theusername", :template => "thetemplate", :node => "thenode"
    ).returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments([
      "server", "create", 
      "thehostname", 
      "thepassword", 
      "--plan", "theplan",
      "--ips", "theips",
      "--kind", "thekind",
      "--username", "theusername",
      "--template", "thetemplate",
      "--node", "thenode"
    ]))
  end

end