# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :note, class: Socializer::Note do
    association :activity_author, factory: :activity_object_person, strategy: :create
    content { "This is a note" }
  end
end
