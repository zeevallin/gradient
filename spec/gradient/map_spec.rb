RSpec.describe Gradient::Map do

  describe "#initialize" do
    it "assigns and sorts the points" do
      right_white = Gradient::Point.new(1, Color::RGB.new(255, 255, 255))
      left_black = Gradient::Point.new(0, Color::RGB.new(0, 0, 0))
      map = Gradient::Map.new(right_white, left_black)
      expect(map.points[0]).to eq left_black
      expect(map.points[1]).to eq right_white
    end
  end

end