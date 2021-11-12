# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'x_road/version'

Gem::Specification.new do |spec|
  spec.name          = "x_road"
  spec.version       = XRoad::VERSION
  spec.authors       = ["Priit Tark", "Janno Siilbek"]
  spec.email         = ["priit@gitlab.eu"]

  spec.summary       = %q{Communication with X-Road security server}
  spec.description   = %q{Communication with X-Road security server, feel free to add producer service classes}
  spec.homepage      = "https://github.com/gitlabeu/x_road"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'uuidtools', '~> 2.1'
  spec.add_dependency 'savon', '~> 2.11'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
end
