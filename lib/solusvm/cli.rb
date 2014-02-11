require 'solusvm'
require 'solusvm/cli/base_cli'
require 'solusvm/cli/server_cli'
require 'solusvm/cli/node_cli'
require 'solusvm/cli/general_cli'
require 'solusvm/cli/reseller_cli'
require 'solusvm/cli/client_cli'

module SolusVM
  class CLI < Thor
    register(ServerCLI,  'server', 'server <command>', 'Server commands')
    register(NodeCLI,    'node', 'node <command>', 'Node commands')
    register(GeneralCLI, 'general', 'general <command>', 'General commands')
    register(ResellerCLI, 'reseller', 'reseller <command>', 'Reseller commands')
    register(ClientCLI, 'client', 'client <command>', 'Client commands')

    desc "version", "Outputs the current program version"
    def version
      say SolusVM::VERSION
    end
  end
end
