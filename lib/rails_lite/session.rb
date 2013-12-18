require 'json'
require 'webrick'

class Session
  attr_accessor :cookie

  def initialize(req)
    @cookie = {}
    req.cookies.each do |cookie|
      puts "cookie name is #{cookie.name}"
      puts "cookie value is #{cookie.value}"
      if cookie.name == "_rails_lite_app"
        @cookie = JSON.parse(cookie.value)
      end
    end
    puts "-----------------"
    puts "cookies are: #{req.cookies}"
    puts "-----------------"

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
