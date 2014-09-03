require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params ||= {}
      parse_query_string(req)
      
    end
    
    def parse_query_string(req)
      query_string = req.query_string
      return nil if query_string.nil?

      paired_key_values = parse_www_encoded_form(query_string)

      # return value unused for now
      @params
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      @params ||= {}
      paired_key_values = URI.decode_www_form(www_encoded_form)
      
      until paired_key_values.empty?
        pair = paired_key_values.shift
        key, value = pair

        hash_path = parse_key(key)
    
        descend = @params
        
        # go down the list
        while hash_path.count > 1
          top = hash_path.shift
          descend[top] = {} unless descend.key?(top)
          descend = descend[top]
        end
        
        # down to one entry - key label
        descend[hash_path.shift] = value
      
      end # /paired_key_values
      
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      split_pat = /
        \]\[| # between one nested key and the next
        \[|   # between top key and the next
        \]    # after bottom key
      /x
      key.split(split_pat)
    end
  end
end
