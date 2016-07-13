# frozen_string_literal: true
require "i18n/tasks"

RSpec.describe "I18n" do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:missing_keys) { i18n.missing_keys }
  let(:unused_keys) { i18n.unused_keys }

  let(:missing_keys_message) do
    "Missing #{missing_keys.leaves.count} i18n keys, run " \
    "`i18n-tasks missing` to show them"
  end

  let(:unused_keys_message) do
    "#{unused_keys.leaves.count} unused i18n keys, run " \
    "`i18n-tasks unused` to show them"
  end

  it "does not have missing keys" do
    expect(missing_keys).to be_empty, missing_keys_message
  end

  it "does not have unused keys" do
    expect(unused_keys).to be_empty, unused_keys_message
  end
end
