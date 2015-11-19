module Gradient
  class Point

    attr_reader :location, :color, :opacity

    def initialize(location, color, opacity)
      @location, @color, @opacity = location, color, opacity
    end

    def inspect
      "#<Point #{location * 100} ##{color.hex}#{"%02x" % (opacity * 255).round} >"
    end

  end
end