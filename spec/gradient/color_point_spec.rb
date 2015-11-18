RSpec.describe Gradient::ColorPoint do

  describe "#initialize" do
    it "assigns color and location" do
      white = Color::RGB.new(255, 255, 255)
      location = 0.5
      point = described_class.new(location, white)
      expect(point.color).to eq white
      expect(point.location).to eq location
    end
  end

end