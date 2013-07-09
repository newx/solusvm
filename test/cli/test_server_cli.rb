require 'test_helper'
require 'solusvm/cli'

class TestServerCli < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)
    @solusvm_params = { api_id: "api_id", api_key: "api_key", url: "http://www.example.com/api" }
  end

  def test_should_delegate_server_status_to_server
    Solusvm::Server.expects(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:status).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "status", "thevserverid"]))
  end

  def test_should_delegate_server_change_plan_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_plan).with("thevserverid", "thenewplan").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-plan", "thevserverid", "thenewplan"]))
  end

  def test_should_delegate_server_change_owner_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_owner).with("thevserverid", "thenewowner").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-owner", "thevserverid", "thenewowner"]))
  end

  def test_should_delegate_server_change_consolepass_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_consolepass).with("thevserverid", "thenewpass").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-consolepass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_vncpass_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_vncpass).with("thevserverid", "thenewpass").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-vncpass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_rootpass_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_rootpassword).with("thevserverid", "thenewpass").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-rootpass", "thevserverid", "thenewpass"]))
  end

  def test_should_delegate_server_change_bootorder_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_bootorder).with("thevserverid", "theneworder").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-bootorder", "thevserverid", "theneworder"]))
  end

  def test_should_delegate_server_change_hostname_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_hostname).with("thevserverid", "thenewhostname").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "change-hostname", "thevserverid", "thenewhostname"]))
  end

  def test_should_delegate_server_add_ip_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:add_ip).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "addip", "thevserverid"]))
  end

  def test_should_delegate_server_boot_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:boot).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "boot", "thevserverid"]))
  end

  def test_should_delegate_server_reboot_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:reboot).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "reboot", "thevserverid"]))
  end

  def test_should_delegate_server_shutdown_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:shutdown).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "shutdown", "thevserverid"]))
  end

  def test_should_delegate_server_suspend_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:suspend).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "suspend", "thevserverid"]))
  end

  def test_should_delegate_server_resume_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:resume).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "resume", "thevserverid"]))
  end

  def test_should_delegate_server_check_exists_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:exists?).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "check-exists", "thevserverid"]))
  end

  def test_should_delegate_server_terminate_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:terminate).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "terminate", "thevserverid"]))
  end

  def test_should_delegate_server_rebuild_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:rebuild).with("thevserverid", template: "thetemplate").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "rebuild", "thevserverid", "--template", "thetemplate"]))
  end

  def test_should_delegate_server_tun_switcher_on_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:tun_enable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "tun-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_tun_switcher_off_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:tun_disable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "tun-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_network_switcher_on_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:network_enable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "network-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_network_switcher_off_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:network_disable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "network-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_pae_switcher_on_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:pae_enable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "pae-switcher", "thevserverid", "on"]))
  end

  def test_should_delegate_server_pae_switcher_off_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:pae_disable).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "pae-switcher", "thevserverid", "off"]))
  end

  def test_should_delegate_server_info_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:info).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "info", "thevserverid"]))
  end

  def test_should_delegate_server_vnc_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:vnc).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "vnc", "thevserverid"]))
  end

  def test_should_delegate_server_console_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:console).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "console", "thevserverid"]))
  end

  def test_should_delegate_server_info_all_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:info_all).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "info-all", "thevserverid"]))
  end

  def test_should_delegate_server_mountiso_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:mountiso).with("thevserverid", "theiso").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "mountiso", "thevserverid", "theiso"]))
  end

  def test_should_delegate_server_unmountiso_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:unmountiso).with("thevserverid").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["server", "unmountiso", "thevserverid"]))
  end

  def test_should_delegate_server_create_to_server
    Solusvm::Server.stubs(:new).with(@solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:create).with(
        "thehostname", "thepassword",
        plan: "theplan", ips: "theips", type: "thekind",
        username: "theusername", template: "thetemplate", node: "thenode"
      ).returns("theresult")
    end)

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
