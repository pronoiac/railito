require 'json'
require 'webrick'
# require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @session = {}
      cookie_spotted = false
      unless req.nil?
        req.cookies.each do |cookie|
          if cookie.name == "_rails_lite_app"
            if $debug # || true
              puts "cookie found!"
              p cookie.name
              p cookie.value
            end
            @session = JSON.parse(cookie.value)
            cookie_spotted = true
          end
        end
      end      
      @session["temp"] = "1st" unless cookie_spotted 
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end
    
    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      addl = WEBrick::Cookie.new("_rails_lite_app", JSON.generate(@session))
      res.cookies << addl
      # puts "debug. addl: "
      # p addl
    end
  end
end
