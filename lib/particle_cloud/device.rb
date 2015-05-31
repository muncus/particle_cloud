# Class to encapsulate operations on a Particle device (Core, Photon, etc).


module ParticleCloud

  class Device < ParticleCloud::Client

    attr_reader :name
    attr_reader :id

    def initialize(access_token, deviceid, name: nil, base_url: nil, lazy_init: false)
      @id = deviceid
      @name = name
      @variables = []
      @functions = []
      super(access_token, base_url: base_url)

      if not lazy_init
        self.delayed_init()
      end
    end

    def delayed_init
      devinfo_response = @client.get("devices/#{@id}")
      #TODO: check for names which are present in both lists.
      # - is there protection against this?
      @info_fetched = true
      if devinfo_response.success?
        d = JSON.parse(devinfo_response.body)
        d['variables'].keys().each do |v|
          #puts "Defining var: #{v}"
          define_singleton_method v.to_sym do
            self.variable(v)
          end
        end
        d['functions'].each do |f|
          @functions << f
          define_singleton_method f.to_sym do |*args|
            self.function(f, *args)
          end
        end
      else
        raise ParticleCloud::Error.new("Error fetching device info: #{devinfo_response.body}")
      end
    end

    def info
      devr = @client.get("devices/#{@id}")
      if devr.success?
        info = JSON.parse(devr.body)
        return info
      end
    end

    def variable(varname)
      r = @client.get("devices/#{@id}/#{varname}")
      if r.success?
        return JSON.parse(r.body)['result']
      end
    end

    def function(func, *args)
      r = @client.post("devices/#{@id}/#{func}",
                       *args)
      if r.success?
        s = JSON.parse(r.body)
        return s["return_value"]
      end
    end
    
    # variables and functions called before initialization will trigger a call
    # to delayed_init(), populating methods, so they can be called.
    def method_missing(m, *args, &block)
      if not @info_fetched
        delayed_init()
      end
    end
  end

end
