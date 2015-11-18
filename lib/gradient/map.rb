module Gradient
  class Map
    attr_reader :color_points, :opacity_points
    def initialize(color_points=[], opacity_points=[])
      @color_points = Array(color_points).sort { |a, b| a.location <=> b.location }
      @opacity_points = Array(opacity_points).sort { |a, b| a.location <=> b.location }
    end
  end
end