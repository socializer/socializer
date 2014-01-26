# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_audience, class: Socializer::Audience do
    privacy_level 1
    activity_id 1
    activity_object_id 1
  end
end
