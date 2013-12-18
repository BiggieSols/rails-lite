require 'json'
require 'webrick'

class Session
  attr_accessor :cookie

  def initialize(req)
    @cookie = {}
    req.cookies.each do |cookie|
      @cookie = JSON.parse(cookie.value) if cookie.name == "_rails_lite_app"
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie.to_json)
  end
end
