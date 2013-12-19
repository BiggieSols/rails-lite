require 'active_support/core_ext'
require 'json'
require 'webrick'
require 'rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class ExampleController < ControllerBase
  def create
    render_content(params.to_s, "text/json")
  end

  def new
    page = <<-END
<form action="/" method="post">
  <input type="text" name="cat[name]">
  <input type="text" name="cat[owner]">

  <input type="submit">
</form>
END

    render_content(page, "text/html")
  end
end

server.mount_proc '/' do |req, res|
  case req.path
  when '/'
    contr = ExampleController.new(req, res).create
  when '/new'
    contr = ExampleController.new(req, res).new
  end
end

server.start


=begin
router draws routes
request comes in from server
router determines if request matches any existing routes (if not 404)
if route matches, then the route "runs"
when running, a route creates a new controller of the appropriate class
  (based on http request)
when the class is created, it is told to invoke_action
  which action? this is given in the http request and should match the cntrlr method
if there is a method, then great. otherwise try to render the template


=end
