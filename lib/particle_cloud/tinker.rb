# Tinker class, with better arg handling than default.
# Also demonstrates overriding functions defined by device.
class Tinker < ParticleCloud::Device

  STATES = [
    :LOW,
    :HIGH
  ]

  def digitalwrite(pin, state)
    unless STATES.include? state
      raise ArgumentError "Invalid state: #{state}"
    end
    function('digitalwrite', {params: "#{pin},#{state.to_s}"})
  end

  def digitalread(pin)
    return STATES[function('digitalread', {params: "#{pin}"})]
  end

  def analogread(pin)
    function('analogread', {params: pin})
  end

  def analogwrite(pin, value)
    function('analogwrite', {params: "#{pin},#{value}"})
    value
  end

end
