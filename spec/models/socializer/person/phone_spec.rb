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
      specify { is_expected.to validate_presence_of(:number) }
    end

    specify do
      is_expected.to define_enum_for(:category)
        .with_values(home: 1, work: 2)
        .backed_by_column_of_type(:integer)
        .with_prefix
        .with_default(:home)
        .validating(allowing_nil: false)
    end

    specify do
      is_expected.to define_enum_for(:label)
        .with_values(phone: 1, mobile: 2, fax: 3)
        .backed_by_column_of_type(:integer)
        .with_prefix
        .with_default(:phone)
        .validating(allowing_nil: false)
    end
  end
end
