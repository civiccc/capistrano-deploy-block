$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'capistrano/deploy_block/version'

Gem::Specification.new do |gem|
  gem.name        = 'capistrano-deploy-block'
  gem.version     = Capistrano::DeployBlock::VERSION
  gem.license     = 'MIT'
  gem.authors     = ['Brigade Engineering', 'Shane da Silva']
  gem.email       = ['eng@brigade.com', 'shane.dasilva@brigade.com']
  gem.description = 'Block deploys via Capistrano'
  gem.summary     = 'Capistrano plugin for blocking deploys'
  gem.homepage    = 'https://github.com/brigade/capistrano_deploy_block'

  gem.files         = Dir['lib/**/*']
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency 'capistrano', '~> 3.1'
end
