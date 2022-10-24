# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CircleDecorator do
    let(:circle) { build(:circle) }
    let(:decorated_circle) { described_class.new(circle) }

    describe "ties_count" do
      context "with no ties" do
        specify { expect(decorated_circle.ties_count).to eq("0 people") }
      end

      context "with 1 tie" do
        let(:circle) { create(:circle, :with_ties) }
        let(:decorated_circle) { described_class.new(circle) }

        specify { expect(decorated_circle.ties_count).to eq("1 person") }
      end

      context "with 4 ties" do
        let(:circle) do
          create(:circle, :with_ties, number_of_ties: 4)
        end

        let(:decorated_circle) { described_class.new(circle) }

        specify { expect(decorated_circle.ties_count).to eq("4 people") }
      end
    end
  end
end
