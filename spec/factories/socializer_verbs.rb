# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_verb, class: Socializer::Verb do
    sequence(:display_name) { |n| "post#{n}" }
  end
end
