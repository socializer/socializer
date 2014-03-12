# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socializer/version'

Gem::Specification.new do |spec|
  spec.name          = 'socializer'
  spec.version       = Socializer::VERSION
  spec.authors       = ['Dominic Goulet']
  spec.email         = ['dominic.goulet@froggedsoft.com']
  spec.description   = %q{Add social network capabilities to your projects.}
  spec.summary       = %q{Make your project social.}
  spec.homepage      = 'http://www.froggedsoft.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency('rails',                '4.0.3')
  spec.add_dependency('jquery-rails')
  # Added 'jquery-ui-rails' for drag and drop
  spec.add_dependency('jquery-ui-rails')
  spec.add_dependency('sass-rails')
  spec.add_dependency('coffee-rails')
  spec.add_dependency('uglifier')
  spec.add_dependency('bcrypt-ruby',          '~> 3.1.2')
  spec.add_dependency('draper',               '~> 1.3.0')
  spec.add_dependency('elasticsearch-rails',  '~> 0.1.0')
  spec.add_dependency('enumerize',            '~> 0.8.0')
  spec.add_dependency('omniauth',             '~> 1.2.1')
  spec.add_dependency('omniauth-identity',    '~> 1.1.1')
  spec.add_dependency('omniauth-facebook',    '~> 1.6.0')
  spec.add_dependency('omniauth-linkedin',    '~> 0.1.0')
  spec.add_dependency('omniauth-openid',      '~> 1.0.1')
  spec.add_dependency('omniauth-twitter',     '~> 1.0.1')
  spec.add_dependency('simple_form',          '~> 3.0.1')
  spec.add_dependency('squeel',               '~> 1.1.0')

  spec.add_development_dependency('bundler',              '~> 1.5.0')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('sqlite3',              '~> 1.3.8')
  spec.add_development_dependency('rspec-rails',          '~> 2.14.0')
  spec.add_development_dependency('brakeman',             '~> 2.4.0')
  # spec.add_development_dependency('cucumber-rails',     '~> 1.4.0')
  spec.add_development_dependency('capybara',             '~> 2.2.0')
  spec.add_development_dependency('factory_girl_rails',   '~> 4.4.0')
  spec.add_development_dependency('shoulda-matchers',     '~> 2.5.0')
  spec.add_development_dependency('database_cleaner',     '~> 1.2.0')
  spec.add_development_dependency('rails_best_practices', '~> 1.15.0')
  spec.add_development_dependency('rubocop',              '~> 0.18.0')
end
