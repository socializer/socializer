# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_audience, class: Socializer::Audience do
    privacy :public
    association :activity, factory: :socializer_activity
    association :activity_object, factory: :socializer_activity_object
  end
end
