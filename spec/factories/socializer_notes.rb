# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_note, class: Socializer::Note do
    association :activity_author, factory: :socializer_activity_object_person
    content "This is a note"
  end
end
