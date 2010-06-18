module Solusvm
  class Base
    attr_reader :returned_parameters, :statusmsg
    VALID_SERVER_TYPES = ['openvz', 'xen', 'xen hvm']

    def perform_request(options)
      options.merge!(api_login)
      http = Net::HTTP.new(api_endpoint.host, api_endpoint.port)
      http.use_ssl = true if api_endpoint.port == 443
      http.start do |http|
        request = Net::HTTP::Get.new("#{api_endpoint.path}?#{options.to_query}")
        response = http.request(request)
        @returned_parameters = parse_response(response.body)
      end
      unless successful?
        raise SolusvmError, statusmsg
      end
    end

    def parse_response(body)
      body = "<solusrequest>#{body}</solusrequest>"
      XmlSimple.xml_in(body, 'ForceArray' => false)
    end

    def successful?
      returned_parameters['status'] == 'success'
    end

    def api_endpoint
      Solusvm.api_endpoint
    end

    def api_login
      {:id => Solusvm.api_id, :key => Solusvm.api_key}
    end

    def statusmsg
      returned_parameters['statusmsg']
    end

    def validate_server_type!(type)
      unless VALID_SERVER_TYPES.include?(type)
        raise SolusvmError, "Invalid Virtual Server type: #{type}"
      end
    end
  end
end