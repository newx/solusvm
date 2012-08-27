module Solusvm
  # Solusvm::Base is the main class for mapping API resources as subclasses.
  class Base
    VALID_SERVER_TYPES = ["openvz", "xen", "xen hvm"]

    attr_reader :returned_parameters

    # Prepares and sends the API request to the URL specificed in Solusvm.config
    #
    #  class MyClass < Base
    #    def create_server(name)
    #      perform_request(:action => "name", :id => 1)
    #    end
    #  end
    #
    # Options:
    # * <tt>:action</tt> - Specifies which API method to execute
    # All other options passed in are converted to http query arguments and are passed along to the API
    #
    # <tt>force_array</tt> - see parse_response
    def perform_request(options = {}, force_array = false)
      ca_path  = File.join(File.dirname(__FILE__), "..", "cacert.pem")
      ssl      = {:verify => true, :ca_file => File.expand_path(ca_path)}

      response = Faraday.new(:url => api_endpoint, :ssl => ssl) do |c|
        c.params = options.merge(api_login)
        c.adapter :net_http
      end.get

      @returned_parameters = parse_response(response.status, response.body, force_array)
      log_messages(options)
      successful?
    end

    # Converts the XML response to a Hash
    #
    # <tt>force_array</tt> - Parses the xml element as an array; can be a string with the element name
    #     or an array with element names
    def parse_response(status, body, force_array = false)
      parse_error(status, body) || begin
        force_array = Array(force_array) if force_array
        body        = "<solusrequest>#{body}</solusrequest>"
        XmlSimple.xml_in(body, "ForceArray" => force_array)
      end
    end

    # Parses a returned_parameters value as a list, if present.
    def parse_returned_params_as_list(attribute)
      if returned_parameters[attribute] && !returned_parameters[attribute].empty?
        returned_parameters[attribute].to_s.split(",")
      end
    end

    # Parses error responses.
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

    # Returns true when a request has been successful
    #
    #   my_class = MyClass.new
    #   my_class.create_server("example.com")
    #   my_class.successful? # => true
    def successful?
      returned_parameters["status"] == "success"
    end

    # URI parsed API URL
    def api_endpoint
      Solusvm.api_endpoint.dup
    end

    def api_login
      {:id => Solusvm.api_id, :key => Solusvm.api_key}
    end

    def log_messages(options)
      logger, logger_method = Solusvm.api_options[:logger], Solusvm.api_options[:logger_method]

      if logger && logger.respond_to?(logger_method)
        logger.send(logger_method, "[Start] => #{options[:action]}")
        returned_parameters.each do |k,v|
          logger.send(logger_method, "   #{k} => #{v}")
        end
        logger.send(logger_method, "[End] => #{options[:action]}")
      end
    end

    # API response message
    def statusmsg
      returned_parameters["statusmsg"]
    end

    # Validates the server type.
    def validate_server_type(type, &block)
      type = type.strip

      if valid = VALID_SERVER_TYPES.include?(type)
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
