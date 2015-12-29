RSpec.describe Gradient::SVG do

  def fixture_dir
    '../fixtures'
  end

  def fixture_path(base)
    Pathname(File.expand_path("../#{fixture_dir}/#{base}.svg", __FILE__))
  end

  def fixture_buffer(base)
    File.open(fixture_path(base), 'r').read
  end

  describe '.parse' do

    context 'subtle.svg' do

      # this a simple single gradient svg, no surprises

      let(:maps) { described_class.parse(fixture_buffer('subtle')) }

      it 'should return a hash' do
        expect(maps).to be_a Hash
      end

      it 'should have the correct keys' do
        expect(maps.keys).to match_array ['subtle']
      end

      describe 'the hash value' do

        let(:map) { maps['subtle'] }

        it 'should be a Gradient::Map' do
          expect(map).to be_a Gradient::Map
        end

        describe 'the points' do

          let(:points) { map.points }

          it 'should be an array' do
            expect(points).to be_an Array
          end

          it 'should have 11 elements' do
            expect(points.count).to eq 11
          end

          it 'should consist of Gradient::Point objects' do
            points.each do |point|
              expect(point).to be_a Gradient::Point
            end
          end

          describe 'the locations' do

            let(:locations) { points.map(&:location) }

            it 'should have the expected values' do
              expected =
                [0.00, 0.06, 0.19, 0.25,
                 0.32, 0.42, 0.53, 0.65,
                 0.75, 0.87, 1.0]
              expect(locations).to match_array expected
            end
          end
        end
      end
    end

    context 'hard-colors.svg' do

      # this a single gradient with various sorts of valid stop-color
      # values, exercises the parsing of colors

      let(:maps) { described_class.parse(fixture_buffer('hard-colors')) }

      it 'should return a hash' do
        expect(maps).to be_a Hash
      end

      it 'should have the correct keys' do
        expect(maps.keys).to match_array ['hard-colors']
      end

    end

    context 'no-gradient.svg' do

      # this valid svg file has no gradients in it

      let(:maps) { described_class.parse(fixture_buffer('no-gradient')) }

      it 'should return a hash' do
        expect(maps).to be_a Hash
      end

      it 'should have the correct keys' do
        expect(maps.keys).to match_array []
      end

    end

    context 'lemon-lime.svg' do

      # this specifies color and opacity via a css-style attribute
      # using named colors; also, does not specify the svg namespace

      let(:maps) { described_class.parse(fixture_buffer('lemon-lime')) }

      it 'should return a hash' do
        expect(maps).to be_a Hash
      end


      it 'should have the correct keys' do
        expect(maps.keys).to match_array ['Lemon-Lime']
      end

    end

    context 'punasia.svg' do

      # contains multiple gradients, css-style with hex colors, and
      # several gradients which are links (which do not have any stops
      # of their own, so should be ignored)

      let(:maps) { described_class.parse(fixture_buffer('punasia')) }

      it 'should return a hash' do
        expect(maps).to be_a Hash
      end

      it 'should have the correct keys' do
        ids = [281, 333, 336, 356, 393].map { |id| "linearGradient#{id}" }
        expect(maps.keys).to match_array ids
      end
    end
  end
end
