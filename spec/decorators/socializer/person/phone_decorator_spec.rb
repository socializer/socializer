# frozen_string_literal: true

require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe Person::PhoneDecorator do
    let(:phone) { create(:person_phone, label: :phone) }
    let(:decorated_phone) { described_class.new(phone) }

    describe "label_and_number" do
      let(:label) { "Phone : 6666666666" }

      specify { expect(decorated_phone.label_and_number).to eq(label) }
    end
  end
end
