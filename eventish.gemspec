# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventish/version'

Gem::Specification.new do |spec|
  spec.name          = 'eventish'
  spec.version       = Eventish::VERSION
  spec.summary       = 'Yet another events library'
  spec.description   = 'Rails events made simple'
  spec.required_ruby_version = '>= 2.6.0'

  spec.license       = 'MIT'
  spec.authors       = ['Mattia Roccoberton']
  spec.email         = 'mat@blocknot.es'
  spec.homepage      = 'https://github.com/blocknotes/eventish'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 6.0'
end
