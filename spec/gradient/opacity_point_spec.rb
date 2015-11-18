RSpec.describe Gradient::OpacityPoint do

  describe "#initialize" do
    it "assigns color and location" do
      opaque = 1
      location = 0.5
      point = described_class.new(location, opaque)
      expect(point.opacity).to eq opaque
      expect(point.location).to eq location
    end
  end

end