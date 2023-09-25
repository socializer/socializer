# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :socializer_membership, class: "Socializer::Membership" do
    active { true }
    group strategy: :create
    activity_member factory: %i[activity_object_person]
  end
end
