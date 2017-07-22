# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Phone, type: :model do
    let(:phone) { build(:person_phone) }

    it "has a valid factory" do
      expect(phone).to be_valid
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to validate_presence_of(:person) }
    end

    it do
      is_expected.to enumerize(:category)
        .in(:home, :work).with_default(:home)
        .with_predicates(true)
        .with_scope(true)
    end

    it do
      is_expected.to enumerize(:label)
        .in(:phone, :mobile, :fax).with_default(:phone)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
