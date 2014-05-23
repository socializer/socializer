# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group, class: Socializer::Group do
    sequence(:name) { |n| "Public group#{n}" }
    author_id 1
    privacy_level 1
  end
end
