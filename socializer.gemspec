# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socializer/version'

Gem::Specification.new do |spec|
  spec.name          = "socializer"
  spec.version       = Socializer::VERSION
  spec.authors       = ["Dominic Goulet"]
  spec.email         = ["dominic.goulet@froggedsoft.com"]
  spec.description   = %q{Add social network capabilities to your projects.}
  spec.summary       = %q{Make your project social.}
  spec.homepage      = "http://www.froggedsoft.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("rails",        "~> 3.2.11")
  spec.add_dependency("omniauth",     "~> 1.1.4")
  spec.add_dependency("jquery-rails")
  spec.add_dependency("bcrypt-ruby",  "~> 3.0.1")

  spec.add_development_dependency("bundler",            "~> 1.3")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("sqlite3",            "~> 1.3.4")
  spec.add_development_dependency("rspec-rails",        "~> 2.13.0")
  spec.add_development_dependency("combustion",         "~> 0.5.0")
  spec.add_development_dependency("cucumber-rails",     "~> 1.3.1")
  spec.add_development_dependency("capybara",           "~> 2.1.0")
  spec.add_development_dependency("factory_girl_rails", "~> 4.2.1")
  spec.add_development_dependency("shoulda-matchers",   "~> 2.0.0")
  spec.add_development_dependency("database_cleaner",   "~> 0.9.1")
end
