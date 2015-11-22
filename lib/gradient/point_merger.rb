module Gradient
  class PointMerger

    attr_accessor :color_points, :opacity_points

    def initialize(color_points=[], opacity_points=[])
      color_points << Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255)) if color_points.empty?
      opacity_points << Gradient::OpacityPoint.new(0, 1) if opacity_points.empty?

      @color_points = sort_points(Array(color_points))
      @opacity_points = sort_points(Array(opacity_points))
      @all_points = sort_points(@color_points + @opacity_points)
      @locations = @all_points.map { |point| point.location }.uniq
    end

    def call
      @locations.map do |location|
        selected_points = @all_points.select { |point| point.location == location }
        colored, opaque = selected_points.group_by(&:class).values_at(ColorPoint, OpacityPoint)
        rgba = if colored && opaque
          [colored.first.color, opaque.first.opacity]
        elsif colored
          point = colored.first
          a, b = adjacent_points(@opacity_points, point)
          fraction = location_fraction(a, b, point)
          [point.color, opacity_difference(fraction, a, b)]
        elsif opaque
          point = opaque.first
          a, b = adjacent_points(@color_points, point)
          fraction = location_fraction(a, b, point)
          [color_difference(fraction, a, b), point.opacity]
        end

        Gradient::Point.new(location, *rgba)
      end
    end

    private def adjacent_points(bucket, point)
      groups = bucket.group_by { |p| triage_point(p, point) }
      a = groups.fetch(:same) { groups.fetch(:less) { groups.fetch(:more) } }.max { |p| p.location }
      b = groups.fetch(:same) { groups.fetch(:more) { groups.fetch(:less) } }.min { |p| p.location }
      return a, b
    end

    private def triage_point(a, b)
      a.location < b.location ? :less : (a.location > b.location ? :more : :same)
    end

    private def color_difference(fraction, a, b)
      red = a.color.red + fraction * (b.color.red - a.color.red)
      green = a.color.green + fraction * (b.color.green - a.color.green)
      blue = a.color.blue + fraction * (b.color.blue - a.color.blue)
      Color::RGB.new(red, green, blue)
    end

    private def opacity_difference(fraction, a, b)
      a.opacity + fraction * (b.opacity - a.opacity)
    end

    private def location_fraction(a, b, x)
      return 0 if a.location == b.location
      (x.location - a.location) / (b.location - a.location)
    end

    private def sort_points(points)
      points.sort { |a, b| a.location <=> b.location }
    end

  end
end