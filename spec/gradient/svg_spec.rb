RSpec.describe Gradient::SVG do

  shared_examples_for 'a hash of Gradient::Map' do |expect|

    let(:map_hash) { described_class.parse(fixture_buffer(fixture)) }

    it 'should be a Hash' do
      expect(map_hash).to be_a Hash
    end

    it 'should have the correct keys' do
      expect(map_hash.keys).to match_array(expect.keys)
    end

    expect.keys.each do |key|

      describe "the map with key '#{key}'" do

        let(:map) { map_hash[key] }

        it 'should be a Gradient::Map' do
          expect(map).to be_a Gradient::Map
        end

        it "should have #{expect[key]} valid Gradinet::Points" do
          expect(map.points.count).to eq expect[key]
          map.points.each do |point|
            expect(point).to be_a Gradient::Point
            expect(point.location).to be_a Float
            expect(point.color).to be_a Color::RGB
            expect(point.opacity).to be_a Float
            expect(point.opacity).to be_between(0, 1).inclusive
          end
          expect(map.points.map(&:location))
            .to be_monotonically_increasing
        end
      end
    end
  end

  describe '.parse' do

    # this a simple single gradient svg, no surprises

    context 'subtle.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'subtle' => 11 ) do
        let(:fixture) { 'subtle.svg' }
      end
    end

    # this a single gradient with various sorts of valid stop-color
    # values, exercises the parsing of colors

    context 'hard-colors.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'hard-colors' => 5 ) do
        let(:fixture) { 'hard-colors.svg' }
      end
    end

    # this valid svg file has no gradients in it

    context 'no-gradient.svg' do
      it_should_behave_like('a hash of Gradient::Map', {}) do
        let(:fixture) { 'no-gradient.svg' }
      end
    end

    # this specifies color and opacity via a css-style attribute
    # using named colors; also, does not specify the svg namespace

    context 'lemon-lime.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'Lemon-Lime' => 5) do
        let(:fixture) { 'lemon-lime.svg' }
      end
    end

    # contains multiple gradients, css-style with hex colors, and
    # several gradients which are links (which do not have any stops
    # of their own, so should be ignored)

    context 'punasia.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'linearGradient281' => 2, 
                            'linearGradient333' => 2, 
                            'linearGradient336' => 2, 
                            'linearGradient356' => 2, 
                            'linearGradient393' => 2) do
        let(:fixture) { 'punasia.svg' }
      end
    end
  end
end
