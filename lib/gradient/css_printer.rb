module Gradient
  class CSSPrinter

    ORIENTATIONS = %i(horizontal vertical diagonal_top diagonal_bottom radial)

    def initialize(map)
      @map = map
    end

    def css(type: :linear, property: "background", **args)
      "#{property}:#{send(type,**args)};"
    end

    def linear(vendor: nil, direction: "to right", angle: nil, repeating: false)
      angle_or_direction = [angle || direction]
      arguments = (angle_or_direction + rgba_values)
      format_css_function(vendor, repeating, "linear-gradient") + "(#{arguments.join(", ")})"
    end

    def radial(vendor: nil, shape: nil, size: nil, position: nil, repeating: false)
      shape_and_size_at_position = []
      shape_and_size_at_position << shape if shape
      shape_and_size_at_position << size if size
      shape_and_size_at_position << position if position
      arguments = rgba_values
      arguments.unshift(shape_and_size_at_position.join(" ")) if shape_and_size_at_position.any?
      format_css_function(vendor, repeating, "radial-gradient") + "(#{arguments.join(", ")})"
    end

    def rgba_values
      @map.points.map { |point| point_to_rgba(point) }
    end

    private def point_to_rgba(point)
      red, green, blue = [:red,:green, :blue].map{|c|point.color.send(c).round}
      opacity = point.opacity.round(2)
      location = (point.location * 100).round
      "rgba(#{red},#{green},#{blue},#{opacity}) #{location}%"
    end

    private def format_css_function(vendor, repeating, type)
      css_function = []
      css_function << "-#{vendor}" if !!vendor
      css_function << "repeating" if !!repeating
      css_function << type
      css_function.join("-")
    end

  end
end