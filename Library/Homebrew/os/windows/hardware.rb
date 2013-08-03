module WindowsCPUs
  OPTIMIZATION_FLAGS = {}.freeze
  def optimization_flags; OPTIMIZATION_FLAGS; end

  def type
    @cpu_type ||= case wmic('Manufacturer')
      when /GenuineIntel/
        :intel
      else
        :dunno
      end
  end

  def family
    :dunno
  end
  alias_method :intel_family, :family

  def cores
    wmic('NumberOfLogicalProcessors').to_i
  end

  def bits
    is_64_bit? ? 64 : 32
  end

  def is_64_bit?
    return @is_64_bit if defined? @is_64_bit
    @is_64_bit = /64/ === wmic('AddressWidth')
  end

  private

  def wmic(property)
    `wmic cpu get #{property}`.split("\n")[2].strip
  end
end
