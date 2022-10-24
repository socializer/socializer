# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AddDefaultCircles do
    describe "when the person argument is nil" do
      describe ".new should raise an ArgumentError" do
        let(:add_default_circles) { described_class.new(person: nil) }

        specify do
          expect { add_default_circles }.to raise_error(ArgumentError)
        end
      end

      describe ".call should raise an ArgumentError" do
        let(:add_default_circles) { described_class.call(person: nil) }

        specify do
          expect { add_default_circles }.to raise_error(ArgumentError)
        end
      end
    end

    describe "when the person argument is the wrong type" do
      let(:add_default_circles) { described_class.new(person: Activity.new) }

      specify { expect { add_default_circles }.to raise_error(ArgumentError) }
    end

    describe ".call" do
      let(:person) { build(:person_circles) }
      let(:circles) { person.activity_object.circles }

      before do
        described_class.call(person:)
      end

      specify { expect(person.activity_object.circles.size).to eq(4) }
      specify { expect(circles.first.display_name).to eq("Friends") }
      specify { expect(circles.second.display_name).to eq("Family") }
      specify { expect(circles.third.display_name).to eq("Acquaintances") }
      specify { expect(circles.fourth.display_name).to eq("Following") }
    end
  end
end
