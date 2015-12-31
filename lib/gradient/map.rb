module Gradient
  class Map

    attr_reader :points, :locations

    class << self
      def deserialize(points=[])
        new(points.map { |point| Gradient::Point.deserialize(*point) })
      end
    end

    def initialize(*points)
      @points = points.flatten.sort
      @locations = @points.map { |point| point.location }
    end

    def inspect
      "#<Gradient Map #{points.map(&:inspect).join(" ")}>"
    end

    def range
      @range ||= 
        begin
          ends = [:first, :last]
            .map { |method| points.send(method) }
            .map(&:location)
          Range.new(*ends)
        end
    end

    def interpolate(location, opts = {})
      if range.include? location then
        i = points.find_index { |p| p.location >= location } 
        if i == 0 then
          points[0].dup
        else
          interpolate_points(points[i-1], points[i], location)
        end
      end
    end

    def to_css(**args)
      @css_printer ||= Gradient::CSSPrinter.new(self)
      @css_printer.css(**args)
    end

    def serialize
      @points.map(&:serialize)
    end

    def as_json(json={})
      serialize
    end

    private 

    def interpolate_points(point_left, point_right, location)
      color_left, color_right = [point_left, point_right].map(&:color)
      location_left, location_right = [point_left, point_right].map(&:location)
      separation = location_right - location_left
      if separation == 0.0 then
        point_right.dup
      else
        weight = (location - location_left)/separation
        r, g, b = [:r, :g, :b].map do |channel|
          interpolate_floats(color_left.send(channel),
                             color_right.send(channel),
                             weight)
        end
        color = Color::RGB.from_fraction(r, g, b)
        opacity = interpolate_floats(point_left.opacity, 
                                     point_right.opacity,
                                     weight)
        Point.new(location, color, opacity)
      end
    end

    def interpolate_floats(x0, x1, weight)
      x0 * (1.0 - weight) + x1 * weight
    end
  end
end
