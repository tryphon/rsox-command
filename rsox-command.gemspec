# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "rsox-command"
  s.version     = "0.0.4"
  s.authors     = ["Alban Peignier"]
  s.email       = ["alban@tryphon.eu"]
  s.homepage    = "http://projects.tryphon.eu/rsox-command"
  s.summary     = %q{Wrapper to run sox}
  s.description = %q{Ruby wrapper to run SoX, a sound command line utility}

  s.rubyforge_project = "rsox-command"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "activesupport", "< 4"
  s.add_runtime_dependency "cocaine"
end
