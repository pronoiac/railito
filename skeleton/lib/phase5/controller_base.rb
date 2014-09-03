require_relative '../phase4/controller_base'
require_relative './params'

module Phase5
  class ControllerBase < Phase4::ControllerBase
    attr_reader :params

    # setup the controller
    def initialize(req, res, route_params = {})
      puts "controller init"
      @params = Params.new(req, route_params)
      puts "cont params"
      p @params
    end
    
    #def params
      # debugger
    #  @params
    #end
    
  end
end
