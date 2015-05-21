require 'faraday'
require 'json'

module Particle

  DefaultBaseUrl = "https://api.particle.io/v1/"

  class Client
    def initialize(access_token, base_url=nil)
      @access_token = access_token
      @client = Faraday.new(:url => (base_url or DefaultBaseUrl),
                            :params => {access_token: @access_token})
    end

    def devices()
      r = @client.get('devices')
      if r.success?
        @device_list = JSON.parse(r.body)
      else
        raise
      end
    end
      
  end

end
