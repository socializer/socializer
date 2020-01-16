# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe VERSION do
    let(:version) { subject }

    let(:gemspec_path) { Engine.root.join("socializer.gemspec").to_s }
    let(:specification) { Gem::Specification.load(gemspec_path) }

    it { is_expected.to be_a String }
    it { is_expected.to match_regex(/\d+.\d+.\d+(-[a-zA-Z0-9]+)*/) }
    it { is_expected.not_to be_nil }

    it { expect(version.frozen?).to be true }
    it { expect(version).to eq(specification.version.to_s) }
  end
end
