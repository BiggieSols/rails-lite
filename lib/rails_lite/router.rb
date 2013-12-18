class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    action_match = req.request_method.downcase.to_sum == @action_name
    pattern_match = req.path =~ pattern
    action_match && pattern_match
  end

  def run(req, res)
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
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |pattern, controller_class, action_name|
      pattern = Regexp.new(pattern.gsub(/\d+/, "\\d+"))
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each { |route| return route if route.matches?(req) }
    nil
  end

  def run(req, res)
    ControllerBase.new(req, res)
  end
end

# users\/\d+\/edit
