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
    class_option :api_login, :type => :string, :desc => "API ID; Required.",  :aliases => ["-I", "--api-login"], :default => default_option(:id)
    class_option :api_key,   :type => :string, :desc => "API KEY; Required.", :aliases => ["-K", "--api-key"], :default => default_option(:key)
    class_option :api_url,   :type => :string, :desc => "API URL; Required.", :aliases => ["-U", "--api-url"], :default => default_option(:url)

    protected

    def configure
      Solusvm.config(options[:api_login], options[:api_key], :url => options[:api_url])
    end
  end
end