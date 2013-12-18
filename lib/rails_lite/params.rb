require 'uri'

class Params
  attr_reader :params

  def initialize(req, route_params)
    @params = parse_www_encoded_form(req.query_string)
  end

  def [](key)
  end

  def to_s
  end

  private
  def parse_www_encoded_form(query_string)
    return nil if query_string.empty?
    params_arr = URI.decode_www_form(query_string)

    params = {}
    params_arr.each do |param|
      params[param.first] = param.last
    end
    params
  end

  def parse_key(key)
  end
end
