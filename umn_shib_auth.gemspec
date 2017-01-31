# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "umn_shib_auth/version"

Gem::Specification.new do |s|
  s.name        = "umn_shib_auth"
  s.version     = UmnShibAuth::VERSION
  s.authors     = ["ASR"]
  s.email       = ["asrweb@umn.edu"]
  s.homepage    = ""
  s.summary     = %q{UmnShibAuth is an authentication plugin for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.}
  s.description = %q{UmnShibAuth is an authentication plugin for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.  This plugin should work for all versions of rails--it's been used in Rails 2 through 5.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "activesupport", "~> 5.0.0"
  s.add_development_dependency "actionpack", "~> 5.0.0"
  s.add_development_dependency "rspec", "~> 3.5.0"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "overcommit"
end
