# https://github.com/colszowka/simplecov#using-simplecov-for-centralized-config
SimpleCov.start "rails" do
  # see https://github.com/colszowka/simplecov/blob/master/lib/simplecov/defaults.rb

  # Add source groups
  add_group "Decorators",  "app/decorators"
  add_group "Services",    "app/services"

  # Exclude these paths from analysis
  add_filter 'vendor'
  add_filter 'bundle'
end
