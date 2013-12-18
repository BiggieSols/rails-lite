require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @route_params = route_params
  end

  def session
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.header["location"] = url
    @res.status = 302
  end


  # started as render_content(content, type)
  def render_content(body, content_type)
    @res.content_type = content_type
    @res.body = body
    @already_built_response = true
  end

  def render(template_name)
    controller = self.class.to_s.underscore
    file_type = "html.erb"
    file_name = "views/#{controller}/#{template_name}.#{file_type}"
    @name = "horatio"
    f = File.read(file_name)
    file_output = ERB.new(f).result(binding)
    render_content(file_output, 'html')
  end

  def invoke_action(name)
  end
end
