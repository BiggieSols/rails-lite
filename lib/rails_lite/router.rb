# require 'debugger'

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name


  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    debugger
    request_sym = req.request_method.downcase.to_sym
    action_match = req.request_method.downcase.to_sym == @http_method
    pattern_match = req.path =~ pattern
    action_match && pattern_match
  end

  def run(req, res)
    controller = controller_class.new(req, res)
    controller.invoke_action(action_name)
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

  # get Regexp.new("^/statuses/(?<id>\\d+)$"), StatusController, :show

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |pattern, controller_class, action_name|
      # pattern = Regexp.new(pattern.gsub(/:id/, "\\d+"))
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each { |route| return route if route.matches?(req) }
    nil
  end

  def run(req, res)
    puts "RUNNING ROUTER"
    # puts "available routes are #{@routes.map(&:pattern)}"
    route = match(req)
    if route
      puts "ROUTE EXISTS: #{route.pattern}"
      route.run(req, res)
    else
      puts "ROUTE DOES NOT EXIST"
      res.status = 404
    end
  end
end

r = Router.new
p r.methods - r.class.methods
# users\/\d+\/edit
