require 'uri'
require "byebug"

# this is a prototype, not part of the controller.

def parse_www_encoded_form(www_encoded_form)
  @params = {}
  paired_key_values = URI.decode_www_form(www_encoded_form)
  puts "URI decode: "
  p paired_key_values
  
  until paired_key_values.empty?
    pair = paired_key_values.shift
    key, value = pair
    # @params[key] = value
    
    # debugger
    
    puts "parse_key: "
    hash_path = parse_key(key)
    p hash_path
    
    top = hash_path.shift
    @params[top] = {} unless @params.key?(top)
    descend = @params[top]

    while hash_path.count > 1
      top = hash_path.shift
      descend[top] = {} unless descend.key?(top)
      descend = descend[top]
    end
    
    descend[hash_path.shift] = value
      
  end # /paired_key_values
  
  puts "params: "
  p @params
end


def parse_key(key)
  split_pat = /
    \]\[| # between one nested key and the next
    \[|   # between top key and the next
    \]    # after bottom key
  /x
  key.split(split_pat)
  
  
end

def testing  
  text = "user[address][street]"
  puts "=== parse key: testing #{text}:"
  p parse_key(text)
  puts "ideal: ['user', 'address', 'street']"
  puts "actual: { 'user' => { 'address' => 'street' }"

  puts
  text = "user[address][street]=main&user[address][zip]=89436"
  puts "=== testing parse_www: #{text}"
  decode = parse_www_encoded_form("user[address][street]=main&user[address][zip]=89436")
  decode.each 
  puts 'ideal: { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }'
  
end

testing
  