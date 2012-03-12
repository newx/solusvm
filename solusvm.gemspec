# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "solusvm/version"

Gem::Specification.new do |s|
  s.name    = %q{solusvm}
  s.version = Solusvm::VERSION

  s.authors     = ["Justin Mazzi"]
  s.email       = ["jmazzi@gmail.com"]
  s.homepage    = "http://www.site5.com"
  s.summary     = "Wrapper for the SolusVM Admin::API"
  s.description = "Solusvm allows for easy interaction with the SolusVM Admin::API."

  s.rubyforge_project = "solusvm"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]

  s.add_runtime_dependency 'xml-simple', '~> 1.1.1'
  s.add_runtime_dependency 'thor', '~> 0.14.6'
  s.add_runtime_dependency 'faraday', '~> 0.8.0rc2'
  s.add_runtime_dependency 'jruby-openssl' if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'redgreen', '~> 1.2.2'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'
  s.add_development_dependency 'vcr', '~> 2.0.0'
  s.add_development_dependency 'mocha', '~> 0.10.3'
  s.add_development_dependency 'rdoc', '~> 3.12'
  s.add_development_dependency 'rake', '~> 0.9.2.2'
end
