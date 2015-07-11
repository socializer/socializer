require "rails_helper"

module Socializer
  RSpec.describe AddDefaultCircles, type: :service do
    describe "when the person argument is nil" do
      context ".new should raise an ArgumentError" do
        let(:add_default_circles) { AddDefaultCircles.new(person: nil) }
        it { expect { add_default_circles }.to raise_error(ArgumentError) }
      end

      context ".perform should raise an ArgumentError" do
        let(:add_default_circles) { AddDefaultCircles.perform(person: nil) }
        it { expect { add_default_circles }.to raise_error(ArgumentError) }
      end
    end

    describe "when the person argument is the wrong type" do
      let(:add_default_circles) { AddDefaultCircles.new(person: Activity.new) }
      it { expect { add_default_circles }.to raise_error(ArgumentError) }
    end

    context ".perform" do
      let(:person) { build(:person_circles) }
      let(:circles) { person.activity_object.circles }

      before do
        AddDefaultCircles.perform(person: person)
      end

      it { expect(person.activity_object.circles.size).to eq(4) }
      it { expect(circles.first.display_name).to eq("Friends") }
      it { expect(circles.second.display_name).to eq("Family") }
      it { expect(circles.third.display_name).to eq("Acquaintances") }
      it { expect(circles.fourth.display_name).to eq("Following") }
    end
  end
end
