# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "taskr/version"

Gem::Specification.new do |s|
  s.name        = "taskr"
  s.version     = Taskr::VERSION
  s.authors     = ["Khaja Minhajuddin"]
  s.email       = ["minhajuddin@cosmicvent.com"]
  s.homepage    = ""
  s.summary     = %q{A simple command line task manager}
  s.description = %q{A simple yet powerful task manager for all your tasks}

  s.rubyforge_project = "taskr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
