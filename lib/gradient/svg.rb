require 'scanf'
require 'nokogiri'

module Gradient

  class SVGError < StandardError ; end

  class SVG

    attr_reader :maps

    class << self

      def parse(string_buffer)
        new.tap do |parser|
          parser.parse(string_buffer)
        end.maps
      end

      def read(file)
        new.tap do |parser|
          File.open(file, 'r') do |file|
            parser.parse(file.read)
          end
        end.maps
      end

      def open(file)
        read(file)
      end

    end

    def initialize
      @maps = {}
    end

    SVGNS = 'http://www.w3.org/2000/svg'

    def parse(buffer)
      xml = Nokogiri::XML(buffer)
      xml.xpath('//xmlns:linearGradient', 'xmlns' => SVGNS).each do |linear_gradient|
        unless (id = linear_gradient['id']) then
          raise SVGError, 'linearGradient has no id'
        end
        @maps[id] = parse_linear_gradient(linear_gradient)
      end
    end

    private def parse_linear_gradient(linear_gradient)
      map = Gradient::Map.new
      linear_gradient.children.each do |stop|
        next unless stop.name == 'stop'
        map.points << parse_stop(stop)
      end
      map
    end

    private def parse_stop(stop)
      unless (offset = stop['offset']) then
        raise SVGError, 'stop has no offset'
      end
      location = parse_location(offset)
      unless (stop_color = stop['stop-color']) then
        raise SVGError, 'stop has no stop-color'
      end
      red, green, blue, opacity = parse_stop_color(stop_color)
      if (stop_opacity = stop['stop-opacity']) then
        opacity = parse_stop_opacity(stop_opacity)
      end
      color = Color::RGB.new(red, green, blue)
      Gradient::Point.new(location, color, opacity)
    end

    private def parse_location(offset)
      unless (location = offset.scanf('%f%%')).count == 1 then
        raise SVGError, "failed parse of offset #{offset}"
      end
      location.first
    end

    private def parse_stop_color(stop_color)
      parts =
        if (rgb = stop_color.scanf('rgb(%d,%d,%d)')).count == 3 then
          [*rgb, 1.0]
        elsif (rgba = stop_color.scanf('rgba(%d,%d,%d,%f)')).count == 4 then
          rgba
        elsif (c = Color::RGB.from_html(stop_color)) then
          [c.red.to_i, c.green.to_i, c.blue.to_i, 1.0]
        end
      unless parts then
        raise SVGError, "failed parse of stop-color #{stop_color}"
      end
      parts
    end

    private def parse_stop_opacity(stop_opacity)
      stop_opacity.scanf('%f')
    end
  end
end
