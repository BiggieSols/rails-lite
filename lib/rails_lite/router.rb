class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name


  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    request_sym = req.request_method.downcase.to_sym
    action_match = req.request_method.downcase.to_sym == @http_method
    pattern_match = req.path =~ pattern
    action_match && pattern_match
  end

  def run(req, res)
    controller = controller_class.new(req, res, route_params(req))
    controller.invoke_action(action_name)
  end

  def route_params(req)
    match = @pattern.match(req.path)
    captures = match.captures
    names = match.names
    route_params = {}
    names.each_with_index do |name, i|
      route_params[name.to_sym] = captures[i]
    end
    route_params
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each { |route| return route if route.matches?(req) }
    nil
  end

  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
    end
  end
end