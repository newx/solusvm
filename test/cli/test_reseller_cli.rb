require 'test_helper'
require 'solusvm/cli'

class TestResellerCli < Test::Unit::TestCase

  def setup
    # Prevents mocha from stubbing non existent methods so that we now if the CLI is failing because
    # something was moved around.
    Mocha::Configuration.prevent(:stubbing_non_existent_method)
  end

  def test_should_delegate_reseller_create_to_reseller
    Solusvm::Reseller.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:create).with() do |options|
        expected = {
          username: "theusername",
          password: "thepassword",
          email: "theemail",
          firstname: "thefirstname",
          lastname: "thelastname",
          company: "thecompany",
          usernameprefix: "theusernameprefix",
          maxvps: "themaxvps",
          maxusers: "themaxusers",
          maxmem: "themaxmem",
          maxburst: "themaxburst",
          maxdisk: "themaxdisk",
          maxbw: "themaxbw",
          maxipv4: "themaxipv4",
          maxipv6: "themaxipv6",
          nodegroups: "thenodegroups",
          mediagroups: "themediagroups",
          openvz: "theopenvz",
          xenpv: "thexenpv",
          xenhvm: "thexenhvm",
          kvm: "thekvm"
        }

        expected.all? { |k,v| options[k] == v }
      end.returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments([
      "reseller", "create",
      "--username", "theusername",
      "--password", "thepassword",
      "--email", "theemail",
      "--firstname", "thefirstname",
      "--lastname", "thelastname",
      "--company", "thecompany",
      "--usernameprefix", "theusernameprefix",
      "--maxvps", "themaxvps",
      "--maxusers", "themaxusers",
      "--maxmem", "themaxmem",
      "--maxburst", "themaxburst",
      "--maxdisk", "themaxdisk",
      "--maxbw", "themaxbw",
      "--maxipv4", "themaxipv4",
      "--maxipv6", "themaxipv6",
      "--nodegroups", "thenodegroups",
      "--mediagroups", "themediagroups",
      "--openvz", "theopenvz",
      "--xenpv", "thexenpv",
      "--xenhvm", "thexenhvm",
      "--kvm", "thekvm"
    ]))
  end

  def test_should_delegate_reseller_change_resources_to_reseller
    Solusvm::Reseller.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:change_resources).with() do |options|
        expected = {
          maxvps: "themaxvps",
          maxusers: "themaxusers",
          maxmem: "themaxmem",
          maxburst: "themaxburst",
          maxdisk: "themaxdisk",
          maxbw: "themaxbw",
          maxipv4: "themaxipv4",
          maxipv6: "themaxipv6",
          nodegroups: "thenodegroups",
          mediagroups: "themediagroups",
          openvz: "theopenvz",
          xenpv: "thexenpv",
          xenhvm: "thexenhvm",
          kvm: "thekvm"
        }

        expected.all? { |k,v| options[k] == v }
      end.returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments([
      "reseller", "change-resources",
      "--maxvps", "themaxvps",
      "--maxusers", "themaxusers",
      "--maxmem", "themaxmem",
      "--maxburst", "themaxburst",
      "--maxdisk", "themaxdisk",
      "--maxbw", "themaxbw",
      "--maxipv4", "themaxipv4",
      "--maxipv6", "themaxipv6",
      "--nodegroups", "thenodegroups",
      "--mediagroups", "themediagroups",
      "--openvz", "theopenvz",
      "--xenpv", "thexenpv",
      "--xenhvm", "thexenhvm",
      "--kvm", "thekvm"
    ]))
  end

  def test_should_delegate_reseller_info_to_reseller
    Solusvm::Reseller.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:info).with("theusername").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["reseller", "info", "theusername"]))
  end

  def test_should_delegate_reseller_delete_to_reseller
    Solusvm::Reseller.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
      expects(:delete).with("theusername").returns("theresult")
    end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["reseller", "delete", "theusername"]))
  end

  def test_should_delegate_reseller_list_to_reseller
    Solusvm::Reseller.expects(:new).with(solusvm_params).returns(mock do
      expects(:successful?).returns(true)
     expects(:list).returns("theresult")
   end)

    $stdout.expects(:puts).with("theresult")
    Solusvm::Cli.start(cli_expand_base_arguments(["reseller", "list"]))
  end
end
