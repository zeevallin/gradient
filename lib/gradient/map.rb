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

  end
end
