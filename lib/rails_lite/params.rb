require 'uri'

class Params
  attr_reader :params

  def initialize(req, route_params)
    @params = parse_www_encoded_form(req).merge(route_params)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.inspect
  end

  private

  def parse_www_encoded_form(req)
    body = req.body || ""
    query_string = req.query_string || ""

    body_params = URI.decode_www_form(body)
    query_params = URI.decode_www_form(query_string)
    params_arr = body_params.to_a + query_params.to_a

    params_arr.each { |param| param[0] = parse_key(param[0]) }
    params_arr.map(&:flatten)

    params_hash = Hash.new
    params_arr.each_with_index do |param, i|
      keys = param.first
      last_hash = params_hash
      keys.each_with_index do |key, i|
        next if i == keys.length - 1
        last_hash[key] ||= {}
        last_hash = last_hash[key]
      end
      last_hash[keys.last] = param.last
    end
    params_hash
  end

  def parse_key(key)
    key.split /\]\[|\[|\]/
  end
end