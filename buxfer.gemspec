# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{buxfer}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Wells"]
  s.date = %q{2009-12-28}
  s.description = %q{A library providing access to buxfer (www.buxfer.com) API based on HTTParty.}
  s.email = %q{}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README", "lib/buxfer.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README", "Rakefile", "lib/buxfer.rb", "buxfer.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Buxfer", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{buxfer}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A library providing access to buxfer (www.buxfer.com) API based on HTTParty.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0", "= 2.3.4"])
      s.add_runtime_dependency(%q<httparty>, [">= 0", "= 0.5.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0", "= 2.3.4"])
      s.add_dependency(%q<httparty>, [">= 0", "= 0.5.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0", "= 2.3.4"])
    s.add_dependency(%q<httparty>, [">= 0", "= 0.5.0"])
  end
end
