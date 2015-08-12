require "rails_helper"

module Socializer
  RSpec.describe PersonEducationDecorator, type: :decorator do
    let(:education) { create(:person_education) }
    let(:decorated_education) { PersonEducationDecorator.new(education) }

    describe "ended_on" do
      context "is nil" do
        it { expect(decorated_education.ended_on).to eq(nil) }
      end

      context "is a date" do
        let(:date) { Date.new(2015, 12, 3) }
        let(:education) { create(:person_education, ended_on: date) }
        let(:ended_on) { date.to_s(:long_ordinal) }

        it { expect(decorated_education.ended_on).to eq(ended_on) }
      end
    end

    describe "started_on" do
      let(:started_on) { Date.new(2012, 12, 3).to_s(:long_ordinal) }

      it { expect(decorated_education.started_on).to eq(started_on) }
    end

    describe "started_on_to_ended_on" do
      let(:started_on) { Date.new(2012, 12, 3).to_s(:long_ordinal) }

      context "when ended_on is nil" do
        let(:value) { "#{started_on} - present" }

        it { expect(decorated_education.started_on_to_ended_on).to eq(value) }
      end

      context "when ended_on is a date" do
        let(:date) { Date.new(2015, 12, 3) }

        let(:education) do
          create(:person_education, ended_on: date, current: false)
        end

        let(:ended_on) { date.to_s(:long_ordinal) }
        let(:value) { "#{started_on} - #{ended_on}" }

        it { expect(decorated_education.started_on_to_ended_on).to eq(value) }
      end
    end
  end
end
