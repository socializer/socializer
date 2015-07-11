# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_category, class: Socializer::GroupCategory do
    display_name "category"
    association :group, factory: :group
  end
end
