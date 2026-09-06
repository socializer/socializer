# frozen_string_literal: true

SimpleCov.start "rails" do
  enable_coverage :branch # Only supported for Ruby >= 2.5

  # Add source groups
  group "Decorators", "app/decorators"
  # group "Services", %w(app/services)
  group("Services")   { |src| src.filename.include?("/services") }
  group "Validators", "app/validators"

  # Exclude these paths from analysis
  skip "vendor"
  skip "bundle"
end
