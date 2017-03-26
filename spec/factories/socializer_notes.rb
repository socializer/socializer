# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note, class: Socializer::Note do
    association :activity_author, factory: :activity_object_person
    content "This is a note"
  end
end
