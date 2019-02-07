# frozen_string_literal: true

require "database_cleaner"

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?

      raise(<<-MSG)

        Delete line `config.use_transactional_fixtures = true` from
        rails_helper.rb (or set it to false) to prevent uncommitted
        transactions being used in JavaScript-dependent specs.

        During testing, the Ruby app server that the JavaScript browser driver
        connects to uses a different database connection to the database
        connection used by the spec.

        This Ruby app server database connection would not be able to see data
        that has been setup by the spec"s database connection inside an
        uncommitted transaction.

        Disabling the use_transactional_fixtures setting helps avoid
        uncommitted transactions in JavaScript-dependent specs, meaning that
        the Ruby app server database connection can see any data set up by the
        specs.

      MSG

    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
