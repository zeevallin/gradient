module Gradient
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

    def parse(buffer)
    end

  end
end
