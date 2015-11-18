RSpec.describe Gradient::Point do

  describe "#initialize" do
    it "assigns color and location" do
      white = Color::RGB.new(255, 255, 255)
      location = 0.5
      point = Gradient::Point.new(location, white)
      expect(point.color).to eq white
      expect(point.location).to eq location
    end
  end

end