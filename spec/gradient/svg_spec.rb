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

      # this a simple single gradient svg, no surprise

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
              expect(locations)
                .to match_array [0, 6, 19, 25, 32, 42, 53, 65, 75, 87, 100]
            end
          end
        end
      end
    end

    context 'hard-colors.svg' do

      # this a single gradient with various sorts of valid stop-color
      # values, exercises the parsing of colours

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

  end
end
