# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/tablelocks/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-tablelocks"
  spec.version       = Activerecord::Tablelocks::VERSION
  spec.authors       = ["Sernin van de Krol"]
  spec.email         = ["serninpc@paneidos.net"]
  spec.description   = %q{This gem enables the use of database specific table locks when saving or destroying your ActiveRecord objects. This ensures no race conditions exist when using e.g. validates_uniqueness_of.}
  spec.summary       = %q{Use native table locks in your ActiveRecord models}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.2.0"

  spec.add_development_dependency "bundler", ">= 1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "railties"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
