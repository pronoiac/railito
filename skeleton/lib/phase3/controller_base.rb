require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'
# require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
      @already_built_response = false
    end
    
    def already_built_response?
      @already_built_response
    end
    
    def render(template_name)
      raise if already_built_response?
      # @already_built_response = true
      
      # file: views/#{controller_name}/#{template_name}.html.erb).
      controller_name = self.class.to_s.underscore # e.g. my_controller
      # e.g. template_name = show.html.erb
      read_template = File.read "views/#{controller_name}/#{template_name}.html.erb"
      processed = ERB.new(read_template).result(binding) 
      render_content(processed, "text/html")
    end

  end
end
