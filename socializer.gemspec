# -*- encoding: utf-8 -*-
gem_version = File.read(File.expand_path("../SOCIALIZER_VERSION", __FILE__)).strip

Gem::Specification.new do |s|

  s.name        = 'socializer'
  s.version     = gem_version
  s.summary     = 'Make your project social.'
  s.description = 'Add social network capabilities to your projects.'

  s.author      = 'Dominic Goulet'
  s.email       = 'dominic.goulet@froggedsoft.com'
  s.homepage    = 'http://www.froggedsoft.com'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency('rails',        '3.1.3')
  s.add_dependency('omniauth',     '1.0.1')
  s.add_dependency('jquery-rails', '1.0.19')
  s.add_dependency('bcrypt-ruby',  '3.0.1')

  s.add_development_dependency('sqlite3',     '1.3.4')
  s.add_development_dependency('rspec-rails', '2.13.0')
  s.add_development_dependency('cucumber',    '~> 1.3.1')

  s.license = "MIT"
end
