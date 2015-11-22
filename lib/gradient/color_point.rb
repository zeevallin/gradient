module Gradient
  class ColorPoint
    attr_reader :color, :location
    def initialize(location, color)
      @color, @location = color, location
    end
    def <=>(other)
      self.location <=> other.location
    end
  end
end