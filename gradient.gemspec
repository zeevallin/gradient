# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gradient/version"

Gem::Specification.new do |spec|
  spec.name          = "gradient"
  spec.version       = Gradient::VERSION
  spec.authors       = ["Philip Vieira"]
  spec.email         = ["zee@vall.in"]

  spec.summary       = %q{Library for dealing with color gradients in ruby}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/zeeraw/gradient"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "color", "~> 1.8"
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'scanf', '~> 1.0'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "ruby-prof"
end
