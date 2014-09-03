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
      @params
    end
    
    def parse_query_string(req)
      puts "debug:"
      # p req
      query_string = req.query_string
      return nil if query_string.nil?
      puts "QS"
      p query_string
      puts "/QS"
      paired_key_values = URI.decode_www_form(query_string)
      #  parse_www_encoded_form(query_string)
      until paired_key_values.empty?
        puts "PKV"
        p paired_key_values
        puts "pair"
        pair = paired_key_values.shift
        p pair
        key, value = pair
        puts "KV"
        p key
        p value
        @params[key] = value      
      end
      puts "params"
      p @params
      @params
    end

    def [](key)
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
      puts "PWEF"
      hmm = URI.decode_www_form(www_encoded_form)
      # hmm = www_encoded_form.decode_www_form
      p hmm
      hmm
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
    end
  end
end
