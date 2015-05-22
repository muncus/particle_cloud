# Class to encapsulate operations on a Particle device (Core, Photon, etc).


module Particle

  class Device < Particle::Client

    def initialize(access_token, deviceid, base_url: nil, lazy_init: false)
      @id = deviceid
      super(access_token, base_url: base_url)

      self.delayed_init() unless lazy_init
    end

    def delayed_init
      devinfo_response = @client.get("devices/#{@id}")
      #TODO: check for names which are present in both lists.
      # - is there protection against this?
      if devinfo_response.success?
        devobj = JSON.parse(devinfo_response.body)
        devobj['variables'].keys().each do |v|
          puts "Defining var: #{v}"
          define_method(v) do
            self.variables(v)
          end
        end
        devobj['functions'].keys().each do |f|
          puts "Defining function: #{f}"
          define_method(f) do |**args|
            self.function(f, **args)
          end
        end
        @info_fetched = true
      else
        raise Particle::Error.new("Error fetching device info: #{devinfo_response.body}")
      end
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
      end
    end

    def function(func, **args)
      r = @client.post("devices/#{@id}/#{func}",
                       **args) 
      if r.success?
        JSON.parse(r.body)['return_value']
      end
    end
    
    # variables and functions called before initialization will trigger a call
    # to delayed_init(), populating methods, so they can be called.
    def method_missing(m, *args, &block)
      if not @info_fetched
        delayed_init()
        self.call(m, *args, &block)
      else
        super()
      end
    end
  end

end
