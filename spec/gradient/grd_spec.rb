RSpec.describe Gradient::GRD do

  def assert_maps(maps)
    expect(maps).to match a_hash_including("Kiwi")
    # TODO: Reconcile with python results by gradient in original Photoshop export
    # assert_color_point(maps["Kiwi"].color_points[0], 0.0, 60, 17, 3)
    assert_color_point(maps["Kiwi"].color_points[0], 0.0, 61, 17, 3)
    # TODO: Reconcile with python results by gradient in original Photoshop export
    # assert_color_point(maps["Kiwi"].color_points[1], 0.386, 41, 133, 12) FROM PYTHON RESULTS
    assert_color_point(maps["Kiwi"].color_points[1], 0.386, 41, 134, 13)
    # TODO: Reconcile with python results by gradient in original Photoshop export
    # assert_color_point(maps["Kiwi"].color_points[2], 0.84, 159, 202, 27) FROM PYTHON RESULTS
    assert_color_point(maps["Kiwi"].color_points[2], 0.84, 160, 203, 27)
    assert_color_point(maps["Kiwi"].color_points[3], 0.927, 243, 245, 110)
    assert_color_point(maps["Kiwi"].color_points[4], 1.0, 255, 255, 255)

    assert_opacity_point(maps["Kiwi"].opacity_points[0], 0, 1)
    assert_opacity_point(maps["Kiwi"].opacity_points[1], 1, 1)
  end

  def assert_color_point(point, location, red, green, blue)
    expect(point.location.round(3)).to eq location.round(3)
    expect(color_to_rgb(point.color)).to eq color_to_rgb(Color::RGB.new(red, green, blue))
  end

  def assert_opacity_point(point, location, opacity)
    expect(point.location.round(3)).to eq location.round(3)
    expect(point.opacity).to eq opacity
  end

  def color_to_rgb(color)
    [:red,:green, :blue].map{|c|color.send(c)}
  end

  describe ".parse" do

    it "returns a correct representation of the file string buffer" do
      buffer = File.open(Pathname(File.expand_path("../../fixtures/kiwi.grd", __FILE__)), "r").read
      assert_maps(described_class.parse(buffer))
    end

  end

  describe ".read" do

    it "it returns a correct representation of the kiwi.grd when passing a filename" do
      filename = Pathname(File.expand_path("../../fixtures/kiwi.grd", __FILE__))
      assert_maps(described_class.read(filename))
    end

    it "it returns a correct representation of the kiwi.grd when passing a File object" do
      filename = Pathname(File.expand_path("../../fixtures/kiwi.grd", __FILE__))
      file = File.open(filename, "r")
      assert_maps(described_class.read(file))
    end

    it "profile parsing nine.grd", profile: true, slow: true do
      require "ruby-prof"

      result = RubyProf.profile do |p|
        Signal.trap("INT") { break }
        filename = Pathname(File.expand_path("../../fixtures/nine.grd", __FILE__))
        described_class.read(filename)
      end

      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT)
    end

  end

end
