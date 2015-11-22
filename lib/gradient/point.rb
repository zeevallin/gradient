module Gradient
  class Point

    attr_reader :location, :color, :opacity

    class << self
      def deserialize(location, color_type, color_values, opacity)
        self.new(location, color_from(color_type, color_values), opacity)
      end

      private def color_from(color_type, color_values)
        case color_type
        when "rgb" then Color::RGB.new(*color_values)
        else
          raise NotImplementedError.new("#{string} is not a valid color type")
        end
      end
    end

    def initialize(location, color, opacity)
      @location, @color, @opacity = location, color, opacity
    end

    def inspect
      "#<Point #{location * 100} ##{color.hex}#{"%02x" % (opacity * 255).round}>"
    end

    def <=>(other)
      self.location <=> other.location
    end

    def serialize
      [location, "rgb", [color.red.round, color.green.round, color.blue.round], opacity]
    end

    def as_json(json={})
      serialize
    end

    def ==(other)
      unless other.kind_of?(Gradient::Point)
        raise ArgumentError.new("cannot compare Point with #{ other.class } using `=='")
      end
      location == other.location && color == other.color && opacity == other.opacity
    end

  end
end