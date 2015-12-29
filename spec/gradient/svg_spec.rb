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

  shared_examples_for 'a hash of Gradient::Map' do |expect|

    let(:map_hash) { described_class.parse(fixture_buffer(fixture_name)) }

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

        it "should have #{expect[key]} points" do
          expect(map.points.count).to eq expect[key]
          map.points.each do |point|
            expect(point).to be_a Gradient::Point
          end
        end
      end
    end
  end

  describe '.parse' do

    # this a simple single gradient svg, no surprises

    context 'subtle.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'subtle' => 11 ) do
        let(:fixture_name) { 'subtle' }
      end
    end

    # this a single gradient with various sorts of valid stop-color
    # values, exercises the parsing of colors

    context 'hard-colors.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'hard-colors' => 5 ) do
        let(:fixture_name) { 'hard-colors' }
      end
    end

    # this valid svg file has no gradients in it

    context 'no-gradient.svg' do
      it_should_behave_like('a hash of Gradient::Map', {}) do
        let(:fixture_name) { 'no-gradient' }
      end
    end

    # this specifies color and opacity via a css-style attribute
    # using named colors; also, does not specify the svg namespace

    context 'lemon-lime.svg' do
      it_should_behave_like('a hash of Gradient::Map', 
                            'Lemon-Lime' => 5) do
        let(:fixture_name) { 'lemon-lime' }
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
        let(:fixture_name) { 'punasia' }
      end
    end
  end
end
