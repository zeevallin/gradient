# Gradient
[![Gem Version](https://badge.fury.io/rb/gradient.svg)](https://badge.fury.io/rb/gradient)
[![Build Status](https://travis-ci.org/zeeraw/gradient.svg?branch=master)](https://travis-ci.org/zeeraw/gradient)

Library for dealing with color gradients in ruby

## Usage
Gradient works by placing point vectors along a one dimensional plane.
Start by creating a few points and pass them to a gradient map.

```ruby
gradient = Gradient::Map.new(
  Gradient::Point.new(0, Color::RGB.new(32, 36, 196), 1.0),
  Gradient::Point.new(0.49, Color::RGB.new(14, 250, 211), 0.1),
  Gradient::Point.new(0.50, Color::RGB.new(171, 25, 12), 0.7),
  Gradient::Point.new(1, Color::RGB.new(15, 212, 162), 0.3)
)
# => #<Gradient Map #<Point 0 #2024c4ff> #<Point 49.0 #0efad31a> #<Point 50.0 #ab190cb3> #<Point 100 #0fd4a24d>>
```

### Convert to CSS
If you use ruby to serve web content you can use Gradient to convert gradient maps in to [CSS3 Gradients](http://www.w3schools.com/css/css3_gradients.asp)

```ruby
gradient.to_css
# => "background:linear-gradient(to right, rgba(30,87,153,1.0) 0%, rgba(41,137,216,0.02) 49%, rgba(37,131,209,0.0) 50%, rgba(32,124,202,0.02) 51%, rgba(125,185,232,1.0) 100%);"

gradient.to_css(property: "border-image")
# => "border-image:linear-gradient(to right, rgba(30,87,153,1.0) 0%, rgba(41,137,216,0.02) 49%, rgba(37,131,209,0.0) 50%, rgba(32,124,202,0.02) 51%, rgba(125,185,232,1.0) 100%);"
```

If you want some more control of the css generation you can invoke the CSS Printer manually.

```ruby
printer = Gradient::CSSPrinter.new(gradient)
printer.linear
# => "linear-gradient(to right, rgba(30,87,153,1.0) 0%, rgba(41,137,216,0.02) 49%, rgba(37,131,209,0.0) 50%, rgba(32,124,202,0.02) 51%, rgba(125,185,232,1.0) 100%)"

printer.linear(direction: "to bottom")
# => "linear-gradient(to bottom, rgba(30,87,153,1.0) 0%, rgba(41,137,216,0.02) 49%, rgba(37,131,209,0.0) 50%, rgba(32,124,202,0.02) 51%, rgba(125,185,232,1.0) 100%)"

printer.radial(shape: :circle)
# => "radial-gradient(circle, rgba(30,87,153,1.0) 0%, rgba(41,137,216,0.02) 49%, rgba(37,131,209,0.0) 50%, rgba(32,124,202,0.02) 51%, rgba(125,185,232,1.0) 100%)"
```

### Serialize & deserialize gradients
To store your gradients in something like a document database,
you're able to convert a gradient to primitives using `Gradient::Map#serialize`.

```ruby
Gradient::Map.new(
  Gradient::Point.new(0, Color::RGB.new(221, 189, 82), 1.0),
  Gradient::Point.new(1, Color::RGB.new(89, 12, 72), 0.3)
).serialize
# => [[0, "rgb", [221, 189, 82], 1.0], [1, "rgb", [89, 12, 72], 0.3]]

```

You can easily turn them back in to ruby objects by using `Gradient::Map.deserialize`.

```ruby
Gradient::Map.deserialize([[0, "rgb", [221, 189, 82], 1.0], [1, "rgb", [89, 12, 72], 0.3]])
# => #<Gradient Map #<Point 0 #ddbd52ff> #<Point 100 #590c484d>>
```

### Import Adobe Photoshop gradient (`.grd`) files
For many artists a preferred way of creating gradients is through Photoshop.
You are able to parse `.grd` files and turn them in to a hash of `Gradient::Map` objects.

```ruby
Gradient::GRD.read("./kiwi.grd")
# => {
#   "Kiwi"=> #<Gradient Map #<Point 0.0 #3d1103ff> #<Point 38.6 #29860dff> #<Point 84.0 #a0cb1bff> #<Point 92.7 #f3f56eff> #<Point 100.0 #ffffffff>>
# }
```

### Import SVG gradients
SVG images can contain multiple gradients, and these can be extracted in the same
way as for `.grd` files.
```ruby
Gradient::SVG.read("./lemon-lime.svg")
# => {
#   "Lemon-Lime"=> #<Gradient Map #<Point 0.0 #ffff00ff> #<Point 20.0 #ffff00ff> #<Point 50.0 #00ff00ff> #<Point 80.0 #ffff00ff> #<Point 100.0 #ffff00ff>>}"
# }
```

### Separate point vectors for opacity and color
You're able to control the point vectors for color and opacity separately by using a point merger.

```ruby
color_points = [
  Gradient::ColorPoint.new(0, Color::RGB.new(30, 87, 153)),
  Gradient::ColorPoint.new(0.49, Color::RGB.new(41, 137, 216)),
  Gradient::ColorPoint.new(0.51, Color::RGB.new(32, 124, 202)),
  Gradient::ColorPoint.new(1, Color::RGB.new(125, 185, 232)),
]

opacity_points = [
  Gradient::OpacityPoint.new(0, 1),
  Gradient::OpacityPoint.new(0.5, 0),
  Gradient::OpacityPoint.new(1, 1)
]

points = Gradient::PointMerger.new(color_points, opacity_points).call

gradient = Gradient::Map.new(points)
# => #<Gradient Map #<Point 0 #1e5799ff> #<Point 49.0 #2989d805> #<Point 50.0 #2583d100> #<Point 51.0 #207cca05> #<Point 100 #7db9e8ff>>
```

### Interpolation
One can find the color and opacity at an arbitrary location using the `interpolate` method, which returns a new `Gradient::Point`.

```ruby
map = Gradient::Map.new(
        Gradient::Point.new(0, Color::RGB.new(0, 128, 255), 1.0),
        Gradient::Point.new(1, Color::RGB.new(255, 128, 0), 0.0)
      )
map.interpolate(0.5)
# => #<Point 50.0 #80808080>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "gradient"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install gradient
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/zeeraw/gradient. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgments
Valek Filippov and the RE-lab team decoded the `.grd` file format and provided
an [initial parser implementation](https://gitorious.org/re-lab/graphics/source/781a65604d405f29c2da487820f64de8ddb0724d:photoshop/grd).
[Andy Boughton](https://github.com/abought) later created an [implementation in python](https://github.com/abought/grd_to_cmap) which is the base for this library's implementation.
