require "rails_helper"

module Socializer
  # rubocop:disable RSpec/EmptyExampleGroup
  RSpec.describe ApplicationJob, type: :job do
    include ActiveJob::TestHelper
  end
  # rubocop:enable RSpec/EmptyExampleGroup
end
