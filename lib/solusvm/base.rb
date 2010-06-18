module Solusvm
  class Base
    attr_reader :returned_parameters

    def perform_request(options)
      http = Net::HTTP.new(api_endpoint.host, api_endpoint.port)
      http.use_ssl = true if self.api_endpoint.port == 443
      http.start do |http|
        request = Net::HTTP::Get.new("#{self.api_endpoint.path}?#{options.to_query}")
        response = http.request(request)
        @returned_parameters = parse_response(response.body)
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
  end
end