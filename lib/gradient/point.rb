module Gradient
  class Point

    attr_reader :location, :color, :opacity

    def initialize(location, color, opacity)
      @location, @color, @opacity = location, color, opacity
    end

  end
end