# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "requester/version"

Gem::Specification.new do |spec|
  spec.name          = "requester"
  spec.version       = Requester::VERSION
  spec.authors       = ["Jason Cummings"]
  spec.email         = []

  spec.summary       = %q{ foo }
  spec.description   = %q{ foo }
  spec.homepage      = "https://github.com/jsncmgs1/requester"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.files = Dir["{bin,lib}/**/*", "README.md"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_dependency 'rails', '~> 5.0'
end
