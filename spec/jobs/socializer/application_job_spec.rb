# frozen_string_literal: true

require "rails_helper"

module Socializer
  # rubocop:disable RSpec/EmptyExampleGroup
  RSpec.describe ApplicationJob do
    include ActiveJob::TestHelper
  end
  # rubocop:enable RSpec/EmptyExampleGroup
end
