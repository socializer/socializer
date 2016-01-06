require "rails_helper"

module Socializer
  RSpec.describe AudienceList, type: :service do
    describe "when the person argument is nil" do
      context ".new should raise an ArgumentError" do
        let(:audience_list) { AudienceList.new(person: nil, query: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end

      context ".call should raise an ArgumentError" do
        let(:audience_list) { AudienceList.call(person: nil, query: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    describe "when the person argument is the wrong type" do
      let(:audience_list) { AudienceList.new(person: Activity.new) }
      it { expect { audience_list }.to raise_error(ArgumentError) }
    end

    context ".call" do
      let(:person) { create(:person_circles) }
      let(:public) { { id: "public", name: "Public" } }
      let(:circles) { { id: "circles", name: "Circles" } }

      before do
        AddDefaultCircles.call(person: person)
      end

      context "with no query" do
        let(:audience_list) do
          AudienceList.new(person: person, query: nil).call
        end

        it { expect(audience_list).to be_kind_of(Array) }

        it "has the :id, :name, and :icon keys" do
          expect(audience_list.each).to all(include(:id, :name, :icon))
        end

        it { expect(audience_list.first).to include(public) }
        it { expect(audience_list.second).to include(circles) }

        it "contains the persons circles" do
          circles = []
          circles << "Public" << "Circles"
          circles.concat(person.circles.pluck(:display_name))

          expect(audience_list.all? { |item| circles.include?(item[:name]) })
            .to be true
        end
      end

      context "with query" do
        let(:audience_list) do
          AudienceList.new(person: person, query: "friends").call
        end

        it { expect(audience_list).to be_kind_of(Array) }
        it { expect(audience_list.count).to eq(3) }

        it "has the :id, :name, and :icon keys" do
          expect(audience_list.each).to all(include(:id, :name, :icon))
        end

        it { expect(audience_list.first).to include(public) }
        it { expect(audience_list.second).to include(circles) }

        it "contains the persons circles" do
          circles = []
          circles << "Public" << "Circles"
          friends = person.circles.with_display_name(name: "Friends")
          circles.concat(friends.pluck(:display_name))

          expect(audience_list.all? { |item| circles.include?(item[:name]) })
            .to be true
        end
      end
    end
  end
end
