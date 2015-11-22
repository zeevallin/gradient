RSpec.describe Gradient::Map do

  describe "#initialize" do

    let(:left_blue) { Gradient::Point.new(0, Color::RGB.new(0, 0, 255), 1) }
    let(:middle_green) { Gradient::Point.new(0.5, Color::RGB.new(0, 255, 0), 1) }
    let(:right_red) { Gradient::Point.new(1, Color::RGB.new(255, 0, 0), 1) }

    let(:map) { Gradient::Map.new(middle_green, left_blue, right_red) }

    it "sorts the points" do
      expect(map.points[0]).to eq left_blue
      expect(map.points[1]).to eq middle_green
      expect(map.points[2]).to eq right_red
    end

    it "stores the point locations" do
      expect(map.locations).to eq [0, 0.5, 1]
    end

  end

end