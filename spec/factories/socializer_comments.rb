# frozen_string_literal: true
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment, class: Socializer::Comment do
    content "This is a comment"
    association :activity_author, factory: :activity_object_person
  end
end
