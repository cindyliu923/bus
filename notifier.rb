# frozen_string_literal: true

require './tdx/stop_of_route'
require './tdx/real_time_near_stop'

module Bus
  # Default Taipei { 672 } { 往大鵬新城方向 } 的公車，
  # 到達 { 捷運六張犁站(基隆路) } 前 3~5 站時發出通知
  class Notifier
    attr_reader :bus_number, :bus_direction, :bus_station

    def initialize
      @bus_number = ARGV[1] || 672
      @bus_direction = ARGV[2] || 1
      @bus_station = ARGV[3] || '捷運六張犁站(基隆路)'
    end

    def notify!
      # 如果公車靠近的站牌(StopID)有在 target_stop_ids 裡面就發通知
      return unless bus_near_stop_ids.find { |stop_id| target_stop_ids.include?(stop_id) }

      TerminalNotifier.notify(
        "Taipei #{bus_number} 的公車，到達 #{bus_station} 的前 3~5 站囉！",
        title: '提醒', subtitle: '要準備出門了'
      )
    end

    def target_stop_ids
      @target_stop_ids ||= find_target_stop_ids
    end

    def bus_near_stop_ids
      @bus_near_stop_ids ||=
        Tdx::RealTimeNearStop.new(bus_number, bus_direction).stop_ids
    end

    private

    def find_target_stop_ids
      stops = Tdx::StopOfRoute.new(bus_number, bus_direction).stops
      target_index = stops.index { |s| s['StopName']['Zh_tw'] == bus_station }
      raise ArgumentError, 'bus stop not exist!' unless target_index

      stops[(target_index - 5)..(target_index - 3)].map do |stop|
        stop['StopID']
      end
    end
  end
end
