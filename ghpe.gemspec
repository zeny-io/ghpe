# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghpe/version'

Gem::Specification.new do |spec|
  spec.name          = 'ghpe'
  spec.version       = Ghpe::VERSION
  spec.authors       = ['Sho Kusano']
  spec.email         = ['sho-kusano@zeny.io']

  spec.summary       = ''
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/zeny-io/ghpe'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'

  spec.add_dependency 'octokit', '~> 4.6'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'net-http-persistent', '~> 2.9'
end
