require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonPhoneDecorator, type: :decorator do
    let(:phone) { create(:person_phone, label: :phone) }
    let(:decorated_phone) { PersonPhoneDecorator.new(phone) }

    describe "label_and_number" do
      let(:label) { "Phone : 6666666666" }
      it { expect(decorated_phone.label_and_number).to eq(label) }
    end
  end
end
