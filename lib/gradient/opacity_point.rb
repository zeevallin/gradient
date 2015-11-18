module Gradient
  class OpacityPoint
    attr_reader :opacity, :location
    def initialize(location, opacity)
      @location, @opacity = location, opacity
    end
  end
end