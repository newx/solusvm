module Solusvm
  class SolusvmErrors < Faraday::Response::Middleware

    def on_complete(env)
      if (200..299).include? env[:status]
        # Checks for application errors
        case env[:body].downcase
        when /invalid ipaddress/i
          raise "This IP is not authorized to use the API"
        when /Invalid id or key/i
          raise "Invalid ID or key"
        when /Node not found/i
          raise "Node does not exist"
        end
      else
        raise SolusvmError, "Bad HTTP Status: #{env[:status]}"
      end

    end

  end
end