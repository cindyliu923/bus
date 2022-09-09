# frozen_string_literal: true

require 'net/http'
require 'json'
require './tdx'

module Tdx
  class Token
    ENDPOINT = '/auth/realms/TDXConnect/protocol/openid-connect/token'

    def access_token
      return data['access_token'] unless expired?

      refresh_token
      data['access_token']
    end

    private

    def expired_at
      @expired_at ||= Time.now + data['expires_in'].to_i
    end

    def expired?
      Time.now >= expired_at
    end

    def refresh_token
      @response = nil
      @data = nil
      @expired_at = nil
    end

    def response
      @response ||= Net::HTTP.post_form(
        URI("#{HOST}#{ENDPOINT}"),
        grant_type: 'client_credentials',
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      )
    end

    def data
      @data ||= JSON.parse(body)
    end

    def body
      response.body
    end
  end
end
