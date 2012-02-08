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

  def test_should_delegate_server_change_plan_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_plan).with("thevserverid", "thenewplan").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-plan", "thevserverid", "thenewplan"]))
  end

  def test_should_delegate_server_change_owner_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_owner).with("thevserverid", "thenewowner").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-owner", "thevserverid", "thenewowner"]))
  end

  def test_should_delegate_server_change_consolepass_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_consolepass).with("thevserverid", "thenewpass").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-consolepass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_vncpass_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_vncpass).with("thevserverid", "thenewpass").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-vncpass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_rootpass_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_rootpassword).with("thevserverid", "thenewpass").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-rootpass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_bootorder_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_bootorder).with("thevserverid", "theneworder").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-bootorder", "thevserverid", "theneworder"]))
  end

  def test_should_delegate_server_change_hostname_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:change_hostname).with("thevserverid", "thenewhostname").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-hostname", "thevserverid", "thenewhostname"]))
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

  def test_should_delegate_server_tun_switcher_on_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:tun_enable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "tun-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_tun_switcher_off_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:tun_disable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "tun-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_network_switcher_on_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:network_enable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "network-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_network_switcher_off_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:network_disable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "network-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_pae_switcher_on_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:pae_enable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "pae-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_pae_switcher_off_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:pae_disable).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "pae-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_info_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:info).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "info", "thevserverid"]))
  end

  def test_should_delegate_server_vnc_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:vnc).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "vnc", "thevserverid"]))
  end

  def test_should_delegate_server_console_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:console).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "console", "thevserverid"]))
  end

  def test_should_delegate_server_info_all_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:info_all).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "info-all", "thevserverid"]))
  end

  def test_should_delegate_server_mountiso_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:mountiso).with("thevserverid", "theiso").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "mountiso", "thevserverid", "theiso"]))
  end

  def test_should_delegate_server_unmountiso_to_server
    Solusvm.expects(:config).with("thelogin", "thekey", { :url => "theurl" })
    Solusvm::Server.stubs(:new => mock{ expects(:unmountiso).with("thevserverid").returns("theresult") })

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "unmountiso", "thevserverid"]))
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