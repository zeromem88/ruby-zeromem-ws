
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zeromem/ws/version"

Gem::Specification.new do |spec|
  spec.name          = "zeromem-ws"
  spec.version       = Zeromem::Ws::VERSION
  spec.authors       = ["zeromem88"]
  spec.email         = ["zeromem2@gmail.com"]

  spec.summary       = %q{Extended websocket client based on Movitto/rjr package}
  spec.description   = %q{Eliminates performance degradation of Movitto/rjr websocket json-rpc client under heavy load}
  spec.homepage      = "https://github.com/zeromem88/ruby-zeromem-ws"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "em-websocket", "~> 0.5.1"
  spec.add_dependency "em-websocket-client", "~> 0.1.2"
  spec.add_dependency "rjr", ">= 0.19.3"
end
