# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_circle, class: Socializer::Circle do
    sequence(:name) { |n| "Friends no#{n}" }
    content 'This is some content'
    association :activity_author, factory: :socializer_activity_object_person
  end
end
