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

    let(:maps) { described_class.parse(fixture_buffer('subtle')) }

    it 'should return a hash' do
      expect(maps).to be_a Hash
    end

    it 'should have the correct keys' do
      skip 'implementation'
      expect(maps.keys).to match_array ['subtle']
    end

    it "should have #{described_class} values" do
      maps.values.each do |map|
        expect(map).to be_a described_class
      end
    end
  end
end
