# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'word_filter/version'

Gem::Specification.new do |spec|
  spec.name          = "word_filter"
  spec.version       = WordFilter::VERSION
  spec.authors       = ["Huascar Oña"]
  spec.email         = ["huascarking@hotmail.com"]
  spec.description   = %q{A bad word filter for the input text.}
  spec.summary       = %q{A word filter gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
