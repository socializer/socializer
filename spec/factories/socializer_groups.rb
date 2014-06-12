# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group, class: Socializer::Group do
    sequence(:name) { |n| "Public group #{n}" }
    privacy_level :public
    association :activity_author, factory: :socializer_activity_object_person
  end
end
