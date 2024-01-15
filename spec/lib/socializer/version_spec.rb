# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe VERSION do
    subject(:version) { Socializer::VERSION }

    let(:gemspec_path) { Engine.root.join("socializer.gemspec").to_s }
    let(:specification) { Gem::Specification.load(gemspec_path) }

    specify { is_expected.to be_a String }
    specify { is_expected.to match_regex(/\d+.\d+.\d+(-[a-zA-Z0-9]+)*/) }
    specify { is_expected.not_to be_nil }

    specify { expect(version.frozen?).to be true }
    specify { expect(version).to eq(specification.version.to_s) }
  end
end
