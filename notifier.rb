#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'
require 'net/http'
require 'json'
require 'dotenv/load'
require 'daemons'
require './tdx/stop_of_route'
require './tdx/real_time_near_stop'

# https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html
gemfile do
  source 'https://rubygems.org'
  gem 'terminal-notifier'
  gem 'dotenv'
  gem 'daemons'
end

module Bus
  # Default Taipei { 672 } { 往大鵬新城方向 } 的公車，
  # 到達 { 博仁醫院 } 前 3~5 站時發出通知
  class Notifier
    attr_reader :bus_number, :bus_direction, :bus_station

    def initialize
      @bus_number = ARGV[1] || 672
      @bus_direction = ARGV[2] || 1
      @bus_station = ARGV[3] || '博仁醫院'
    end

    def notify!
      # 如果公車靠近的站牌(StopID)有在 target_stop_ids 裡面就發通知
      return unless near_stop_busses.find { |bus| target_stop_ids.include?(bus['StopID']) }

      TerminalNotifier.notify(
        "Taipei #{bus_number} 的公車，到達 #{bus_station} 的前 3~5 站囉！",
        title: '提醒', subtitle: '要準備出門了'
      )
    end

    def target_stop_ids
      @target_stop_ids ||= find_target_stop_ids
    end

    def near_stop_busses
      @near_stop_busses ||=
        Tdx::RealTimeNearStop.new(bus_number, bus_direction).busses
    end

    private

    def find_target_stop_ids
      stops = Tdx::StopOfRoute.new(bus_number, bus_direction).stops
      target_index = stops.index { |s| s['StopName']['Zh_tw'] == bus_station }
      stops[(target_index - 5)..(target_index - 3)].map do |stop|
        stop['StopID']
      end
    end
  end
end

Daemons.run_proc('bus_notifier') do
  loop do
    notifier = Bus::Notifier.new
    notifier.notify!
    sleep 20
  end
end
