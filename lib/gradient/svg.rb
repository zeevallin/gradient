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
      (
        xml.xpath('//linearGradient') +
        xml.xpath('//xmlns:linearGradient', 'xmlns' => SVGNS)
      ).each do |linear_gradient|
        unless (id = linear_gradient['id']) then
          raise SVGError, 'linearGradient has no id'
        end
        unless (map = parse_linear_gradient(linear_gradient)).points.empty?
          @maps[id] = map
        end
      end
    end

    private def parse_linear_gradient(linear_gradient)
      map = Gradient::Map.new
      linear_gradient.children.each do |node|
        next unless node.name == 'stop'
        map.points << parse_stop(node)
      end
      map
    end

    private def parse_stop(stop)
      unless (offset = stop['offset']) then
        raise SVGError, 'stop has no offset'
      end
      location = parse_location(offset)
      if (style = stop['style']) then
        point_from_style(location, style)
      else
        point_from_stop(location, stop)
      end
    end

    private def point_from_style(location, style)
      stop = Hash[ style.split(/;/).map { |item| item.split(/:/) } ]
      point_from_stop(location, stop)
    end

    private def point_from_stop(location, stop)
      unless (stop_color = stop['stop-color']) then
        raise SVGError, 'stop has no stop-color'
      end
      color, opacity = parse_stop_color(stop_color)
      if (stop_opacity = stop['stop-opacity']) then
        opacity = parse_stop_opacity(stop_opacity)
      end
      Gradient::Point.new(location, color, opacity)
    end

    private def parse_location(offset)
      unless (location = offset.scanf('%f%%')).count == 1 then
        raise SVGError, "failed parse of offset #{offset}"
      end
      location.first / 100.0
    end

    private def parse_stop_color(stop_color)
      parts =
        if (r, g, b = stop_color.scanf('rgb(%d,%d,%d)')).count == 3 then
          [Color::RGB.new(r, g, b), 1.0]
        elsif (r, g, b, a = stop_color.scanf('rgba(%d,%d,%d,%f)')).count == 4 then
          [Color::RGB.new(r, g, b), a]
        elsif (color = Color::RGB.by_css(stop_color)) then
          [color, 1.0]
        end
      unless parts then
        raise SVGError, "failed parse of stop-color #{stop_color}"
      end
      parts
    end

    private def parse_stop_opacity(stop_opacity)
      stop_opacity.scanf('%f').first
    end
  end
end
