require_relative '../phase3/controller_base'
require_relative './session'
# require "byebug"

module Phase4
  class ControllerBase < Phase3::ControllerBase
    # overriding from p02: 
    # Set the response status code and header
    def redirect_to(url)
      super(url)
      session.store_session(res)
    end

    # overriding from p03
    def render_content(content, type)
      super(content, type)
      session.store_session(res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
    
    
    
    
  end
end
