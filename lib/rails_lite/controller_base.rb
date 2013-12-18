require 'erb'
require 'uri'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @already_built_response = false
    @req = req
    @res = res
    @route_params = route_params
    @params = Params.new(req, route_params).params

    puts "--------------------------------------------------"
    puts "--------------------------------------------------"
    puts "request path is #{req.path}"
    puts "request action is #{req.request_method}"
    puts "request uri is #{req.request_uri}"
    puts "--------------------------------------------------"
    puts "--------------------------------------------------"

  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.header["location"] = url
    @res.status = 302
    @session.store_session(@res)
  end

  # started as render_content(content, type)
  def render_content(body, content_type)
    @res.content_type = content_type
    @res.body = body
    @already_built_response = true
    session.store_session(@res)
  end

  def render(template_name)
    controller = self.class.to_s.underscore
    file_type = "html.erb"
    file_name = "views/#{controller}/#{template_name}.#{file_type}"
    f = File.read(file_name)
    file_output = ERB.new(f).result(binding)
    render_content(file_output, 'html')
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless @already_built_response
  end
end




