module Gradient
  class Map

    attr_reader :points, :locations

    def initialize(*points)
      @points = points.flatten.sort
      @locations = @points.map { |point| point.location }
    end

    def inspect
      "#<Gradient Map #{points.map(&:inspect).join(" ")}>"
    end

    def to_css(**args)
      @css_printer ||= Gradient::CSSPrinter.new(self)
      @css_printer.css(**args)
    end

  end
end