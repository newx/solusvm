require 'yaml'
require 'thor'
require 'thor/group'
require 'solusvm/version'

module Solusvm
  class BaseCli < Thor
    include Thor::Actions

    class << self
      # Overrides the default banner implementation to output the whole command
      def banner(task, namespace = true, subcommand = false)
        "#{self.namespace.split(":").join(" ")} #{task.formatted_usage(self, false, false)}"
      end

      # Convenience method to get the namespace from the class name. It's the
      # same as Thor default except that the "_cli" at the end of the class
      # is removed.
      def namespace(name=nil)
        if name
          super
        else
          @namespace ||= super.sub(/_cli$/, '')
        end
      end

      # Retrieves default options coming from a configuration file, if any.
      def default_option(key)
        @@yaml ||= begin
          file = File.join(File.expand_path(ENV['HOME']), '.solusvm.yml')
          if File.exists?(file)
            YAML::load(File.open(file))
          else
            {}
          end
        end

        @@yaml[key.to_s]
      end
    end

    # Default required options
    class_option :api_login, type: :string, desc: "API ID; Required.",  aliases: ["-I", "--api-login"]
    class_option :api_key,   type: :string, desc: "API KEY; Required.", aliases: ["-K", "--api-key"]
    class_option :api_url,   type: :string, desc: "API URL; Required.", aliases: ["-U", "--api-url"]

    no_tasks do
      def api
        raise NotImplementedError
      end

      # prints one result element per line, in case it is a list
      def output(result="", color=nil, force_new_line=(result.to_s !~ /( |\t)$/))
        if api.successful?
          Array(result).each do |entry|
            say(entry, color, force_new_line)
          end
        else
          say("Request failed: #{api.statusmsg}", color, force_new_line)
        end
      end
    end

    protected

    def configure
      Solusvm.config(
        present_or_exit(:api_login, :id, "api_login required"),
        present_or_exit(:api_key, :key, "api_key required"),
        url: present_or_exit(:api_url, :url, "api_url required")
      )
    end

    def present_or_exit(options_key, default_option_key, message)
      options[options_key] || BaseCli.default_option(default_option_key) || (say(message) && raise(SystemExit))
    end
  end
end