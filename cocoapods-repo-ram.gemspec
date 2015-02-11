# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-repo-ram/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-repo-ram"
  spec.version       = CocoapodsRepoRam::VERSION
  spec.authors       = ["Ilton Garcia dos Santos Silveira"]
  spec.email         = ["ilton_unb@hotmail.com"]
  spec.description   = %q{A short description of cocoapods-repo-ram.}
  spec.summary       = %q{A longer description of cocoapods-repo-ram.}
  spec.homepage      = "https://github.com/EXAMPLE/cocoapods-repo-ram"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  #================== GEMs to build it GEM, so its improve the development ==============================
  # RSpec for tests
  spec.add_development_dependency "rspec", "~> 3.1", '>= 3.1.0'
  # Coverage
  spec.add_development_dependency 'simplecov', '~> 0.7', '>= 0.7.1'
  # Create readable attrs values
  spec.add_development_dependency 'faker', '~> 1.4', '>= 1.4.2'

  #================== GEMs to be used when it is called on a project ====================================
  # For real user operator IP (4GeoLoc)
  spec.add_dependency 'curb', "~> 0.8", '>= 0.8.6'
  # HTTP REST Client
  spec.add_dependency "rest-client", '~> 1.7', '>= 1.7.2'
  # Easy JSON create
  spec.add_dependency "multi_json", '~> 1.10', '>= 1.10.1'
end
