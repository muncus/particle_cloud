# Class to encapsulate operations on a Particle device (Core, Photon, etc).


module Particle

  class Device < Particle::Client

    def initialize(access_token, deviceid, base_url=nil)
      @id = deviceid
      super(access_token, base_url)
      #TODO: fetch device info, define methods for vars and functions:
      # varlist.each do |var|
      #   define_method(var) do 
      #     self.variable(var)
      #   end
      # end
      #
      # funclist.each do |func|
      #   define_method(func) do |**args|
      #     self.function(func, **args)
      #   end
      # end
    end

    def claim
      super(@id)
    end

    def info
      self.device_info(@id)
    end

    def variable(varname)
      r = @client.get("devices/#{@id}/#{varname}")
      if r.success?
        return JSON.parse(r.body)['result']

    def function(func, **args)
      r = @client.post("devices/#{id}/#{func}",
                       **args) 
      if r.success?
        JSON.parse(r.body)['return_value']
    
  end

end
