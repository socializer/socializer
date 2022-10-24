# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Phone do
    let(:phone) { build(:person_phone) }

    it "has a valid factory" do
      expect(phone).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:phones) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:category) }
      specify { is_expected.to validate_presence_of(:label) }
      specify { is_expected.to validate_presence_of(:number) }
    end

    specify do
      expect(phone).to enumerize(:category)
        .in(:home, :work).with_default(:home)
        .with_predicates(true)
        .with_scope(true)
    end

    specify do
      expect(phone).to enumerize(:label)
        .in(:phone, :mobile, :fax).with_default(:phone)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
