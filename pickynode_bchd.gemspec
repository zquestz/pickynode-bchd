# frozen_string_literal: true

require File.expand_path(File.join('..', 'lib', 'pickynode_bchd'), __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pickynode-bchd'
  s.version     = PickynodeBCHD::VERSION
  s.summary     = 'Manage connections to your bchd node'
  s.description = "Some people are picky about the \
bitcoin cash nodes they connect to with bchd."
  s.authors     = ['Josh Ellithorpe']
  s.email       = 'quest@mac.com'
  s.homepage    = 'http://github.com/zquestz/pickynode-bchd'
  s.license     = 'MIT'
  s.executables << 'pickynode-bchd'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'awesome_print', '> 1.8.0'
  s.add_dependency 'base64'
  s.add_dependency 'optimist', '> 3.0.1'
  s.add_dependency 'ostruct'

  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop', '~> 0.88.0'
  s.add_development_dependency 'simplecov', '~> 0.18.5'
end
