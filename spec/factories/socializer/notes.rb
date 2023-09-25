# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :note, class: "Socializer::Note" do
    activity_author factory: %i[activity_object_person]
    content { "This is a note" }
  end
end
