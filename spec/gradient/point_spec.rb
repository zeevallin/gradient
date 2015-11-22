RSpec.describe Gradient::Point do

  describe ".deserialize" do
    it "returns a point based on the provided array of values" do
      point = Gradient::Point.deserialize(0.5, "rgb", [0, 255, 0], 1)
      expect(point).to eq Gradient::Point.new(0.5, Color::RGB.new(0, 255, 0), 1)
    end
  end

  describe "#serialize" do
    it "returns an array with the color values" do
      point = Gradient::Point.new(0.5, Color::RGB.new(0, 255, 0), 1)
      expect(point.serialize).to eq([0.5, "rgb", [0, 255, 0], 1])
    end
  end

  describe "#as_json" do
    it "returns an array with the color values" do
      point = Gradient::Point.new(0.5, Color::RGB.new(0, 255, 0), 1)
      expect(point.as_json({})).to eq([0.5, "rgb", [0, 255, 0], 1])
    end
  end

end