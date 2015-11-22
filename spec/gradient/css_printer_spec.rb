RSpec.describe Gradient::CSSPrinter do

  let(:map) {
    Gradient::Map.new(Gradient::PointMerger.new([
      Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0)),
      Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255)),
    ],[
      Gradient::OpacityPoint.new(0, 0),
      Gradient::OpacityPoint.new(0.5, 1),
      Gradient::OpacityPoint.new(1, 1)
    ]).call)
  }

  subject(:printer) { described_class.new(map) }

  describe "#rgba_values" do
    it "returns a valid" do
      expect(printer.rgba_values).to eq ["rgba(0,0,0,0.0) 0%", "rgba(128,128,128,1.0) 50%", "rgba(255,255,255,1.0) 100%"]
    end
  end

  describe "#css" do
    it "returns a valid css3 linear background gradient" do
      expect(printer.css).to eq "background:linear-gradient(to right, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%);"
    end
    it "returns a valid css3 radial background gradient" do
      expect(printer.css(type: :radial)).to eq "background:radial-gradient(rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%);"
    end
    it "returns a valid css3 linear border image gradient" do
      expect(printer.css(property: "border-image")).to eq "border-image:linear-gradient(to right, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%);"
    end
    it "returns a valid css3 angled linear border image gradient" do
      expect(printer.css(property: "border-image", angle: "60deg")).to eq "border-image:linear-gradient(60deg, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%);"
    end
  end

  describe "#linear" do
    it "returns a valid css3 linear gradient with default values" do
      expect(printer.linear).to eq "linear-gradient(to right, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 linear gradient with an angle" do
      expect(printer.linear(angle: "45deg")).to eq "linear-gradient(45deg, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 repeating linear gradient" do
      expect(printer.linear(repeating: true)).to eq "repeating-linear-gradient(to right, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 repeating linear gradient with vendor" do
      expect(printer.linear(repeating: true, vendor: :moz)).to eq "-moz-repeating-linear-gradient(to right, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 linear gradient with vendor and direction" do
      expect(printer.linear(vendor: :moz, direction: "left")).to eq "-moz-linear-gradient(left, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
  end

  describe "#radial" do
    it "returns a valid css3 linear gradient with default values" do
      expect(printer.radial).to eq "radial-gradient(rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 repeating radial gradient" do
      expect(printer.radial(repeating: true)).to eq "repeating-radial-gradient(rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 repeating radial gradient with vendor" do
      expect(printer.radial(repeating: true, vendor: :moz)).to eq "-moz-repeating-radial-gradient(rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
    it "returns a valid css3 radial gradient with vendor and shape" do
      expect(printer.radial(vendor: :moz, shape: "circle")).to eq "-moz-radial-gradient(circle, rgba(0,0,0,0.0) 0%, rgba(128,128,128,1.0) 50%, rgba(255,255,255,1.0) 100%)"
    end
  end

end