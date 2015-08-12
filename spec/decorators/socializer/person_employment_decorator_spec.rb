require "rails_helper"

module Socializer
  RSpec.describe PersonEmploymentDecorator, type: :decorator do
    let(:employment) { create(:person_employment) }
    let(:decorated_employment) { PersonEmploymentDecorator.new(employment) }

    describe "ended_on" do
      context "is nil" do
        it { expect(decorated_employment.ended_on).to eq(nil) }
      end

      context "is a date" do
        let(:date) { Date.new(2015, 12, 3) }
        let(:employment) { create(:person_employment, ended_on: date) }
        let(:ended_on) { date.to_s(:long_ordinal) }

        it { expect(decorated_employment.ended_on).to eq(ended_on) }
      end
    end

    describe "started_on" do
      let(:started_on) { Date.new(2014, 12, 3).to_s(:long_ordinal) }

      it { expect(decorated_employment.started_on).to eq(started_on) }
    end

    describe "started_on_to_ended_on" do
      let(:started_on) { Date.new(2014, 12, 3).to_s(:long_ordinal) }

      context "when ended_on is nil" do
        let(:value) { "#{started_on} - present" }

        it { expect(decorated_employment.started_on_to_ended_on).to eq(value) }
      end

      context "when ended_on is a date" do
        let(:date) { Date.new(2015, 12, 3) }

        let(:employment) do
          create(:person_employment, ended_on: date, current: false)
        end

        let(:ended_on) { date.to_s(:long_ordinal) }
        let(:value) { "#{started_on} - #{ended_on}" }

        it { expect(decorated_employment.started_on_to_ended_on).to eq(value) }
      end
    end
  end
end
