# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :group_link, class: "Socializer::Group::Link" do
    display_name { "test" }
    url { "http://test.org" }
    association :group
  end
end
