# frozen_string_literal: true

require 'net/http'
require 'json'
require './tdx/bus_request'
require './tdx'

module Tdx
  class RealTimeNearStop < BusRequest
    def busses
      data
    end

    private

    def params
      {
        '$filter' => "Direction eq #{bus_direction}",
        '$orderby' => 'StopSequence',
        '$format' => 'JSON'
      }
    end
  end
end
