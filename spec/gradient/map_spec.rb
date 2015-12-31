RSpec.describe Gradient::Map do

  let(:left_blue) { Gradient::Point.new(0, Color::RGB.new(0, 0, 255), 1) }
  let(:middle_green) { Gradient::Point.new(0.5, Color::RGB.new(0, 255, 0), 0.5) }
  let(:right_red) { Gradient::Point.new(1, Color::RGB.new(255, 0, 0), 1) }

  subject(:map) { Gradient::Map.new(middle_green, left_blue, right_red) }

  describe ".initialize" do

    it "sorts the points" do
      expect(map.points[0]).to eq left_blue
      expect(map.points[1]).to eq middle_green
      expect(map.points[2]).to eq right_red
    end

    it "stores the point locations" do
      expect(map.locations).to eq [0, 0.5, 1]
    end

  end

  describe '#range' do

    it 'returns a Range' do
      expect(map.range).to be_a Range
    end

    it 'reports the correct range' do
      expect(map.range).to eq (0.0..1.0)
    end
  end

  describe '#interpolate' do

    context 'outside the range' do

      let(:interpolated) { map.interpolate(2.6) }

      it 'should be nil' do
        expect(interpolated).to be_nil
      end
    end

    context 'at a mid-segment location' do

      let(:interpolated) { map.interpolate(0.25) }

      it 'should be a Gradient::Point' do
        expect(interpolated).to be_a Gradient::Point
      end

      describe 'the color' do

        let(:color) { interpolated.color }

        it 'should be the mean of the proximal colors' do
          expect(color.hex).to eq '008080'
        end
      end

      describe 'the opacity' do

        let(:opacity) { interpolated.opacity }

        it 'should be the mean of the proximal opacities' do
          expect(opacity).to eql 0.75
        end
      end
    end

    context 'at a point location' do

      let(:interpolated) { map.interpolate(0.5) }

      it 'should be a Gradient::Point' do
        expect(interpolated).to be_a Gradient::Point
      end

      describe 'the color' do

        let(:color) { interpolated.color }

        it 'should be the point color' do
          expect(color.hex).to eq '00ff00'
        end
      end

      describe 'the opacity' do

        let(:opacity) { interpolated.opacity }

        it 'should be the point opacity' do
          expect(opacity).to eq 0.5
        end
      end
    end

    context 'at the initial location' do

      let(:interpolated) { map.interpolate(0.0) }

      it 'should be a Gradient::Point' do
        expect(interpolated).to be_a Gradient::Point
      end

      describe 'the color' do

        let(:color) { interpolated.color }

        it 'should be the point color' do
          expect(color.hex).to eq '0000ff'
        end
      end

      describe 'the opacity' do

        let(:opacity) { interpolated.opacity }

        it 'should be the point opacity' do
          expect(opacity).to eq 1.0
        end
      end
    end

    context 'at the final location' do

      let(:interpolated) { map.interpolate(1.0) }

      it 'should be a Gradient::Point' do
        expect(interpolated).to be_a Gradient::Point
      end

      describe 'the color' do

        let(:color) { interpolated.color }

        it 'should be the point color' do
          expect(color.hex).to eq 'ff0000'
        end
      end

      describe 'the opacity' do

        let(:opacity) { interpolated.opacity }

        it 'should be the point opacity' do
          expect(opacity).to eq 1.0
        end
      end
    end

  end

  describe ".deserialize" do
    it "returns a point with the right attributes" do
      deserialized_map = described_class.deserialize([
        [0, "rgb", [0, 0, 255], 1],
        [0.5, "rgb", [0, 255, 0], 1],
        [1, "rgb", [255, 0, 0], 1]
      ])
      expect(deserialized_map.points[0].opacity).to eq 1
      expect(deserialized_map.points[0].location).to eq 0
      expect(deserialized_map.points[1].opacity).to eq 1
      expect(deserialized_map.points[1].location).to eq 0.5
      expect(deserialized_map.points[2].opacity).to eq 1
      expect(deserialized_map.points[2].location).to eq 1
    end
  end

  describe "#serialize" do
    it "returns an array with the points as nested hashes" do
      expect(map.serialize).to eq([
        [0, "rgb", [0, 0, 255], 1],
        [0.5, "rgb", [0, 255, 0], 0.5],
        [1, "rgb", [255, 0, 0], 1]
      ])
    end
  end

  describe "#as_json" do
    it "returns an array with the points as nested hashes" do
      expect(map.as_json({})).to eq([
        [0, "rgb", [0, 0, 255], 1],
        [0.5, "rgb", [0, 255, 0], 0.5],
        [1, "rgb", [255, 0, 0], 1]
      ])
    end
  end

end
