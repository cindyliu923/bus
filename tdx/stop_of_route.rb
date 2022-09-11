# frozen_string_literal: true

require 'net/http'
require 'json'
require './tdx/bus_request'
require './tdx'

module Tdx
  # Taipei bus information for stop of route
  class StopOfRoute < BusRequest
    def stops
      data[0]['Stops']
    end

    private

    def params
      {
        '$filter' => "Direction eq #{bus_direction}",
        '$format' => 'JSON'
      }
    end
  end
end
