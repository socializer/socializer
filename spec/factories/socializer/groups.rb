# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :group, class: "Socializer::Group" do
    sequence(:display_name) { |n| "Public group #{n}" }
    privacy { :public }
    activity_author factory: %i[activity_object_person]
  end
end
