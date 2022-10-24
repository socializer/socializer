# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AudienceList do
    describe "when the person argument is nil" do
      describe ".new should raise an ArgumentError" do
        let(:audience_list) { described_class.new(person: nil, query: nil) }

        specify { expect { audience_list }.to raise_error(ArgumentError) }
      end

      describe ".call should raise an ArgumentError" do
        let(:audience_list) { described_class.call(person: nil, query: nil) }

        specify { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    describe "when the person argument is the wrong type" do
      let(:audience_list) { described_class.new(person: Activity.new) }

      specify { expect { audience_list }.to raise_error(ArgumentError) }
    end

    describe ".call" do
      let(:person) { create(:person_circles) }
      let(:public) { { id: "public", name: "Public" } }
      let(:circles) { { id: "circles", name: "Circles" } }

      before do
        AddDefaultCircles.call(person:)
      end

      context "with no query" do
        let(:audience_list) do
          described_class.new(person:, query: nil).call
        end

        specify { expect(audience_list).to be_a(Array) }

        it "has the :id, :name, and :icon keys" do
          expect(audience_list.each).to all(include(:id, :name, :icon))
        end

        specify { expect(audience_list.first).to include(public) }
        specify { expect(audience_list.second).to include(circles) }

        it "contains the persons circles" do
          circles = Set.new(%w[Public Circles])
          circles.merge(person.circles.pluck(:display_name))

          expect(audience_list.all? { |item| circles.include?(item[:name]) })
            .to be true
        end
      end

      context "with query" do
        let(:audience_list) do
          described_class.new(person:, query: "friends").call
        end

        specify { expect(audience_list).to be_a(Array) }
        specify { expect(audience_list.count).to eq(3) }

        it "has the :id, :name, and :icon keys" do
          expect(audience_list.each).to all(include(:id, :name, :icon))
        end

        specify { expect(audience_list.first).to include(public) }
        specify { expect(audience_list.second).to include(circles) }

        it "contains the persons circles" do
          circles = Set.new(%w[Public Circles])
          friends = person.circles.with_display_name(name: "Friends")
          circles.merge(friends.pluck(:display_name))

          expect(audience_list.all? { |item| circles.include?(item[:name]) })
            .to be true
        end
      end
    end
  end
end
