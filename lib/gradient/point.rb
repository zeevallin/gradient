module Gradient
  class Point
    attr_reader :color, :location
    def initialize(location, color)
      @color, @location = color, location
    end
  end
end