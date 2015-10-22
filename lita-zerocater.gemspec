Gem::Specification.new do |spec|
  spec.name          = 'lita-zerocater'
  spec.version       = '0.8.0'
  spec.authors       = ['Eric Sigler']
  spec.email         = ['me@esigler.com']
  spec.description   = 'A ZeroCater menu lookup plugin for Lita'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/esigler/lita-zerocater'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.4'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'unidecoder'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'
end
