lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/asakusa_satellite/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-asakusa_satellite"
  spec.version       = Ruboty::AsakusaSatellite::VERSION
  spec.authors       = ["mallowlabs"]
  spec.email         = ["mallowlabs@gmail.com"]
  spec.summary       = "AsakusaSatellite adapter for Ruboty."
  spec.homepage      = "https://github.com/codefirst/ruboty-asakusa_satellite"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruboty"
#  spec.add_dependency "socket.io-client-simple", "~> 1.1.3"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
