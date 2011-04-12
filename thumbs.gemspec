# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{thumbs}
  s.version = "1.0.0.beta.1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcin Ciunelis"]
  s.date = %q{2011-04-12}
  s.description = %q{}
  s.email = %q{marcin.ciunelis@gmail.com}
  s.executables = ["thumbs"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.textile"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.textile",
    "Rakefile",
    "VERSION",
    "lib/thumbs.rb",
    "lib/thumbs/image.rb",
    "lib/thumbs/images/image_not_found.jpg",
    "lib/thumbs/middleware/content_type.rb",
    "spec/spec_helper.rb",
    "spec/thumbs_spec.rb",
    "thumbs.gemspec"
  ]
  s.homepage = %q{http://github.com/martinciu/thumbs}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Image proxy server that can resize and cache images on the fly. Built in ruby with Goliath API.}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/thumbs_spec.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<goliath>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
      s.add_runtime_dependency(%q<em-synchrony>, [">= 0.3.0.beta.1"])
      s.add_runtime_dependency(%q<em-http-request>, [">= 1.0.0.beta.1"])
      s.add_runtime_dependency(%q<em-files>, [">= 0"])
      s.add_runtime_dependency(%q<lumberjack>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
    else
      s.add_dependency(%q<goliath>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
      s.add_dependency(%q<em-synchrony>, [">= 0.3.0.beta.1"])
      s.add_dependency(%q<em-http-request>, [">= 1.0.0.beta.1"])
      s.add_dependency(%q<em-files>, [">= 0"])
      s.add_dependency(%q<lumberjack>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    end
  else
    s.add_dependency(%q<goliath>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
    s.add_dependency(%q<em-synchrony>, [">= 0.3.0.beta.1"])
    s.add_dependency(%q<em-http-request>, [">= 1.0.0.beta.1"])
    s.add_dependency(%q<em-files>, [">= 0"])
    s.add_dependency(%q<lumberjack>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
  end
end

