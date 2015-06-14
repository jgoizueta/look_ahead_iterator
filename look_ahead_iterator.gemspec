# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'look_ahead_iterator/version'

Gem::Specification.new do |spec|
  spec.name          = "look_ahead_iterator"
  spec.version       = LookAheadIterator::VERSION
  spec.authors       = ["Javier Goizueta"]
  spec.email         = ["jgoizueta@gmail.com"]
  spec.summary       = %q{Iterator with look ahead operation}
  spec.description   = %q{Look ahead when iterating over an enumerable collection}
  spec.homepage      = "https://github.com/jgoizueta/look_ahead_iterator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
