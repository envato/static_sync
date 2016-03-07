# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'static_sync/version'

Gem::Specification.new do |gem|
  gem.name          = "static_sync"
  gem.version       = StaticSync::VERSION
  gem.authors       = ["Shanon McQuay"]
  gem.email         = ["shanonmcquay@gmail.com"]
  gem.summary       = %q{Command line tool for uploading static websites to amazon/rackspace.}

  gem.files         = `git ls-files`.split($/)
  gem.bindir        = "bin"
  gem.executables  << "static_sync"
  gem.test_files    = Dir.glob("spec/**/*.rb")
  gem.require_paths = ["lib"]
  gem.has_rdoc      = false

  gem.add_dependency("fog", [">= 1.5.0"])
  gem.add_dependency("mime-types", [">= 3.0"])

  gem.add_development_dependency('rspec', '~> 3.4')
  gem.add_development_dependency('timecop')
end
