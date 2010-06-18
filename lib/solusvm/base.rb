module Solusvm
  class Base
    attr_reader :returned_parameters, :statusmsg

    def perform_request(options)
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
      XmlSimple.xml_in(body, 'ForceArray' => false)
    end

    def successful?
      returned_parameters['status'] == 'success'
    end

    def api_endpoint
      Solusvm.api_endpoint
    end

    def statusmsg
      returned_parameters['statusmsg']
    end
  end
end