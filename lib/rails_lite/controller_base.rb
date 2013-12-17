require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @req = req
    @res = res
    @route_params = route_params
  end

  def session
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.set_redirect(302, url)
  end


  # started as render_content(content, type)
  def render_content(body, content_type)
    @res.content_type = content_type
    @res.body = body
    @already_built_response = true
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
