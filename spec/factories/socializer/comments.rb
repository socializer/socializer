# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :comment, class: "Socializer::Comment" do
    content { "This is a comment" }
    activity_author factory: %i[activity_object_person]
  end
end
