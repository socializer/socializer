# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group_category, class: Socializer::GroupCategory do
    group_id 1
    name 'category'
  end
end
