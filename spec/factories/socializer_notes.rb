# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_note, class: Socializer::Note do
    author_id 1
  end
end
