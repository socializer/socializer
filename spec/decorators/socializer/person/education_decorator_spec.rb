# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::EducationDecorator, type: :decorator do
    let(:education) { create(:person_education) }
    let(:decorated_education) { described_class.new(education) }

    describe "ended_on" do
      context "when nil" do
        specify { expect(decorated_education.ended_on).to eq(nil) }
      end

      context "when it is a date" do
        let(:date) { Date.new(2015, 12, 3) }
        let(:education) { create(:person_education, ended_on: date) }
        let(:ended_on) { date.to_s(:long_ordinal) }

        specify { expect(decorated_education.ended_on).to eq(ended_on) }
      end
    end

    describe "formatted_education" do
      context "with major_or_field_of_study" do
        let(:education_value) do
          "Hard Knocks<br>" \
            "Slacking<br>" \
            "#{decorated_education.started_on_to_ended_on}"
        end

        specify do
          expect(decorated_education.formatted_education)
            .to eq(education_value)
        end
      end

      context "with no major_or_field_of_study" do
        let(:education) do
          create(:person_education, major_or_field_of_study: nil)
        end

        let(:education_value) do
          "Hard Knocks<br>" \
            "#{decorated_education.started_on_to_ended_on}"
        end

        specify do
          expect(decorated_education.formatted_education)
            .to eq(education_value)
        end
      end
    end

    describe "started_on" do
      let(:started_on) { Date.new(2012, 12, 3).to_s(:long_ordinal) }

      specify { expect(decorated_education.started_on).to eq(started_on) }
    end

    describe "started_on_to_ended_on" do
      let(:started_on) { Date.new(2012, 12, 3).to_s(:long_ordinal) }

      context "when ended_on is nil" do
        let(:value) { "#{started_on} - present" }

        specify do
          expect(decorated_education.started_on_to_ended_on).to eq(value)
        end
      end

      context "when ended_on is a date" do
        let(:date) { Date.new(2015, 12, 3) }

        let(:education) do
          create(:person_education, ended_on: date, current: false)
        end

        let(:ended_on) { date.to_s(:long_ordinal) }
        let(:value) { "#{started_on} - #{ended_on}" }

        specify do
          expect(decorated_education.started_on_to_ended_on).to eq(value)
        end
      end
    end
  end
end
