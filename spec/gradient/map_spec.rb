RSpec.describe Gradient::Map do

  describe "#initialize" do
    it "assigns and sorts the points" do
      right_white = Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255))
      left_black = Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0))

      right_opaque = Gradient::OpacityPoint.new(1, 1.0)
      left_transparent = Gradient::OpacityPoint.new(0, 0.0)

      map = Gradient::Map.new([right_white, left_black], [right_opaque, left_transparent])

      expect(map.color_points[0]).to eq left_black
      expect(map.color_points[1]).to eq right_white
      expect(map.opacity_points[0]).to eq left_transparent
      expect(map.opacity_points[1]).to eq right_opaque
    end

    it "returns a colored opaque point based on the color points surrounding it" do
      left_black = Gradient::ColorPoint.new(0, Color::RGB.new(0, 0, 0))
      right_white = Gradient::ColorPoint.new(1, Color::RGB.new(255, 255, 255))

      left_opaque = Gradient::OpacityPoint.new(0, 1)
      middle_transparent = Gradient::OpacityPoint.new(0.5, 0)
      right_opaque = Gradient::OpacityPoint.new(1, 1)

      map = Gradient::Map.new(
        [right_white, left_black],
        [right_opaque, middle_transparent, left_opaque]
      )

      expect(map.points.length).to be 3

      map.points[0].tap do |p|
        expect(p.color).to eq left_black.color
        expect(p.opacity).to eq left_opaque.opacity
      end
      map.points[1].tap do |p|
        expect(p.color).to eq Color::RGB.new(127.5, 127.5, 127.5)
        expect(p.opacity).to eq middle_transparent.opacity
      end
      map.points[2].tap do |p|
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

      map = Gradient::Map.new(
        [right_white, middle_grey, left_black],
        [right_opaque, left_opaque]
      )

      expect(map.points.length).to be 3

      map.points[0].tap do |p|
        expect(p.color).to eq left_black.color
        expect(p.opacity).to eq left_opaque.opacity
      end
      map.points[1].tap do |p|
        expect(p.color).to eq middle_grey.color
        expect(p.opacity).to eq 0.5
      end
      map.points[2].tap do |p|
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

      gradient = Gradient::Map.new(color_points, opacity_points)
      expect(gradient.points.first.color).to eq white.color
      expect(gradient.points.first.opacity).to eq 0
      expect(gradient.points.last.color).to eq black.color
      expect(gradient.points.last.opacity).to eq 1
    end
  end

end