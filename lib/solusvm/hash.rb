class Hash
  unless method_defined?(:to_query)
    def to_query
      elements = []
      self.each do |key, value|
        elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
      end
      elements.join('&')
    end
  end

  unless method_defined?(:reverse_merge)
    def reverse_merge(other_hash)
      other_hash.merge(self)
    end
  end

  unless method_defined?(:reverse_merge!)
    def reverse_merge!(other_hash)
      replace(reverse_merge(other_hash))
    end
  end
end