# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_activity_field, :class => 'ActivityField' do
    content "MyText"
    activity nil
  end
end
