# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Services::ServiceBase, type: :service do
    let(:group) { build(:group) }
    let(:person) { build(:person) }

    context "when the group and person arguments are nil" do
      describe ".new should raise an ArgumentError" do
        let(:service) { described_class.new(group: nil, person: nil) }

        it { expect { service }.to raise_error(ArgumentError) }
      end
    end

    context "when the group argument is nil" do
      describe ".new should raise an ArgumentError" do
        let(:service) { described_class.new(group: nil, person:) }

        it { expect { service }.to raise_error(ArgumentError) }
      end
    end

    context "when the person argument is nil" do
      describe ".new should raise an ArgumentError" do
        let(:service) { described_class.new(group:, person: nil) }

        it { expect { service }.to raise_error(ArgumentError) }
      end
    end

    describe ".call" do
      let(:service) do
        described_class.new(group:, person:).call
      end

      it { expect { service }.to raise_error(NotImplementedError) }
    end
  end
end
