# frozen_string_literal: true

require 'net/http'
require 'json'
require './tdx/bus_request'
require './tdx'

module Tdx
  # Taipei bus information for real time near stop
  class RealTimeNearStop < BusRequest
    def bus_infos
      data
    end

    def stop_ids
      bus_infos.map do |bus_info|
        bus_info['StopID']
      end
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
