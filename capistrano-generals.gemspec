# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/generals/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-generals"
  spec.version       = Capistrano::Generals::VERSION
  spec.authors       = ["Stef Schenkelaars"]
  spec.email         = ["stef.schenkelaars@gmail.com"]
  spec.summary       = "Some general capistrano tasks which are commonly used"
  spec.description   = "Some general capistrano tasks which are commonly used"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.1"
  spec.add_dependency "sshkit", ">= 1.2.0"

  spec.add_development_dependency "rake"
end
