module Gradient
  class Map

    attr_reader :color_points, :opacity_points, :points

    def initialize(color_points=[], opacity_points=[])
      color_points << Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255)) if color_points.empty?
      opacity_points << Gradient::OpacityPoint.new(0, 1) if opacity_points.empty?
      @color_points = sort_points(Array(color_points))
      @opacity_points = sort_points(Array(opacity_points))
      @all_points = sort_points(@color_points + @opacity_points)
      @locations = @all_points.map { |point| point.location }.uniq
      @points ||= expand_points
    end

    def inspect
      "#<Gradient Map #{points.map(&:inspect).join(" ")}>"
    end

    def to_css(**args)
      @css_printer ||= Gradient::CSSPrinter.new(self)
      @css_printer.css(**args)
    end

    private def expand_points
      new_points = @locations.map do |location|
        selected_points = @all_points.select { |point| point.location == location }
        colored_points, opacity_points = selected_points.group_by(&:class).values_at(ColorPoint, OpacityPoint)
        if colored_points && opacity_points
          Gradient::Point.new(location, colored_points.first.color, opacity_points.first.opacity)
        elsif colored_points
          point = colored_points.first
          a, b = previous_and_next_in(@opacity_points, point)
          fraction = location_fraction(a, b, point)
          opacity = opacity_difference(fraction, a, b)
          Gradient::Point.new(location, point.color, opacity)
        elsif opacity_points
          point = opacity_points.first
          a, b = previous_and_next_in(@color_points, point)
          fraction = location_fraction(a, b, point)
          color = color_difference(fraction, a, b)
          Gradient::Point.new(location, color, point.opacity)
        end
      end
    end

    private def previous_and_next_in(bucket, point)
      groups = bucket.group_by { |p| point_group(p, point) }
      a = groups.fetch(:same) { groups.fetch(:less) { groups.fetch(:more) } }.max { |p| p.location }
      b = groups.fetch(:same) { groups.fetch(:more) { groups.fetch(:less) } }.min { |p| p.location }
      return a, b
    end

    private def point_group(a, b)
      if a.location < b.location
        :less
      elsif a.location > b.location
        :more
      else
        :same
      end
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