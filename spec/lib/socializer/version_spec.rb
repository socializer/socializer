# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe VERSION do
    it { is_expected.to be_a String }
    it { is_expected.to match_regex(/\d+.\d+.\d+(-[a-zA-Z0-9]+)*/) }
    it { is_expected.to_not be_nil }
  end
end
