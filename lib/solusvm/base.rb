module Solusvm
  # Solusvm::Base is the main class for mapping API resources as subclasses.
  class Base
    VALID_SERVER_TYPES = ["openvz", "xen", "xen hvm"]

    attr_reader :returned_parameters

    def initialize(config = {})
      @config = config
    end

    # Public: Prepares and sends the API request to the URL specified in
    # `Solusvm.config`.
    #
    # options     - A Hash of options. Any options not listed below are
    #               converted to HTTP query arguments and are passed along to
    #               the API.
    #               :action - Specifies which API method to execute
    # force_array - see parse_response
    #
    # Example
    #
    #     class MyClass < Base
    #       def create_server(name)
    #         perform_request(:action => "name", :id => 1)
    #       end
    #     end
    #
    # Returns true if the request was successful.
    def perform_request(options = {}, force_array = false)
      options.reject! {|_,v| v.nil? }

      response = conn.get api_endpoint, options.merge(api_login)

      @returned_parameters = parse_response(response.status, response.body, force_array)
      log_messages(options)
      successful?
    end

    # Public: Creates a Faraday connection.
    #
    # Returns a Faraday::Connection.
    def conn
      @conn ||= Faraday.new(ssl: ssl_option) do |c|
        c.request :retry if @config.fetch(:retry_request, false)
        c.adapter :net_http
      end
    end

    # Public: SSL options used when creating a Faraday connection.
    #
    # Returns a Hash.
    def ssl_option
      {
        verify: true,
        ca_file: File.expand_path("../../cacert.pem", __FILE__)
      }
    end

    # Public: Converts the XML response to a Hash.
    #
    # status      - Faraday::Response#status
    # body        - Faraday::Response#body
    # force_array - Parses the xml element as an array; can be a string with
    #               the element name or an array with element names
    #
    # Returns a Hash.
    def parse_response(status, body, force_array = false)
      parse_error(status, body) || begin
        force_array = Array(force_array) if force_array
        body        = "<solusrequest>#{body}</solusrequest>"
        XmlSimple.xml_in(body, "ForceArray" => force_array)
      end
    end

    # Public: Parses a returned_parameters value as a list, if present.
    #
    # attribute - The attribute to check
    #
    # Returns an Array or nil.
    def parse_returned_params_as_list(attribute)
      if returned_parameters[attribute] && !returned_parameters[attribute].empty?
        returned_parameters[attribute].to_s.split(",")
      end
    end

    # Public: Parses error responses.
    #
    # status - HTTP status code
    # body   - Raw body
    #
    # Returns a Hash or nil.
    def parse_error(status, body)
      if (200..299).include?(status)
        # Checks for application errors
        case body.downcase
        when /invalid ipaddress/i
          { "status" => "error", "statusmsg" => "This IP is not authorized to use the API" }
        when /Invalid id or key/i
          { "status" => "error", "statusmsg" => "Invalid ID or key" }
        when /Node not found/i
          { "status" => "error", "statusmsg" => "Node does not exist" }
        end
      else
        { "status" => "error", "statusmsg" => "Bad HTTP Status: #{status}" }
      end
    end

    # Public: Check if the request was successful.
    #
    #     my_class = MyClass.new
    #     my_class.create_server("example.com")
    #     my_class.successful? # => true
    #
    # Returns true if the request was successful.
    def successful?
      returned_parameters["status"].nil? || returned_parameters["status"] == "success"
    end

    # Public: Returns the API endpoint set in the instance configuration.
    # Otherwise, it returns the default configuration.
    #
    # Returns a String
    def api_endpoint
      @config.fetch(:url)
    end

    # Public: Returns the API id set in the instance configuration. Otherwise,
    # it returns the default configuration.
    #
    # Returns a String
    def api_id
      @config.fetch(:api_id)
    end

    # Public: Returns the API key set in the instance configuration.
    # Otherwise, it returns the default configuration.
    #
    # Returns a String.
    def api_key
      @config.fetch(:api_key)
    end

    # Public: API options
    #
    # option - Key to fetch
    #
    # Returns the given option.
    def api_options(option)
      if options = @config[:options]
        options[option.to_sym]
      end
    end

    # Public: API login information.
    #
    # Returns a Hash.
    def api_login
      { id: api_id, key: api_key }
    end

    # Public: Logs API actions to the configured logger.
    #
    # options - A Hash of options
    #           :action - the API action
    #
    # Returns nothing.
    def log_messages(options)
      logger, logger_method = api_options(:logger), api_options(:logger_method)

      if logger && logger.respond_to?(logger_method)
        logger.send(logger_method, "[Start] => #{options[:action]}")
        returned_parameters.each do |k,v|
          logger.send(logger_method, "   #{k} => #{v}")
        end
        logger.send(logger_method, "[End] => #{options[:action]}")
      end
    end

    # Public: API response message
    #
    # Returns a String.
    def statusmsg
      returned_parameters["statusmsg"]
    end

    # Public: Validates the server type.
    #
    # type - The server type to check
    #
    # Yields a required block if given server type is valid.
    #
    # Returns the result of the block, or false if the server type is invalid.
    def validate_server_type(type, &block)
      type = type.strip

      if VALID_SERVER_TYPES.include?(type)
        yield
      else
        @returned_parameters = {
          "status"    => "error",
          "statusmsg" => "Invalid Virtual Server type: #{type}"
        }

        false
      end
    end
  end
end
