# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AddDefaultCircles, type: :service do
    describe "when the person argument is nil" do
      context ".new should raise an Dry::Types::ConstraintError" do
        let(:add_default_circles) { AddDefaultCircles.new(person: nil) }

        it do
          expect { add_default_circles }
            .to raise_error(Dry::Types::ConstraintError)
        end
      end

      context ".call should raise an Dry::Types::ConstraintError" do
        let(:add_default_circles) { AddDefaultCircles.call(person: nil) }

        it do
          expect { add_default_circles }
            .to raise_error(Dry::Types::ConstraintError)
        end
      end
    end

    describe "when the person argument is the wrong type" do
      let(:add_default_circles) { AddDefaultCircles.new(person: Activity.new) }

      it do
        expect { add_default_circles }
          .to raise_error(Dry::Types::ConstraintError)
      end
    end

    context ".call" do
      let(:person) { build(:person_circles) }
      let(:circles) { person.activity_object.circles }

      before do
        AddDefaultCircles.call(person: person)
      end

      it { expect(person.activity_object.circles.size).to eq(4) }
      it { expect(circles.first.display_name).to eq("Friends") }
      it { expect(circles.second.display_name).to eq("Family") }
      it { expect(circles.third.display_name).to eq("Acquaintances") }
      it { expect(circles.fourth.display_name).to eq("Following") }
    end
  end
end
