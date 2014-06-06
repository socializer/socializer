# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_comment, class: Socializer::Comment do
    content 'This is a comment'
    association :activity_author, factory: :socializer_activity_object_person
  end
end
