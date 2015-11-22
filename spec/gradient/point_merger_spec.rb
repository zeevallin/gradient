RSpec.describe Gradient::PointMerger do

  describe "#initialize" do
    it "assigns and sorts the points" do
      left_black = Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0))
      right_white = Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255))

      left_transparent = Gradient::OpacityPoint.new(0, 0.0)
      right_opaque = Gradient::OpacityPoint.new(1, 1.0)

      merger = Gradient::PointMerger.new([right_white, left_black], [right_opaque, left_transparent])

      expect(merger.color_points[0]).to eq left_black
      expect(merger.color_points[1]).to eq right_white
      expect(merger.opacity_points[0]).to eq left_transparent
      expect(merger.opacity_points[1]).to eq right_opaque
    end
  end

  describe "#call" do
    it "returns a colored opaque point based on the color points surrounding it" do
      left_black = Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0))
      right_white = Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255))

      left_opaque = Gradient::OpacityPoint.new(0, 1)
      middle_transparent = Gradient::OpacityPoint.new(0.5, 0)
      right_opaque = Gradient::OpacityPoint.new(1, 1)

      points = Gradient::PointMerger.new(
        [right_white, left_black],
        [right_opaque, middle_transparent, left_opaque]
      ).call

      expect(points.length).to be 3

      points[0].tap do |p|
        expect(p.color).to eq left_black.color
        expect(p.opacity).to eq left_opaque.opacity
      end
      points[1].tap do |p|
        expect(p.color).to eq Color::RGB.new(127.5, 127.5, 127.5)
        expect(p.opacity).to eq middle_transparent.opacity
      end
      points[2].tap do |p|
        expect(p.color).to eq right_white.color
        expect(p.opacity).to eq right_opaque.opacity
      end
    end

    it "returns an opaqued color point based on the opaque points surrounding it" do
      left_opaque = Gradient::OpacityPoint.new(0, 0)
      right_opaque = Gradient::OpacityPoint.new(1, 1)

      left_black = Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0))
      middle_grey = Gradient::ColorPoint.new(0.5, Color::RGB.new(127.5, 127.5, 127.5))
      right_white = Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255))

      points = Gradient::PointMerger.new(
        [right_white, middle_grey, left_black],
        [right_opaque, left_opaque]
      ).call

      expect(points.length).to be 3

      points[0].tap do |p|
        expect(p.color).to eq left_black.color
        expect(p.opacity).to eq left_opaque.opacity
      end
      points[1].tap do |p|
        expect(p.color).to eq middle_grey.color
        expect(p.opacity).to eq 0.5
      end
      points[2].tap do |p|
        expect(p.color).to eq right_white.color
        expect(p.opacity).to eq right_opaque.opacity
      end
    end

    it "reconciles two identical opacity points" do
      white = Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255))
      black = Gradient::ColorPoint.new(1, Color::RGB.new(0, 0, 0))
      color_points = [white, black]

      opacity_points = [
        Gradient::OpacityPoint.new(0, 0),
        Gradient::OpacityPoint.new(0, 0),
        Gradient::OpacityPoint.new(1, 1),
      ]

      points = Gradient::PointMerger.new(color_points, opacity_points).call
      expect(points.first.color).to eq white.color
      expect(points.first.opacity).to eq 0
      expect(points.last.color).to eq black.color
      expect(points.last.opacity).to eq 1
    end

    it "reconciles there only being one opacity point" do
      white = Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255))
      black = Gradient::ColorPoint.new(1, Color::RGB.new(0, 0, 0))
      color_points = [white, black]

      opacity_points = [
        Gradient::OpacityPoint.new(1, 1),
      ]

      points = Gradient::PointMerger.new(color_points, opacity_points).call
      expect(points.first.color).to eq white.color
      expect(points.first.opacity).to eq 1
      expect(points.last.color).to eq black.color
      expect(points.last.opacity).to eq 1
    end

    it "reconciles there only being one color point" do
      white = Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255))

      opacity_points = [
        Gradient::OpacityPoint.new(0, 0),
        Gradient::OpacityPoint.new(1, 1),
      ]

      points = Gradient::PointMerger.new([white], opacity_points).call
      expect(points.first.color).to eq white.color
      expect(points.first.opacity).to eq 0
      expect(points.last.color).to eq white.color
      expect(points.last.opacity).to eq 1
    end

    it "reconciles when there are no opacity points" do
      white = Gradient::ColorPoint.new(0, Color::RGB.new(255, 255, 255))
      black = Gradient::ColorPoint.new(1, Color::RGB.new(0, 0, 0))
      color_points = [white, black]

      points = Gradient::PointMerger.new(color_points, []).call
      expect(points.size).to eq 2
      expect(points.first.color).to eq white.color
      expect(points.first.opacity).to eq 1
      expect(points.last.color).to eq black.color
      expect(points.last.opacity).to eq 1
    end

    it "reconciles when there are no color points" do
      opacity_points = [
        Gradient::OpacityPoint.new(0, 0),
        Gradient::OpacityPoint.new(1, 1),
      ]

      points = Gradient::PointMerger.new([], opacity_points).call
      expect(points.size).to eq 2
      expect(points.first.color).to eq Color::RGB.new(255, 255, 255)
      expect(points.first.opacity).to eq 0
      expect(points.last.color).to eq Color::RGB.new(255, 255, 255)
      expect(points.last.opacity).to eq 1
    end
  end

end