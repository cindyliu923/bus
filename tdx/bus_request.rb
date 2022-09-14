# frozen_string_literal: true

require 'net/http'
require 'json'
require './tdx/token'

module Tdx
  # Taipei bus information
  class BusRequest
    attr_reader :bus_number, :bus_direction

    def initialize(bus_number, bus_direction)
      @bus_number = bus_number
      @bus_direction = bus_direction
    end

    private

    def path
      "/api/basic/v2/Bus/#{self.class.name.split('::')[1]}/City/Taipei"
    end

    def access_token
      Tdx::Token.access_token
    end

    def uri
      uri = URI("#{HOST}/#{path}/#{bus_number}")
      uri.query = URI.encode_www_form(params)
      uri
    end

    def params
      {}
    end

    def response
      @response ||= Net::HTTP.get_response(uri, { 'authorization' => "Bearer #{access_token}" })
    end

    def data
      @data ||= JSON.parse(body)
    end

    def body
      response.body
    end
  end
end
