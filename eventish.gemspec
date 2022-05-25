# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventish/version'

Gem::Specification.new do |spec|
  spec.name          = 'eventish'
  spec.version       = Eventish::VERSION
  spec.summary       = 'Yet another events library'
  spec.description   = 'A simple and composable event library'
  spec.license       = 'MIT'
  spec.authors       = ['Mattia Roccoberton']
  spec.email         = 'mat@blocknot.es'
  spec.homepage      = 'https://github.com/blocknotes/eventish'
  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_development_dependency 'appraisal', '~> 2.4'
end
