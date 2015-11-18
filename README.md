# Gradient
Library for dealing with color gradients in ruby

## Usage

### Import Adobe Photoshop Gradient (`.grd`) files
For many artists a preferred way of creating gradients is through Photoshop.
You are able to parse `.grd` files and turn them in to a hash of `Gradient::Map` objects.

```ruby
Gradient::GRD.parse("./kiwi.grd")
# => {"Kiwi" => <Gradient::Map:0x00000000000000
#   @points=[
#     #<Gradient::Point:0x007fae248a9358 @color=RGB [#3d1103], @location=0.0>,
#     #<Gradient::Point:0x007fae248a9308 @color=RGB [#29860d], @location=0.386>,
#     #<Gradient::Point:0x007fae248a92b8 @color=RGB [#a0cb1b], @location=0.84>,
#     #<Gradient::Point:0x007fae248a9268 @color=RGB [#f3f56e], @location=0.927>,
#     #<Gradient::Point:0x007fae248a9218 @color=RGB [#ffffff], @location=1.0>
#   ],
#   @opacity_points=[
#     #<Gradient::OpacityPoint:0x007fb32116c700 @location=0.0, @opacity=100.0>,
#     #<Gradient::OpacityPoint:0x007fb32116c6b0 @location=1.0, @opacity=100.0>
#   ]>
# }
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
Bug reports and pull requests are welcome on GitHub at https://github.com/zeeraw/gradient. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgments
Valek Filippov and the RE-lab team decoded the `.grd` file format and provided
an [initial parser implementation](https://gitorious.org/re-lab/graphics/source/781a65604d405f29c2da487820f64de8ddb0724d:photoshop/grd).
[Andy Boughton](https://github.com/abought) later created an [implementation in python](https://github.com/abought/grd_to_cmap) which is the base for this library's implementation.
