require 'faraday'
require 'json'

module Particle

  class Error < StandardError
    # Generic error class for stuff gone wrong.
  end

  class Client

    DefaultBaseUrl = "https://api.particle.io/v1/"
    attr_writer :password
    attr_accessor :username

    def initialize(access_token, base_url=nil)
      @access_token = access_token
      @base_url = (base_url or DefaultBaseUrl)
      @client = Faraday.new(
          :url => @base_url,
          :headers => {Authorization: "Bearer #{@access_token}"})
    end

    def devices()
      r = @client.get('devices')
      if r.success?
        #TODO: consider using FaradayMiddleware::ParseJson
        @device_list = JSON.parse(r.body)
      else
        raise Particle::Error.new "API Error: #{JSON.parse(r.body)}"
      end
    end

    def auth_tokens()
      conn = Faraday.new(:url => @base_url)
      conn.basic_auth(@username, @password)
      r = conn.get('access_tokens')
      puts r.body
      if r.success?
        @authtokens = JSON.parse(r.body)
      else
        raise Particle::Error.new "API Error: #{JSON.parse(r.body)}"
      end
    end
      
  end

end
