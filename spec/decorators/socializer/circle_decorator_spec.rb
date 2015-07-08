require "rails_helper"

module Socializer
  RSpec.describe CircleDecorator, type: :decorator do
    let(:circle) { build(:socializer_circle) }
    let(:decorated_circle) { CircleDecorator.new(circle) }

    context "ties_count" do
      context "without ties" do
        it { expect(decorated_circle.ties_count).to eq("0 people") }
      end

      context "with 1 tie" do
        let(:circle) { create(:socializer_circle, :with_ties) }
        let(:decorated_circle) { CircleDecorator.new(circle) }

        it { expect(decorated_circle.ties_count).to eq("1 person") }
      end

      context "with 4 ties" do
        let(:circle) { create(:socializer_circle, :with_ties, number_of_ties: 4) }
        let(:decorated_circle) { CircleDecorator.new(circle) }

        it { expect(decorated_circle.ties_count).to eq("4 people") }
      end
    end
  end
end
