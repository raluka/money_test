# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'monney'
  s.version       = '0.0.0'
  s.date          = '2015-11-17'
  s.summary       = "Perform currency conversion and arithmetics with different currencies"
  s.description   = "monney converter"
  s.authors       = ["Raluca Badoi"]
  s.email         = 'badoi.raluca@gmail.com'
  s.homepage      = ''
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
end
