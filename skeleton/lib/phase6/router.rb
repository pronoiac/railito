require "byebug"

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method.to_s.downcase.to_sym
        # the #to_s is because of a spec using *numbers*
      @controller_class = controller_class
      @action_name = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      return false unless @http_method == req.request_method
      return false unless @pattern.match(req.path)
      true
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      # calc route params. route_params = {}
      
      controller = @controller_class.new(req, res, {})
      controller.invoke_action(self.action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.each do |route|
        return route if route.matches?(req)
      end
      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)

      if route.nil?
        res.status = 404
        return nil
      end
      
      route.run(req, res)
    end
  end
end
