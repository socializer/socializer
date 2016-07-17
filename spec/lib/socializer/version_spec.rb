# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe VERSION do
    it { is_expected.to be_a String }
    it { is_expected.to match_regex(/\d+.\d+.\d+(-[a-zA-Z0-9]+)*/) }
    it { is_expected.not_to be_nil }

    it { expect(Socializer::VERSION.frozen?).to be true }
  end
end
