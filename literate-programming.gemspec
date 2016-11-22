# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'literate/programming/version'

Gem::Specification.new do |spec|
  spec.name          = 'literate-programming'
  spec.version       = Literate::Programming::VERSION
  spec.authors       = %w!pixie-grasper!
  spec.email         = %w!himajinn13sei@gmail.com!

  spec.summary       = %q{Literate Programming for Ruby / Markdown.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/pixie-grasper/literate-programming'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/).find_all do |path|
    not File.basename(path).match %r!^\.!
  end
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
