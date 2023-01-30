# frozen_string_literal: true

# Maintain your gem's version:
require_relative "lib/socializer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "socializer"
  spec.version       = Socializer::VERSION
  spec.authors       = ["Dominic Goulet"]
  spec.email         = ["dominic.goulet@froggedsoft.com"]
  spec.homepage      = "http://www.froggedsoft.com"
  spec.summary       = "Make your project social."
  spec.description   = "Add social network capabilities to your projects."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # "allowed_push_host" to allow pushing to a single host or delete this "
  # section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/socializer/socializer"
  # spec.metadata["changelog_uri"] = "TODO: CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 3.2.0"

  spec.add_runtime_dependency("bcrypt", "~> 3.1.16")
  spec.add_runtime_dependency("bootstrap-sass", "~> 3.4.1")
  spec.add_runtime_dependency("coffee-rails", "~> 5.0.0")
  spec.add_runtime_dependency("country_select", "~> 8.0.0")
  spec.add_runtime_dependency("draper", "~> 4.0.2")
  spec.add_runtime_dependency("elasticsearch-rails", "~> 7.2.0")
  spec.add_runtime_dependency("enumerize", "~> 2.5.0")
  # spec.add_runtime_dependency("jquery-rails", "~> 4.3.3")
  # Added "jquery-ui-rails" for drag and drop
  spec.add_runtime_dependency("jquery-ui-rails", "~> 6.0.1")
  spec.add_runtime_dependency("omniauth", "~> 2.1.0")
  spec.add_runtime_dependency("omniauth-facebook", "~> 9.0.0")
  spec.add_runtime_dependency("omniauth-identity", "~> 3.0.9")
  spec.add_runtime_dependency("omniauth-linkedin", "~> 0.2.0")
  spec.add_runtime_dependency("omniauth-openid", "~> 2.0.1")
  spec.add_runtime_dependency("omniauth-rails_csrf_protection")
  spec.add_runtime_dependency("omniauth-twitter", "~> 1.4.0")
  spec.add_runtime_dependency("rails", "~> 7.0.2")
  spec.add_runtime_dependency("sass-rails", "~> 6.0.0")
  spec.add_runtime_dependency("simple_form", "~> 5.2.0")
  spec.add_runtime_dependency("uglifier", ">= 4.1.19")
end
