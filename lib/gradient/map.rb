module Gradient
  class Map
    attr_reader :points
    def initialize(*points)
      @points = Array(points).sort { |a, b| a.location <=> b.location }
    end
  end
end