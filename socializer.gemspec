# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socializer/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '~> 2.1.5'

  spec.name          = 'socializer'
  spec.version       = Socializer::VERSION
  spec.authors       = ['Dominic Goulet']
  spec.email         = ['dominic.goulet@froggedsoft.com']
  spec.description   = 'Add social network capabilities to your projects.'
  spec.summary       = 'Make your project social.'
  spec.homepage      = 'http://www.froggedsoft.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency('rails',                '~> 4.2.1')
  spec.add_dependency('jquery-rails')
  # Added 'jquery-ui-rails' for drag and drop
  spec.add_dependency('jquery-ui-rails')
  spec.add_dependency('sass-rails',           '~> 5.0.1')
  spec.add_dependency('coffee-rails',         '~> 4.1.0')
  spec.add_dependency('uglifier',             '>= 2.7.1')
  spec.add_dependency('bcrypt',               '~> 3.1.10')
  spec.add_dependency('bootstrap-sass',       '~> 3.3.4.1')
  spec.add_dependency('draper',               '~> 2.1.0')
  spec.add_dependency('elasticsearch-rails',  '~> 0.1.6')
  spec.add_dependency('enumerize',            '~> 0.10.1')
  spec.add_dependency('omniauth',             '~> 1.2.2')
  spec.add_dependency('omniauth-identity',    '~> 1.1.1')
  spec.add_dependency('omniauth-facebook',    '~> 2.0.1')
  spec.add_dependency('omniauth-linkedin',    '~> 0.2.0')
  spec.add_dependency('omniauth-openid',      '~> 1.0.1')
  spec.add_dependency('omniauth-twitter',     '~> 1.1.0')
  spec.add_dependency('simple_form',          '~> 3.1.0')

  spec.add_development_dependency('bundler',              '~> 1.9.1')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('sqlite3',              '~> 1.3.10')
  spec.add_development_dependency('rspec-rails',          '~> 3.1.0')
  spec.add_development_dependency('brakeman',             '~> 3.0.2')
  # spec.add_development_dependency('cucumber-rails',     '~> 1.4.0')
  spec.add_development_dependency('capybara',             '~> 2.4.1')
  spec.add_development_dependency('factory_girl_rails',   '~> 4.5.0')
  spec.add_development_dependency('i18n-tasks',           '~> 0.7.13')
  spec.add_development_dependency('inch',                 '~> 0.5.10')
  spec.add_development_dependency('shoulda-matchers',     '~> 2.8.0')
  spec.add_development_dependency('database_cleaner',     '~> 1.4.0')
  spec.add_development_dependency('rails_best_practices', '~> 1.15.7')
  spec.add_development_dependency('rubocop',              '~> 0.29.1')
end
