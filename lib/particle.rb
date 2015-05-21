require 'faraday'
require 'json'
require 'particle/version'

module Particle
  # Simple client for particle.io web services
  # http://docs.particle.io/photon/api/

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

    def claim(device_id)
      # Claim a Core device. returns bool
      post_data = {
        access_token: @access_token,
        id: device_id
      }
      r = @client.post("devices")
      r.success?
    end

    # Access_token-related methods require username and password auth.
    # This helper gets a Faraday connection with the auth headers set,
    # or raises an error.
    def get_connection_with_basic_auth
      if not @username or not @password
        raise Particle::Error.new("username and password must be set " +
            "before interacting with access_tokens")
      end
      conn = Faraday.new(:url => @base_url)
      conn.basic_auth(@username, @password)
      conn
    end

    def access_tokens()
      conn = get_connection_with_basic_auth()
      r = conn.get('access_tokens')
      puts r.body
      if r.success?
        @authtokens = JSON.parse(r.body)
      else
        raise Particle::Error.new "API Error: #{JSON.parse(r.body)}"
      end
    end

    #XXX: the basic auth sent here sets client id on the token, i think?
    # docs not totally clear on that point, but recommend using
    # particle:particle instead of real auth.
    def create_access_token(expires_in=nil, expires_at=nil)
      conn = get_connection_with_basic_auth()
      post_data = {
        grant_type: "password",
        username: @username,
        password: @password}
      if expires_in
        post_data[:expires_in] = expires_in 
      end
      if expires_at
        post_data[:expires_at] = expires_at
      end

      r = conn.post('oauth/token', post_data)
      if r.success?
        puts JSON.parse(r.body)
      else
        raise Particle::Error.new("Token Creation failed: " +
            JSON.parse(r.body))
      end
    end

    def delete_token(access_token)
      c = get_connection_with_basic_auth()
      r = c.delete("access_tokens/#{access_token}")
      if r.success?
        puts JSON.parse(r.body)
      else
        raise Particle::Error.new("Token Delete failed: " +
            JSON.parse(r.body))
      end
    end
      
  end

end
