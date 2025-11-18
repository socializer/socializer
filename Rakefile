#!/usr/bin/env rake
# frozen_string_literal: true

begin
  require "bundler/setup"
rescue LoadError
  message = "You must `gem install bundler` and `bundle install` " \
            "to run rake tasks"

  Rails.logger.error(message)
  # puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end
begin
  require "rdoc/task"
rescue LoadError
  require "rdoc/rdoc"
  require "rake/rdoctask"
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "Socializer"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

# Rails deprecated rails/tasks/statistics.rake and removed it in 8.2.
# Use `bin/rails stats` instead of the legacy rake task.

Dir[File.join(File.dirname(__FILE__), "tasks/**/*.rake")].each { |f| load f }

Bundler::GemHelper.install_tasks

require "rspec/core"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require "rails/dummy/tasks"

require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.requires << "rubocop-rails"
  task.requires << "rubocop-rspec"
end

require "bundler/gem_tasks"
