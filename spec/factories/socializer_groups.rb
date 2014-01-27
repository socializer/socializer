# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group, class: Socializer::Group do
    author_id 1
    name 'public group'
    privacy_level 1
  end
end
